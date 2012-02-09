//
//  AccountSetup1ViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountSetupViewController.h"
#import "Utilities.h"
#import "AccountSetupModel.h"

#define kFirstNameRow       0
#define kLastNameRow        1
#define kEmailAddressRow    2
#define kCreatePassRow      3
#define kConfirmPassRow     4

@interface AccountSetup1ViewController : SubAccountSetupViewController <UITableViewDelegate, UITableViewDataSource> {
    @private
    UITextField *firstName;
    UITextField *lastName;
    UITextField *emailAddress;
    UITextField *createPass;
    UITextField *confirmPass;
}

@property (retain, nonatomic) IBOutlet UITextField *firstName;
@property (retain, nonatomic) IBOutlet UITextField *lastName;
@property (retain, nonatomic) IBOutlet UITextField *emailAddress;
@property (retain, nonatomic) IBOutlet UITextField *createPass;
@property (retain, nonatomic) IBOutlet UITextField *confirmPass;

-(IBAction)backgroundTap:(id)sender;
-(IBAction)continueButton:(id)sender;
-(IBAction)backButton:(id)sender;

@end
