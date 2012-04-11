//
//  LoginManager.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserManager.h"

static User* credentials;

@implementation UserManager

- (UserManager*)init {
    // This is a purely static class
    [self release];
    return nil;
}

+ (User*)getLastUsedCredentials {
    // TODO: Implement getting these out of the file system or coredata
    return credentials;
}

+ (void)setLastUsedCredentials:(User*)aCredentials {
    // TODO: Store these in the file system or coredata
    [aCredentials retain];
    [credentials release];
    credentials = aCredentials;
}

- (void)dealloc {
    [super dealloc];
}

@end
