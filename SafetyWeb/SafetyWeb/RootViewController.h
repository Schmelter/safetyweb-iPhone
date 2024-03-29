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
#import "ChildManager.h"
#import "FacebookAlert.h"

@class SubRootViewController;

@interface RootViewController : UIViewController {
    @private
    UIViewController *currentViewController;
}

- (void)displayLoginViewController;
- (void)displayLoginLoadViewController:(NSString*)login withPassword:(NSString*)password;
- (void)displayMenuViewController;
- (void)displayRequestChildActivityViewController;
- (void)displayAccountSetupViewController;
- (void)displayResetPasswordViewController;
- (void)displayResetPasswordLoadViewController:(NSString*)emailAddress;
- (void)displayLoadViewController;
- (void)displayGenericViewController:(SubRootViewController*)subRootViewController;

@end

@interface SubRootViewController : UIViewController {
@protected
    RootViewController *rootViewController;
}

-(void)setRootViewController:(RootViewController*)rootViewController;

@end
