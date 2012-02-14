//
//  MobileAlertSetup2ViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AccountSetupViewController.h"

#define kMobileUserIdOffset     -60;
#define kMobilePasswordOffset   -120;

@interface MobileAlertSetup2ViewController : SubAccountSetupViewController <UITextFieldDelegate> {
    @private
    UITextField *mobileUserId;
    UITextField *mobilePassword;
    UIImageView *providerImage;
    UILabel *userIDLabel;
    UILabel *passwordLabel;
}

@property (nonatomic, retain) IBOutlet UITextField *mobileUserId;
@property (nonatomic, retain) IBOutlet UITextField *mobilePassword;
@property (nonatomic, retain) IBOutlet UIImageView *providerImage;
@property (nonatomic, retain) IBOutlet UILabel *userIDLabel;
@property (nonatomic, retain) IBOutlet UILabel *passwordLabel;

-(IBAction)didEndOnExit:(id)sender;
-(IBAction)backgroundTap:(id)sender;
-(IBAction)continueButton:(id)sender;
-(IBAction)backButton:(id)sender;

@end
