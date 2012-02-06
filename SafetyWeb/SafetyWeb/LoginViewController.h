//
//  LoginViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "SWViewController.h"
#import "RootViewController.h"

@interface LoginViewController : SWViewController {
@private
    UITextField *username;
    UITextField *password;
}

@property (retain, nonatomic) IBOutlet UITextField *username;
@property (retain, nonatomic) IBOutlet UITextField *password;

- (IBAction)forgotPassword:(id)sender;
- (IBAction)getAnAccount:(id)sender;
- (IBAction)seeMyChildsActivity:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;

@end
