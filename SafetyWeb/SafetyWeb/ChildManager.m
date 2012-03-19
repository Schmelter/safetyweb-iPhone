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

+(void)clearAllChildren {
    [childDict removeAllObjects];
    [childArr removeAllObjects];
}

+(Child*)getChildForId:(NSNumber*)childId {
    return [childDict objectForKey:childId];
}

+(NSArray*)getAllChildren {
    return childArr;
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

#pragma mark -
#pragma mark Public static functions

+(void)parseChildrenResponse:(NSDictionary*)childrenJson {
    if (childrenJson == nil) {
        return;
    }
    NSDictionary *childrenDict = [childrenJson objectForKey:@"children"];
    if (childrenDict == nil) {
        return;
    }
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
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
    
    [pool release];
}

+(void)parseChildResponse:(NSDictionary *)childJson {
    NSLog(@"childJSON: %@", [childJson description]);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Go through the childJson, and add it's information to the childDict we already have
    NSDictionary *accountsDict = [childJson objectForKey:@"accounts"];
    if (!accountsDict) return;
    NSDictionary *jsonChildDict = [childJson objectForKey:@"child"];
    if (!jsonChildDict) return;
    // Make sure that we have the child in our childDict, and if not, add them
    Child *child = [childDict objectForKey:[jsonChildDict objectForKey:@"child_id"]];
    if (!child) {
        child = [self initChildFromJson:jsonChildDict];
        [childArr addObject:child];
        [childDict setObject:child forKey:child.childId];
        [child release];
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

-(void)dealloc {
    [super dealloc];
}

@end


@implementation Child
@synthesize childId;
@synthesize firstName;
@synthesize lastName;
@synthesize profilePicUrl;

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
    [accountArr release];
    [accountDict release];
    
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
