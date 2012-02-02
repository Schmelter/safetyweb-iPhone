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

- (void)dealloc {
    [username release];
    [password release];
    
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
