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
#import "AppProperties.h"
#import "User.h"


@interface UserManager : NSObject {
}

// May return nil if there were no last used credentials.  No guarantee that the credentials will work.
+ (User*)getLastUsedCredentials;
+ (void)setLastUsedCredentials:(User*)aCredentials;

@end
