//
//  LoginLoadViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 * Takes the UserCredentials supplied, and loads the user from the site
 */

#import "LoadViewController.h"
#import "SafetyWebREquest.h"
#import "UserManager.h"
#import "JSONKit.h"

@class TokenCallback;
@class ChildrenCallback;

@interface LoginLoadViewController : LoadViewController {
    @private
    UserCredentials *credentials;
    TokenCallback *tokenCallback;
    ChildrenCallback *childrenCallback;
}

@property (nonatomic, retain) UserCredentials *credentials;

@end
