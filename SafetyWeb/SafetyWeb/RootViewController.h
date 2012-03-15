//
//  RootViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AccountSetupModel.h"
#import "UserManager.h"

@interface RootViewController : UIViewController {
    @private
    UIViewController *currentViewController;
}

- (void)displayLoginViewController;
- (void)displayLoginLoadViewController:(UserCredentials*)credentials;
- (void)displayMenuViewController;
- (void)displayRequestChildActivityViewController;
- (void)displayAccountSetupViewController;
- (void)displayResetPasswordViewController;
- (void)displayResetPasswordLoadViewController:(NSString*)emailAddress;
- (void)displayLoadViewController;

@end

@interface SubRootViewController : UIViewController {
@protected
    RootViewController *rootViewController;
}

-(void)setRootViewController:(RootViewController*)rootViewController;

@end
