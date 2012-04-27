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
#import "ChildManager.h"

@interface LoginLoadViewController : LoadViewController <UIAlertViewDelegate> {
    @private
    NSString *login;
    NSString *password;
    NSString *token;
    double pendingChildRequests;
    double totalChildRequests;
}

@property (nonatomic, retain) NSString *login;
@property (nonatomic, retain) NSString *password;

@end
