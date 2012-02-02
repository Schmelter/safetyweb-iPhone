//
//  LoginViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

@synthesize username;
@synthesize password;

- (void)viewDidLoad {
    // Get the current username/password from the last login, or the last time they used this
    // interface
    
    
    BlueViewController *blueController = [[BlueViewController alloc]
										  initWithNibName:@"BlueView" bundle:nil];
    self.blueViewController = blueController;
    [self.view insertSubview:blueController.view atIndex:0];
    [blueController release];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
}

- (void)viewDidUnload {
    self.username = nil;
    self.password = nil;
    
    [super viewDidUnload];
}

- (void)dealloc {
    [username release];
    [password release];
    
    [super dealloc];
}

@end
