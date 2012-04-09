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

static NSMutableDictionary* childDict;
static NSMutableArray* childArr;
static NSDate *childrenLastRequested = nil;

@interface ChildManager (PrivateMethods)
+(Child*)initChildFromJson:(NSDictionary*)jsonChildDict;
+(Account*)initAccountFromJson:(NSDictionary*)jsonAccountDict;
+(void)parseChildrenResponse:(NSDictionary*)childrenJson;
+(void)parseChildResponse:(NSDictionary *)childJson;
@end

@implementation ChildIdRequest
@synthesize response;
@synthesize childId;

-(void)performRequest {
    @autoreleasepool {
        @synchronized(childDict) {
            NSLog(@"Time Interval Since Now: %f", [childrenLastRequested timeIntervalSinceNow]);
            if (childrenLastRequested != nil && [childrenLastRequested timeIntervalSinceNow] > -kTwoHourTimeInterval) {
                [response childRequestSuccess:[childDict objectForKey:childId]];
                return;
            }
        }
    
        [ChildManager clearAllChildren];
    
        SafetyWebRequest *childrenRequest = [[SafetyWebRequest alloc] init];
        [childrenRequest setCallbackObj:self];
        UserCredentials *credentials = [UserManager getLastUsedCredentials];
        [childrenRequest request:@"GET" andURL:[NSURL URLWithString:[AppProperties getProperty:@"Endpoint_Children" withDefault:@"No API Endpoint"]] andParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:credentials.userToken, @"json", nil] forKeys:[NSArray arrayWithObjects:@"token", @"type", nil]]];
        [childrenRequest release];
    }
}

-(void)gotResponse:(id)aResponse {
    NSDictionary *responseDict = (NSDictionary*)aResponse;
    NSString *result = [responseDict objectForKey:@"result"];
    if ([result isEqualToString:@"OK"]) {
        // Parse the response dictionary
        @synchronized(childDict) {
            NSDate *oldChildrenLastRequested = childrenLastRequested;
            childrenLastRequested = [[NSDate alloc] init];
            [oldChildrenLastRequested release];
            [ChildManager parseChildrenResponse:responseDict];
            [response childRequestSuccess:[childDict objectForKey:childId]];
        }
    } else {
        [response requestFailure:nil];
    }
}
-(void)notGotResponse:(NSError *)aError {
    [response requestFailure:aError];
}

-(void) dealloc {
    [childId release];
    
    [super dealloc];
}

@end


@implementation AllChildRequest
@synthesize response;

-(void)performRequest {
    @autoreleasepool {
        
        @synchronized(childDict) {
            NSLog(@"Time Interval Since Now: %f", [childrenLastRequested timeIntervalSinceNow]);
            if (childrenLastRequested != nil && [childrenLastRequested timeIntervalSinceNow] > -kTwoHourTimeInterval) {
                [response childrenRequestSuccess:childArr];
                return;
            }
        }
    
        [ChildManager clearAllChildren];
    
        SafetyWebRequest *childrenRequest = [[SafetyWebRequest alloc] init];
        [childrenRequest setCallbackObj:self];
        UserCredentials *credentials = [UserManager getLastUsedCredentials];
        [childrenRequest request:@"GET" andURL:[NSURL URLWithString:[AppProperties getProperty:@"Endpoint_Children" withDefault:@"No API Endpoint"]] andParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:credentials.userToken, @"json", nil] forKeys:[NSArray arrayWithObjects:@"token", @"type", nil]]];
        [childrenRequest release];
    }
}

-(void)gotResponse:(id)aResponse {
    NSDictionary *responseDict = (NSDictionary*)aResponse;
    NSString *result = [responseDict objectForKey:@"result"];
    if ([result isEqualToString:@"OK"]) {
        // Parse the response Dictionary
        @synchronized (childDict) {
            NSDate *oldChildrenLastRequested = childrenLastRequested;
            childrenLastRequested = [[NSDate alloc] init];
            [oldChildrenLastRequested release];
            [ChildManager parseChildrenResponse:responseDict];
            [response childrenRequestSuccess:childArr];
        }
    } else {
        [response requestFailure:nil];
    }
}
-(void)notGotResponse:(NSError *)aError {
    [response requestFailure:aError];
}

-(void)dealloc {
    [super dealloc];
}

@end


@implementation ChildAccountRequest
@synthesize childId;
@synthesize response;

