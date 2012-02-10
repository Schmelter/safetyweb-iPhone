//
//  AccountSetup1ViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AccountSetupViewController.h"
#import "Utilities.h"
#import "AccountSetupModel.h"

#define kFirstNameRow       0
#define kLastNameRow        1
#define kEmailAddressRow    2
#define kCreatePassRow      3
#define kConfirmPassRow     4

#define kCreatePassOffset   -70
#define kConfirmPassOffset  -120

@interface AccountSetup1ViewController : SubAccountSetupViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    @private
    UITextField *firstName;
    UITextField *lastName;
    UITextField *emailAddress;
    UITextField *createPass;
    UITextField *confirmPass;
    UITableView *infoTable;
}

@property (retain, nonatomic) IBOutlet UITextField *firstName;
@property (retain, nonatomic) IBOutlet UITextField *lastName;
@property (retain, nonatomic) IBOutlet UITextField *emailAddress;
@property (retain, nonatomic) IBOutlet UITextField *createPass;
@property (retain, nonatomic) IBOutlet UITextField *confirmPass;
@property (retain, nonatomic) IBOutlet UITableView *infoTable;

-(IBAction)backgroundTap:(id)sender;
-(IBAction)continueButton:(id)sender;
-(IBAction)backButton:(id)sender;

@end
