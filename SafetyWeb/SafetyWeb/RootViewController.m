//
//  RootViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

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
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [loginViewController setRootViewController:self];
    [self setCurrentViewController:loginViewController];
    [self.view insertSubview:loginViewController.view atIndex:0];
    [loginViewController release];
}

//- (void)displayRequestChildActivityViewController;
//- (void)displayAccountSetupViewController;
//- (void)displaySettingsViewController;
//- (void)displayMobileAlertSignupViewController;
//- (void)displayResetPasswordViewController;

- (void)dealloc {
    [currentViewController release];
    
    [super dealloc];
}

@end
