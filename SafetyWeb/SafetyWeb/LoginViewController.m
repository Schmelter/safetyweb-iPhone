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
@synthesize forgotPassword;
@synthesize userPassTable;


#pragma mark -
#pragma mark View Life Cycle

- (void)viewDidLoad {
    // Get the current username/password from the last login, or the last time they used this
    // interface
    UserCredentials *credentials = [UserManager getLastUsedCredentials];
    self.username = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, 185, 48)];
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, 185, 48)];
    [username release];
    [password release];
    
    password.secureTextEntry = YES;
    
    username.placeholder = @"Username";
    username.autocorrectionType = UITextAutocorrectionTypeNo;
    username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    username.returnKeyType = UIReturnKeyNext;
    username.clearsOnBeginEditing = NO;
    username.textAlignment = UITextAlignmentLeft;
    username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [username addTarget:self action:@selector(usernameNextButton:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    password.placeholder = @"Password";
    password.autocorrectionType = UITextAutocorrectionTypeNo;
    password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    password.returnKeyType = UIReturnKeyDone;
    password.clearsOnBeginEditing = NO;
    password.textAlignment = UITextAlignmentLeft;
    password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [password addTarget:self action:@selector(passwordDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    if (credentials != nil) {
        [username setText:credentials.username];
        [password setText:credentials.password];
    }
    
    userPassTable.layer.cornerRadius = 10;
    userPassTable.scrollEnabled = NO;
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
}

- (void)viewDidUnload {
    self.username = nil;
    self.password = nil;
    self.userPassTable = nil;
    
    [super viewDidUnload];
}

#pragma mark -
#pragma mark UITextField methods
- (IBAction)usernameNextButton:(id)sender {
    [sender resignFirstResponder];
    [password becomeFirstResponder];
}

- (IBAction)passwordDoneEditing:(id)sender {
    [sender resignFirstResponder];
    // Check if they have both a username and password, if so, try to log in
    NSString *usernameStr = [username text];
    NSString *passwordStr = [password text];
    
    if (usernameStr == nil || [usernameStr length] == 0 || passwordStr == nil || [passwordStr length] == 0) {
        return;
    }
        
    UserCredentials *userCredentials = [[UserCredentials alloc] initWithUserName:usernameStr AndPassword:passwordStr];
    [rootViewController displayLoginLoadViewController:userCredentials];
    [userCredentials release];
}

#pragma mark -
#pragma mark UIButton actions
- (IBAction)forgotPassword:(id)sender {
    [rootViewController displayResetPasswordViewController];
}

- (IBAction)getAnAccount:(id)sender {
    [rootViewController displayAccountSetupViewController];
}

- (IBAction)seeMyChildsActivity:(id)sender {
    [rootViewController displayRequestChildActivityViewController];
}

- (IBAction)backgroundTap:(id)sender {
    [username resignFirstResponder];
    [password resignFirstResponder];
}

#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDataSource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == kUsernameRow) {
        // The username UITextField
        cell.textLabel.text = @"Username:";
        
        [cell addSubview:username];
        [username setClearButtonMode:UITextFieldViewModeWhileEditing];
    } else if (indexPath.row == kPasswordRow) {
        // The password UITextField
        cell.textLabel.text = @"Password:";
        
        [cell addSubview:password];
        [password setClearButtonMode:UITextFieldViewModeWhileEditing];
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kUsernameRow) {
        [username becomeFirstResponder];
    } else if (indexPath.row == kPasswordRow) {
        [password becomeFirstResponder];
    }
}

- (void)dealloc {
    [username release];
    [password release];
    [userPassTable release];
    
    [super dealloc];
}

@end
