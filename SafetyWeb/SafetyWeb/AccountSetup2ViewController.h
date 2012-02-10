//
//  AccountSetup2ViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AccountSetupViewController.h"
#import "AccountSetupModel.h"
#import "Utilities.h"

#define kChildsFirstNameRow     0
#define kChildsLastNameRow      1
#define kChildsEmailAddrRow     2
#define kChildsBirthdayRow      3

#define kChildsEmailOffset    -60

@interface AccountSetup2ViewController : SubAccountSetupViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    @private
    UIDatePicker *datePicker;
    UITextField *childsFirstName;
    UITextField *childsLastName;
    UITextField *childsEmailAddr;
    UITextField *childsBirthday;
    UITableView *childInfoTable;
}

@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (retain, nonatomic) IBOutlet UITextField *childsFirstName;
@property (retain, nonatomic) IBOutlet UITextField *childsLastName;
@property (retain, nonatomic) IBOutlet UITextField *childsEmailAddr;
@property (retain, nonatomic) IBOutlet UITextField *childsBirthday;
@property (retain, nonatomic) IBOutlet UITableView *childInfoTable;

-(IBAction)backgroundTap:(id)sender;
-(IBAction)continueButton:(id)sender;
-(IBAction)datePicked:(id)sender;
-(IBAction)backButton:(id)sender;

@end
