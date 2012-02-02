//
//  LoginManager.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 * The UserManager exists to persist and track the most recent credentials used to login,
 * login to the SafetyWeb service, and store the data we know about the user.
 */

#import <Foundation/Foundation.h>

@interface UserCredentials : NSObject {
    @private
    NSString *username;
    NSString *password;
}

@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *password;

- (UserCredentials*)initWithUserName:(NSString*)username AndPassword:(NSString*)password;

@end




@interface UserManager : NSObject {
}

// May return nil if there were no last used credentials.  No guarantee that the credentials will work.
+ (UserCredentials*)getLastUsedCredentials;

+ (void)attemptLogin:(UserCredentials*)credentials;

@end
