//
//  LoginManager.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserManager.h"

@implementation UserCredentials

@synthesize username;
@synthesize password;

- (UserCredentials*)init {
    [self release];
    return nil;
}

- (UserCredentials*)initWithUserName:(NSString*)aUsername AndPassword:(NSString*)aPassword {
    if (self != nil) {
        [super init];
        username = aUsername;
        [username retain];
        password = aPassword;
        [password retain];
    }
    return self;
}

-(NSString*)userToken {
    // Check if the token has expired
    if (userToken == nil || tokenStart == nil) return nil;
    
    NSDate *now = [[NSDate alloc] init];
    NSInteger tokenValidTime = [(NSNumber*)[AppProperties getProperty:@"API_TokenExpire" withDefault:nil] intValue];
    if ([now timeIntervalSince1970] - [tokenStart timeIntervalSince1970] > tokenValidTime) {
        self.userToken = nil;
    }
    
    [now release];
    
    return userToken; 
}

-(void)setUserToken:(NSString *)aUserToken {
    if (aUserToken == nil) {
        [userToken release];
        userToken = nil;
        [tokenStart release];
        tokenStart = nil;
    } else {
        [aUserToken retain];
        [userToken release];
        userToken = aUserToken;
        
        NSDate *newDate = [[NSDate alloc] init];
        [tokenStart release];
        tokenStart = newDate;
    }
}

- (void)dealloc {
    [username release];
    [password release];
    [userToken release];
    [tokenStart release];
    
    [super dealloc];
}

@end


static UserCredentials* credentials;

@implementation UserManager

- (UserManager*)init {
    // This is a purely static class
    [self release];
    return nil;
}

+ (UserCredentials*)getLastUsedCredentials {
    // TODO: Implement getting these out of the 
    return credentials;
}

+ (void)attemptLogin:(UserCredentials *)aCredentials {
    [aCredentials retain];
    [credentials release];
    credentials = aCredentials;
    // TODO: Login the user here
}

- (void)dealloc {
    [super dealloc];
}

@end
