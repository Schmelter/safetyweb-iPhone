//
//  RootViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LoginViewController;
@class ResetPasswordViewController;

@interface RootViewController : UIViewController {
    @private
    UIViewController *currentViewController;
}

- (void)displayLoginViewController;
- (void)displayRequestChildActivityViewController;
- (void)displayAccountSetupViewController;
- (void)displaySettingsViewController;
- (void)displayMobileAlertSignupViewController;
- (void)displayResetPasswordViewController;

@end