-(void)performRequest {
    @autoreleasepool {
        
        @synchronized(childDict) {
            Child *child = [childDict objectForKey:childId];
            if (child != nil && child.lastQueried != nil && [child.lastQueried timeIntervalSinceNow] > -kTwoHourTimeInterval) {
                [response childRequestSuccess:child];
                return;
            }
        }
    
        SafetyWebRequest *childRequest = [[SafetyWebRequest alloc] init];
        [childRequest setCallbackObj:self];
        UserCredentials *credentials = [UserManager getLastUsedCredentials];
        [childRequest request:@"GET" andURL:[NSURL URLWithString:[NSString stringWithFormat:[AppProperties getProperty:@"Endpoint_Child" withDefault:@"No API Endpoint"], childId]] andParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:credentials.userToken, @"json", @"id", nil] forKeys:[NSArray arrayWithObjects:@"token", @"type", childId, nil]]];
        [childRequest release];
    }
}

-(void)gotResponse:(id)aResponse {
    NSDictionary *responseDict = (NSDictionary*)aResponse;
    NSString *result = [responseDict objectForKey:@"result"];
    if ([result isEqualToString:@"OK"]) {
        // Parse the response Dictionary
        @synchronized(childDict) {
            [ChildManager parseChildResponse:responseDict];
            Child *child = [childDict objectForKey:childId];
            child.lastQueried = [[NSDate alloc] init];
            [response childRequestSuccess:child];
        }
    } else {
        [response requestFailure:nil];
    }
}
-(void)notGotResponse:(NSError *)aError {
    [response requestFailure:aError];
}

-(void)dealloc {
    [childId release];
    
    [super dealloc];
}

@end


@implementation ChildManager

-(ChildManager*)init {
    // This is a purely static class
    [self release];
    return nil;
}

+(void)initialize {
    childDict = [[NSMutableDictionary alloc] init];
    childArr = [[NSMutableArray alloc] init];
}

#pragma mark -
#pragma mark Private static functions
+(Child*)initChildFromJson:(NSDictionary*)jsonChildDict {
    Child *child = [[Child alloc] init];
    
    child.childId = (NSNumber*)[jsonChildDict objectForKey:@"child_id"];
    child.firstName = (NSString*)[jsonChildDict objectForKey:@"first_name"];
    if (![child.firstName isKindOfClass:[NSString class]]) child.firstName = nil;
    child.lastName = (NSString*)[jsonChildDict objectForKey:@"last_name"];
    if (![child.lastName isKindOfClass:[NSString class]]) child.lastName = nil;
    
    // TODO: Parse out the actual address
    child.address = @"The Child's Address";
    
    // TODO: Parse out the actual mobile phone
    child.mobilePhone = @"720-982-6931";
    
    NSString *profilePicUrl = [jsonChildDict objectForKey:@"profile_pic"];
    if ([profilePicUrl isKindOfClass:[NSString class]]) child.profilePicUrl = [NSURL URLWithString:profilePicUrl];
    
    return child;
}

+(Account*)initAccountFromJson:(NSDictionary*)jsonAccountDict {
    Account *account = [[Account alloc] init];
    
    account.accountId = [jsonAccountDict objectForKey:@"account_id"];
    NSString *profilePicUrl = [jsonAccountDict objectForKey:@"profile_pic"];
    if ([profilePicUrl isKindOfClass:[NSString class]]) account.profilePicUrl = [NSURL URLWithString:profilePicUrl];
    account.serviceId = [jsonAccountDict objectForKey:@"service_id"];
    account.serviceName = [jsonAccountDict objectForKey:@"service_name"];
    if (![account.serviceName isKindOfClass:[NSString class]]) account.serviceName = nil;
    
    NSString *statusStr = [jsonAccountDict objectForKey:@"status"];
    if ([@"PUBLIC" isEqual:statusStr]) {
        account.status = acct_public;
    } else if ([@"PRIVATE" isEqual:statusStr]) {
        account.status = acct_private;
    } else {
        account.status = acct_other;
    }
    
    NSString *url = [jsonAccountDict objectForKey:@"url"];
    if ([url isKindOfClass:[NSString class]]) account.url = [NSURL URLWithString:url];
    account.username = [jsonAccountDict objectForKey:@"username"];
    if (![account.username isKindOfClass:[NSString class]]) account.username = nil;
    
    return account;
}

