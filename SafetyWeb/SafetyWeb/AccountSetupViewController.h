//
//  AccountSetupViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "AccountSetupModel.h"

@class SubAccountSetupViewController;

@interface AccountSetupViewController : SubRootViewController {
    @private
    AccountSetupModel *setupModel;
    SubAccountSetupViewController *currentViewController;
}

@property (retain, nonatomic) AccountSetupModel *setupModel;

- (void)closeAccountSetup;
- (void)displayAccountSetup1ViewController;
- (void)displayAccountSetup2ViewController;
- (void)displayMobileAlertOptInViewController;
- (void)displayMobileAlertSetup1ViewController;
- (void)displayMobileAlertSetup2ViewController;

@end

@interface SubAccountSetupViewController : UIViewController {
@protected
    AccountSetupViewController *accountSetupViewController;
}

-(void)setAccountSetupViewController:(AccountSetupViewController*)accountSetupViewController;

@end
