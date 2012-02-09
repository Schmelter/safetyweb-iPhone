//
//  AccountSetup1ViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountSetup1ViewController.h"

@implementation AccountSetup1ViewController

@synthesize firstName;
@synthesize lastName;
@synthesize emailAddress;
@synthesize createPass;
@synthesize confirmPass;
@synthesize setupModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.firstName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    self.lastName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    self.emailAddress = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    self.createPass = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    self.confirmPass = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    
    [firstName release];
    [lastName release];
    [emailAddress release];
    [createPass release];
    [confirmPass release];
    
    firstName.placeholder = @"Your First Name";
    firstName.autocorrectionType = UITextAutocorrectionTypeNo;
    firstName.returnKeyType = UIReturnKeyNext;
    firstName.clearsOnBeginEditing = NO;
    firstName.textAlignment = UITextAlignmentLeft;
    firstName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    firstName.keyboardType = UIKeyboardTypeDefault;
    [firstName addTarget:self action:@selector(firstNameNextPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    firstName.clearButtonMode = UITextFieldViewModeWhileEditing;
    firstName.text = setupModel.firstName;
    
    lastName.placeholder = @"Your Last Name";
    lastName.autocorrectionType = UITextAutocorrectionTypeNo;
    lastName.returnKeyType = UIReturnKeyNext;
    lastName.clearsOnBeginEditing = NO;
    lastName.textAlignment = UITextAlignmentLeft;
    lastName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    lastName.keyboardType = UIKeyboardTypeDefault;
    [lastName addTarget:self action:@selector(lastNameNextPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    lastName.clearButtonMode = UITextFieldViewModeWhileEditing;
    lastName.text = setupModel.lastName;
    
    emailAddress.placeholder = @"Your Email Address";
    emailAddress.autocorrectionType = UITextAutocorrectionTypeNo;
    emailAddress.returnKeyType = UIReturnKeyNext;
    emailAddress.clearsOnBeginEditing = NO;
    emailAddress.textAlignment = UITextAlignmentLeft;
    emailAddress.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    emailAddress.keyboardType = UIKeyboardTypeEmailAddress;
    [emailAddress addTarget:self action:@selector(emailAddressNextPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    emailAddress.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailAddress.text = setupModel.emailAddress;
    
    createPass.placeholder = @"Create Password";
    createPass.autocorrectionType = UITextAutocorrectionTypeNo;
    createPass.returnKeyType = UIReturnKeyNext;
    createPass.clearsOnBeginEditing = NO;
    createPass.textAlignment = UITextAlignmentLeft;
    createPass.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    createPass.keyboardType = UIKeyboardTypeDefault;
    [createPass addTarget:self action:@selector(createPassNextPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    createPass.clearButtonMode = UITextFieldViewModeWhileEditing;
    createPass.secureTextEntry = YES;
    createPass.text = setupModel.password;
    
    confirmPass.placeholder = @"Confirm Password";
    confirmPass.autocorrectionType = UITextAutocorrectionTypeNo;
    confirmPass.returnKeyType = UIReturnKeyGo;
    confirmPass.clearsOnBeginEditing = NO;
    confirmPass.textAlignment = UITextAlignmentLeft;
    confirmPass.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    confirmPass.keyboardType = UIKeyboardTypeDefault;
    [confirmPass addTarget:self action:@selector(confirmPassGoPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    confirmPass.clearButtonMode = UITextFieldViewModeWhileEditing;
    confirmPass.secureTextEntry = YES;
    confirmPass.text = setupModel.password;
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    self.firstName = nil;
    self.lastName = nil;
    self.emailAddress = nil;
    self.createPass = nil;
    self.confirmPass = nil;
    
    [super viewDidUnload];
}

#pragma mark -
#pragma mark IBAction methods

-(IBAction)backgroundTap:(id)sender {
    [firstName resignFirstResponder];
    [lastName resignFirstResponder];
    [emailAddress resignFirstResponder];
    [createPass resignFirstResponder];
    [confirmPass resignFirstResponder];
}

-(IBAction)continueButton:(id)sender {
    // Make sure everything makes sense
    if (0 == [firstName.text length]) {
        UIAlertView *badEmailAlert = [[UIAlertView alloc] 
                                      initWithTitle:@"No First Name"
                                      message:@"Please Provide a First Name"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [badEmailAlert show];
        [badEmailAlert release];
        [firstName becomeFirstResponder];
        return;
    } else if (0 == [lastName.text length]) {
        UIAlertView *badEmailAlert = [[UIAlertView alloc] 
                                      initWithTitle:@"No Last Name"
                                      message:@"Please Provide a Last Name"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [badEmailAlert show];
        [badEmailAlert release];
        [lastName becomeFirstResponder];
        return;
    } else if (![Utilities NSStringIsValidEmail:emailAddress.text]) {
        UIAlertView *badEmailAlert = [[UIAlertView alloc] 
                                      initWithTitle:@"Bad E-mail Address"
                                      message:@"Please Enter a Valid E-mail Address"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [badEmailAlert show];
        [badEmailAlert release];
        [emailAddress becomeFirstResponder];
        return;
    } else if (0 == [createPass.text length]) {
        // TODO: Check if passwords have any restrictions... length, content and so forth
        UIAlertView *badEmailAlert = [[UIAlertView alloc] 
                                      initWithTitle:@"No Password"
                                      message:@"Please Provide a Password"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [badEmailAlert show];
        [badEmailAlert release];
        [createPass becomeFirstResponder];
        return;
    } else if (![createPass.text isEqualToString:confirmPass.text]) {
        UIAlertView *badEmailAlert = [[UIAlertView alloc] 
                                      initWithTitle:@"Passwords Don't Match"
                                      message:@"The Password Fields must Match"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [badEmailAlert show];
        [badEmailAlert release];
        [confirmPass becomeFirstResponder];
        return;
    }
    
    setupModel.firstName = firstName.text;
    setupModel.lastName = lastName.text;
    setupModel.emailAddress = emailAddress.text;
    setupModel.password = createPass.text;
    [rootViewController displayAccountSetup2ViewController:setupModel];
}

#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDataSource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
        case kFirstNameRow:
            [cell addSubview:firstName];
            break;
        case kLastNameRow:
            [cell addSubview:lastName];
            break;
        case kEmailAddressRow:
            [cell addSubview:emailAddress];
            break;
        case kCreatePassRow:
            [cell addSubview:createPass];
            break;
        case kConfirmPassRow:
            [cell addSubview:confirmPass];
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case kFirstNameRow:
            [firstName becomeFirstResponder];
            break;
        case kLastNameRow:
            [lastName becomeFirstResponder];
            break;
        case kEmailAddressRow:
            [emailAddress becomeFirstResponder];
            break;
        case kCreatePassRow:
            [createPass becomeFirstResponder];
            break;
        case kConfirmPassRow:
            [confirmPass becomeFirstResponder];
            break;
    }
}

#pragma mark -
#pragma mark Keyboard Return methods

-(IBAction)firstNameNextPressed:(id)sender {
    [lastName becomeFirstResponder];
}

-(IBAction)lastNameNextPressed:(id)sender {
    [emailAddress becomeFirstResponder];
}

-(IBAction)emailAddressNextPressed:(id)sender {
    [createPass becomeFirstResponder];
}

-(IBAction)createPassNextPressed:(id)sender {
    [confirmPass becomeFirstResponder];
}

-(IBAction)confirmPassGoPressed:(id)sender {
    [confirmPass resignFirstResponder];
    [self continueButton:sender];
}

-(void)dealloc {
    [firstName release];
    [lastName release];
    [emailAddress release];
    [createPass release];
    [confirmPass release];
    [setupModel release];
    
    [super dealloc];
}

@end