+(void)parseChildrenResponse:(NSDictionary*)childrenJson {
    if (childrenJson == nil) {
        return;
    }
    NSDictionary *childrenDict = [childrenJson objectForKey:@"children"];
    if (childrenDict == nil) {
        return;
    }
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    @synchronized(childDict) {
    NSObject *childObj = [childrenDict objectForKey:@"child"];
        if ([childObj isKindOfClass:[NSArray class]]) {
            // Multiple children
            for (NSDictionary *jsonChildDict in (NSArray*)childObj) {
                Child *child = [self initChildFromJson:jsonChildDict];
            
                [childArr addObject:child];
                [childDict setObject:child forKey:child.childId];
                [child release];
            }
        } else if ([childObj isKindOfClass:[NSDictionary class]]) {
            // Only one child
            NSDictionary *jsonChildDict = (NSDictionary*)childObj;
            Child *child = [self initChildFromJson:jsonChildDict];
        
            [childArr addObject:child];
            [childDict setObject:child forKey:child.childId];
            [child release];
        }
    }
    
    [pool release];
}

+(void)parseChildResponse:(NSDictionary *)childJson {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Go through the childJson, and add it's information to the childDict we already have
    NSDictionary *accountsDict = [childJson objectForKey:@"accounts"];
    if (!accountsDict) return;
    NSDictionary *jsonChildDict = [childJson objectForKey:@"child"];
    if (!jsonChildDict) return;
    // Make sure that we have the child in our childDict, and if not, add them
    Child *child = [childDict objectForKey:[jsonChildDict objectForKey:@"child_id"]];
    @synchronized(childDict) {
        if (!child) {
            child = [self initChildFromJson:jsonChildDict];
            [childArr addObject:child];
            [childDict setObject:child forKey:child.childId];
            [child release];
        }
    }
    
    // Build the accounts, and add them to the child
    NSObject *accountObj = [accountsDict objectForKey:@"account"];
    if ([accountObj isKindOfClass:[NSArray class]]) {
        // Multiple accounts
        for (NSDictionary *jsonAccountDict in (NSArray*)accountObj) {
            Account *account = [self initAccountFromJson:jsonAccountDict];
            [child addAccount:account];
            [account release];
        }
    } else if ([accountObj isKindOfClass:[NSDictionary class]]) {
        Account *account = [self initAccountFromJson:(NSDictionary*)accountObj];
        [child addAccount:account];
        [account release];
    }
    
    [pool release];
}

#pragma mark -
#pragma mark ChildManager Public static functions

+(void)clearAllChildren {
    @synchronized (childDict) {
        [childDict removeAllObjects];
        [childArr removeAllObjects];
    }
}

+(void)requestAllChildren:(AllChildRequest*)request {
    [request performSelectorInBackground:@selector(performRequest) withObject:nil];
}

+(void)requestChildForId:(ChildIdRequest*)request {
    [request performSelectorInBackground:@selector(performRequest) withObject:nil];
}

+(void)requestChildAccount:(ChildAccountRequest*)request {
    [request performSelectorInBackground:@selector(performRequest) withObject:nil];
}

-(void)dealloc {
    [super dealloc];
}

@end


@implementation Child
@synthesize childId;
@synthesize firstName;
@synthesize lastName;
@synthesize profilePicUrl;
@synthesize address;
@synthesize mobilePhone;
@synthesize lastQueried;

-(Child*)init {
    self = [super init];
    if (self) {
        accountArr = [[NSMutableArray alloc] init];
        accountDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)addAccount:(Account*)account {
    // Check if it already exists
    if ([accountDict objectForKey:account.accountId]) return;
    [accountDict setObject:account forKey:account.accountId];
    [accountArr addObject:account];
}

-(Account*)getAccountForId:(NSNumber*)accountId {
    return [accountDict objectForKey:accountId];
}

-(NSArray*)getAllAccounts {
    return accountArr;
}

#pragma mark -
#pragma mark IsEqual and Hash functions
-(BOOL)isEqual:(id)object {
    return self == object || [((Child*)object).childId isEqual:childId];
}

-(NSUInteger)hash {
    return [childId unsignedIntValue];
}

-(void)dealloc {
    [childId release];
    [firstName release];
    [lastName release];
    [profilePicUrl release];
    [address release];
    [mobilePhone release];
    [accountArr release];
    [accountDict release];
    [lastQueried release];
    
    [super dealloc];
}

@end


@implementation Account
@synthesize accountId;
@synthesize profilePicUrl;
@synthesize serviceId;
@synthesize serviceName;
@synthesize status;
@synthesize url;
@synthesize username;

-(Account*)init {
    self = [super init];
    if (self) {
        status = acct_other;
    }
    return self;
}

#pragma mark -
#pragma mark IsEqual and Hash functions
-(BOOL)isEqual:(id)object {
    return self == object || [((Account*)object).accountId isEqual:accountId];
}

-(NSUInteger)hash {
    return [accountId unsignedIntValue];
}

-(void)dealloc {
    [accountId release];
    [profilePicUrl release];
    [serviceId release];
    [serviceName release];
    [url release];
    [username release];
    
    [super dealloc];
}

@end
