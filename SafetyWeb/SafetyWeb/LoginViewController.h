//
//  LoginViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UserManager.h"
#import "RootViewController.h"

#define kUsernameRow    0
#define kPasswordRow    1

@interface LoginViewController : SubRootViewController <UITableViewDelegate, UITableViewDataSource> {
@private
    UITextField *username;
    UITextField *password;
    UIButton *forgotPassword;
    UITableView *userPassTable;
}

@property (retain, nonatomic) IBOutlet UITextField *username;
@property (retain, nonatomic) IBOutlet UITextField *password;
@property (retain, nonatomic) IBOutlet UIButton *forgotPassword;
@property (retain, nonatomic) IBOutlet UITableView *userPassTable;

- (IBAction)forgotPassword:(id)sender;
- (IBAction)getAnAccount:(id)sender;
- (IBAction)seeMyChildsActivity:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
