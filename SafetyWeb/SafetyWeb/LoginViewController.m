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
    UserCredentials *credentials = [UserManager getLastUsedCredentials];
    if (credentials != nil) {
        [username setText:credentials.username];
        [password setText:credentials.password];
    }
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

- (IBAction)forgotPassword:(id)sender {
    
}

- (IBAction)getAnAccount:(id)sender {
    
}

- (IBAction)seeMyChildsActivity:(id)sender {
    
}

- (IBAction)backgroundTap:(id)sender {
    [username resignFirstResponder];
    [password resignFirstResponder];
}

- (IBAction)textFieldDoneEditing:(id)sender {
    // Check if they have both a username and password, if so, try to log in
    NSString *usernameStr = [username text];
    NSString *passwordStr = [password text];
    
    if (usernameStr == nil || [usernameStr length] == 0 || passwordStr == nil || [passwordStr length] == 0) {
        return;
    }
    
    UserCredentials *userCredentials = [[UserCredentials alloc] initWithUserName:usernameStr AndPassword:passwordStr];
    [UserManager attemptLogin:userCredentials];
    [userCredentials release];
}

- (void)dealloc {
    [username release];
    [password release];
    
    [super dealloc];
}

@end
