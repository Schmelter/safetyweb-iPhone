//
//  AccountSetup1ViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWViewController.h"
#import "Utilities.h"
#import "AccountSetupModel.h"

#define kFirstNameRow       0
#define kLastNameRow        1
#define kEmailAddressRow    2
#define kCreatePassRow      3
#define kConfirmPassRow     4

@interface AccountSetup1ViewController : SWViewController <UITableViewDelegate, UITableViewDataSource> {
    @private
    UITextField *firstName;
    UITextField *lastName;
    UITextField *emailAddress;
    UITextField *createPass;
    UITextField *confirmPass;
    AccountSetupModel *setupModel;
}

@property (retain, nonatomic) IBOutlet UITextField *firstName;
@property (retain, nonatomic) IBOutlet UITextField *lastName;
@property (retain, nonatomic) IBOutlet UITextField *emailAddress;
@property (retain, nonatomic) IBOutlet UITextField *createPass;
@property (retain, nonatomic) IBOutlet UITextField *confirmPass;
@property (retain, nonatomic) AccountSetupModel *setupModel;

-(IBAction)backgroundTap:(id)sender;
-(IBAction)continueButton:(id)sender;

@end
