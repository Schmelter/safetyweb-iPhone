//
//  MobileAlertSetup1ViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AccountSetupViewController.h"

#define kChildsMobileOffset     -120

@interface MobileAlertSetup1ViewController : SubAccountSetupViewController <UITextFieldDelegate> {
    @private
    UIButton *attButton;
    UIButton *verizonButton;
    UIButton *sprintButton;
    UIButton *tmobileButton;
    UITextField *childsMobileNumber;
    NSInteger mobileServiceProvider;
}

@property (retain, nonatomic) IBOutlet UIButton *attButton;
@property (retain, nonatomic) IBOutlet UIButton *verizonButton;
@property (retain, nonatomic) IBOutlet UIButton *sprintButton;
@property (retain, nonatomic) IBOutlet UIButton *tmobileButton;
@property (retain, nonatomic) IBOutlet UITextField *childsMobileNumber;

-(IBAction)continueButton:(id)sender;
-(IBAction)providerButton:(id)sender;
-(IBAction)backgroundTap:(id)sender;
-(IBAction)backButton:(id)sender;

@end
