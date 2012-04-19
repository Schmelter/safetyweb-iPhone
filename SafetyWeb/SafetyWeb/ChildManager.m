//
//  ChildManager.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 * Stores the children downloaded from the website.
 */

#import "ChildManager.h"
#import "SWAppDelegate.h"

@interface ChildManager (PrivateMethods)
+(Account*)initAccountFromJson:(NSDictionary*)jsonAccountDict;
+(NSSet*)initChildAccounts:(NSDictionary *)childJson;
@end


@implementation ChildAccountRequest
@synthesize childId;
@synthesize user;
@synthesize responseBlock;

-(void)performRequest {
    @synchronized(user) {
        Child *child = [user getChildForId:childId];
        if (child != nil && child.lastQueried != nil && [child.lastQueried timeIntervalSinceNow] > -kTwoHourTimeInterval) {
            responseBlock(YES, child, nil);
            self.responseBlock = nil;
            return;
        }
    }
    void(^block)(void) = [^{
        @autoreleasepool {
            SafetyWebRequest *childRequest = [[SafetyWebRequest alloc] init];
            [childRequest request:@"GET" andURL:[NSURL URLWithString:[NSString stringWithFormat:[AppProperties getProperty:@"Endpoint_Child" withDefault:@"No API Endpoint"], childId]] andParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:user.token, @"json", @"id", nil] forKeys:[NSArray arrayWithObjects:@"token", @"type", [childId description], nil]] withCallback:self];
            [childRequest release];
        }
    } copy];
    
    dispatch_async([SWAppDelegate dataModelQ], block);
    [block release];
}

-(void)gotResponse:(id)aResponse {
    NSDictionary *responseDict = (NSDictionary*)aResponse;
    NSString *result = [responseDict objectForKey:@"result"];
    if ([result isEqualToString:@"OK"]) {
        // Parse the response Dictionary
        @synchronized(user) {
            NSSet *childAccounts = [ChildManager initChildAccounts:responseDict];
            
            Child *child = [user getChildForId:childId];
            child.lastQueried = [NSDate date];
            child.accounts = childAccounts;
            [childAccounts release];
            
            responseBlock(YES, child, nil);
        }
    } else {
        responseBlock(NO, nil, nil);
    }
    self.responseBlock = nil;
}
-(void)notGotResponse:(NSError *)aError {
    responseBlock(NO, nil, aError);
    self.responseBlock = nil;
}

-(void)dealloc {
    [childId release];
    [user release];
    [responseBlock release];
    
    [super dealloc];
}

@end


@implementation ChildManager

-(ChildManager*)init {
    // This is a purely static class
    [self release];
    return nil;
}

#pragma mark -
#pragma mark Private static functions
+(Child*)initChildFromJson:(NSDictionary*)jsonChildDict {
    NSManagedObjectContext *context = ((SWAppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    Child *child = [[Child alloc] initWithEntity:[NSEntityDescription entityForName:@"Child" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    
    // Child Id in the JSON is a String... even though it's always a number.  Fix that here.
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    child.childId = [formatter numberFromString:(NSString*)[jsonChildDict objectForKey:@"child_id"]];
    [formatter release];
    
    child.firstName = (NSString*)[jsonChildDict objectForKey:@"first_name"];
    if (![child.firstName isKindOfClass:[NSString class]]) child.firstName = nil;
    child.lastName = (NSString*)[jsonChildDict objectForKey:@"last_name"];
    if (![child.lastName isKindOfClass:[NSString class]]) child.lastName = nil;
    
    // TODO: Parse out the actual address
    child.address = @"The Child's Address";
    
    // TODO: Parse out the actual mobile phone
    child.mobilePhone = @"720-982-6931";
    
    NSString *profilePicUrl = [jsonChildDict objectForKey:@"profile_pic"];
    if ([profilePicUrl isKindOfClass:[NSString class]]) child.profilePicUrl = [[NSURL URLWithString:profilePicUrl] description];
    
    NSDate *lastQueried = [[NSDate alloc] initWithTimeIntervalSince1970:0.0];
    // This looks a little weird, but the lastQueried actually refers to the child specifically being queried
    // Not the child that comes down with the user
    child.lastQueried = lastQueried;
    [lastQueried release];
    
    return child;
}

+(Account*)initAccountFromJson:(NSDictionary*)jsonAccountDict {
    NSManagedObjectContext *context = ((SWAppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    Account *account = [[Account alloc] initWithEntity:[NSEntityDescription entityForName:@"Account" inManagedObjectContext:context] insertIntoManagedObjectContext:context]; 
    
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    account.accountId = [formatter numberFromString:[jsonAccountDict objectForKey:@"account_id"]];
    account.serviceId = [formatter numberFromString:[jsonAccountDict objectForKey:@"service_id"]];
    [formatter release];
    
    NSString *profilePicUrl = [jsonAccountDict objectForKey:@"profile_pic"];
    if ([profilePicUrl isKindOfClass:[NSString class]]) account.profilePicUrl = [[NSURL URLWithString:profilePicUrl] description];
    account.serviceName = [jsonAccountDict objectForKey:@"service_name"];
    if (![account.serviceName isKindOfClass:[NSString class]]) account.serviceName = nil;
    
    NSString *statusStr = [jsonAccountDict objectForKey:@"status"];
    if ([@"PUBLIC" isEqual:statusStr]) {
        account.status = acct_public;
    } else if ([@"PRIVATE" isEqual:statusStr]) {
        account.status = [NSNumber numberWithInt:acct_private];
    } else {
        account.status = [NSNumber numberWithInt:acct_other];
    }
    
    NSString *url = [jsonAccountDict objectForKey:@"url"];
    if ([url isKindOfClass:[NSString class]]) account.url = url;
    NSString *username = [jsonAccountDict objectForKey:@"username"];
    if ([username isKindOfClass:[NSString class]]) account.username = username;
    
    return account;
}

+(NSSet*)initChildAccounts:(NSDictionary *)childJson {
    NSMutableSet *childAccounts = [[NSMutableSet alloc] init];
    @autoreleasepool {
        
        NSDictionary *jsonChildDict = [childJson objectForKey:@"child"];
        if (!jsonChildDict) return childAccounts;
        
        // Go through the childJson, and add it's information to the childDict we already have
        NSDictionary *accountsDict = [childJson objectForKey:@"accounts"];
        if (!accountsDict) return childAccounts;
        
        // Build the accounts, and add them to the child
        NSObject *accountObj = [accountsDict objectForKey:@"account"];
        if ([accountObj isKindOfClass:[NSArray class]]) {
            // Multiple accounts
            for (NSDictionary *jsonAccountDict in (NSArray*)accountObj) {
                Account *account = [self initAccountFromJson:jsonAccountDict];
                [childAccounts addObject:account];
                [account release];
            }
        } else if ([accountObj isKindOfClass:[NSDictionary class]]) {
            Account *account = [self initAccountFromJson:(NSDictionary*)accountObj];
            [childAccounts addObject:account];
            [account release];
        }
        
    }
    return childAccounts;
}

-(void)dealloc {
    [super dealloc];
}

@end

