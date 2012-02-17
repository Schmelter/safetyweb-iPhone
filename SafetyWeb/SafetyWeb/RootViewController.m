//
//  RootViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "LoginViewController.h"
#import "LoginLoadViewController.h"
#import "ResetPasswordViewController.h"
#import "ChildsActivityViewController.h"
#import "AccountSetupViewController.h"
#import "LoadViewController.h"

@implementation RootViewController

- (void)setCurrentViewController:(SubRootViewController*)viewController {
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

- (void)displayLoginLoadViewController:(UserCredentials*)credentials {
    LoginLoadViewController *loadLoginVC = [[LoginLoadViewController alloc] initWithNibName:@"LoadView" bundle:nil];
    [loadLoginVC setRootViewController:self];
    loadLoginVC.credentials = credentials;
    [currentViewController.view removeFromSuperview];
    [self setCurrentViewController:loadLoginVC];
    [self.view addSubview:loadLoginVC.view];
    [loadLoginVC release];
}

- (void)displayRequestChildActivityViewController {
    ChildsActivityViewController *childsActivityViewController = [[ChildsActivityViewController alloc] initWithNibName:@"ChildsActivityView" bundle:nil];
    [childsActivityViewController setRootViewController:self];
    [currentViewController.view removeFromSuperview];
    [self setCurrentViewController:childsActivityViewController];
    [self.view addSubview:currentViewController.view];
    [childsActivityViewController release];
}

- (void)displayAccountSetupViewController {
    AccountSetupViewController *accSetupViewController = [[AccountSetupViewController alloc] init];
    [accSetupViewController setRootViewController:self];
    [currentViewController.view removeFromSuperview];
    [self setCurrentViewController:accSetupViewController];
    [self.view addSubview:currentViewController.view];
    [accSetupViewController release];
}

- (void)displayResetPasswordViewController {
    ResetPasswordViewController *resetPassViewController = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordView" bundle:nil];
    [resetPassViewController setRootViewController:self];
    [currentViewController.view removeFromSuperview];
    [self setCurrentViewController:resetPassViewController];
    [self.view addSubview:currentViewController.view];
    [resetPassViewController release];
}

- (void)displayLoadViewController {
    LoadViewController *loadViewController = [[LoadViewController alloc] initWithNibName:@"LoadView" bundle:nil];
    [loadViewController setRootViewController:self];
    [currentViewController.view removeFromSuperview];
    [self setCurrentViewController:loadViewController];
    [self.view addSubview:currentViewController.view];
    //NSLog(@"View: %@", currentViewController.view);
    [loadViewController release];
}

- (void)dealloc {
    [currentViewController release];
    
    [super dealloc];
}

@end

@implementation SubRootViewController

-(void)setRootViewController:(RootViewController*)aRootViewController {
    // Do not retain, this is our parent
    rootViewController = aRootViewController;
}

-(void)dealloc {
    // DO NOT release the rootViewController, it's our parent, and we never retained it
    
    [super dealloc];
}

@end
