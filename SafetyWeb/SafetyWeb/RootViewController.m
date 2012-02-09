//
//  RootViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "LoginViewController.h"
#import "ResetPasswordViewController.h"
#import "ChildsActivityViewController.h"
#import "AccountSetup1ViewController.h"
#import "AccountSetup2ViewController.h"

@implementation RootViewController

- (void)setCurrentViewController:(UIViewController*)viewController {
    [viewController retain];
    [currentViewController release];
    currentViewController = viewController;
}

- (void)viewDidLoad {
    if (currentViewController != nil) {
        [currentViewController.view removeFromSuperview];
    }
    
    // Display the login
    [self displayLoginViewController];
    [super viewDidLoad];
}

- (void)displayLoginViewController {
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
    [loginViewController setRootViewController:self];
    [currentViewController.view removeFromSuperview];
    [self setCurrentViewController:loginViewController];
    [self.view addSubview:currentViewController.view];
    [loginViewController release];
}

- (void)displayRequestChildActivityViewController {
    ChildsActivityViewController *childsActivityViewController = [[ChildsActivityViewController alloc] initWithNibName:@"ChildsActivityView" bundle:nil];
    [childsActivityViewController setRootViewController:self];
    [currentViewController.view removeFromSuperview];
    [self setCurrentViewController:childsActivityViewController];
    [self.view addSubview:currentViewController.view];
    [childsActivityViewController release];
}

- (void)displayAccountSetup1ViewController:(AccountSetupModel*)accSetupModel {
    AccountSetup1ViewController *accSetup1ViewController = [[AccountSetup1ViewController alloc] initWithNibName:@"AccountSetup1View" bundle:nil];
    [accSetup1ViewController setRootViewController:self];
    if (accSetupModel == nil) {
        accSetupModel = [[AccountSetupModel alloc] init];
        accSetup1ViewController.setupModel = accSetupModel;
        [accSetupModel release];
    } else {
        accSetup1ViewController.setupModel = accSetupModel;
    }
    [currentViewController.view removeFromSuperview];
    [self setCurrentViewController:accSetup1ViewController];
    [self.view addSubview:currentViewController.view];
    [accSetup1ViewController release];
}

- (void)displayAccountSetup2ViewController:(AccountSetupModel*)accSetupModel {
    AccountSetup2ViewController *accSetup2ViewController = [[AccountSetup2ViewController alloc] initWithNibName:@"AccountSetup2View" bundle:nil];
    [accSetup2ViewController setRootViewController:self];
    accSetup2ViewController.setupModel = accSetupModel;
    [currentViewController.view removeFromSuperview];
    [self setCurrentViewController:accSetup2ViewController];
    [self.view addSubview:currentViewController.view];
    [accSetup2ViewController release];
}

- (void)displaySettingsViewController {
    
}

- (void)displayMobileAlertSignupViewController {
    
}

- (void)displayResetPasswordViewController {
    ResetPasswordViewController *resetPassViewController = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordView" bundle:nil];
    [resetPassViewController setRootViewController:self];
    [currentViewController.view removeFromSuperview];
    [self setCurrentViewController:resetPassViewController];
    [self.view addSubview:currentViewController.view];
    [resetPassViewController release];
}

- (void)dealloc {
    [currentViewController release];
    
    [super dealloc];
}

@end
