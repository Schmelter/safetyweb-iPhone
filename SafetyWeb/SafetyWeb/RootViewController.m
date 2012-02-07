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
    
}

- (void)displayAccountSetupViewController {
    
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
