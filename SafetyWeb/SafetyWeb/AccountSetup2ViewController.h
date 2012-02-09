//
//  AccountSetup2ViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWViewController.h"
#import "AccountSetupModel.h"
#import "Utilities.h"

#define kChildsFirstNameRow     0
#define kChildsLastNameRow      1
#define kChildsEmailAddrRow     2
#define kChildsBirthdayRow      3

@interface AccountSetup2ViewController : SWViewController <UITableViewDelegate, UITableViewDataSource> {
    @private
    UIDatePicker *datePicker;
    UITextField *childsFirstName;
    UITextField *childsLastName;
    UITextField *childsEmailAddr;
    UITextField *childsBirthday;
    AccountSetupModel *setupModel;
}

@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (retain, nonatomic) IBOutlet UITextField *childsFirstName;
@property (retain, nonatomic) IBOutlet UITextField *childsLastName;
@property (retain, nonatomic) IBOutlet UITextField *childsEmailAddr;
@property (retain, nonatomic) IBOutlet UITextField *childsBirthday;
@property (retain, nonatomic) AccountSetupModel *setupModel;

-(IBAction)backgroundTap:(id)sender;
-(IBAction)continueButton:(id)sender;
-(IBAction)datePicked:(id)sender;
-(IBAction)backButton:(id)sender;

@end
