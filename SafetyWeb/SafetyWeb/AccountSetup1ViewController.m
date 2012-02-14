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
@synthesize infoTable;

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
    self.firstName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 260, 48)];
    self.lastName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 260, 48)];
    self.emailAddress = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 260, 48)];
    self.createPass = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 260, 48)];
    self.confirmPass = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 260, 48)];
    
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
    firstName.text = accountSetupViewController.setupModel.firstName;
    firstName.delegate = self;
    
    lastName.placeholder = @"Your Last Name";
    lastName.autocorrectionType = UITextAutocorrectionTypeNo;
    lastName.returnKeyType = UIReturnKeyNext;
    lastName.clearsOnBeginEditing = NO;
    lastName.textAlignment = UITextAlignmentLeft;
    lastName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    lastName.keyboardType = UIKeyboardTypeDefault;
    [lastName addTarget:self action:@selector(lastNameNextPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    lastName.clearButtonMode = UITextFieldViewModeWhileEditing;
    lastName.text = accountSetupViewController.setupModel.lastName;
    lastName.delegate = self;
    
    emailAddress.placeholder = @"Your Email Address";
    emailAddress.autocorrectionType = UITextAutocorrectionTypeNo;
    emailAddress.returnKeyType = UIReturnKeyNext;
    emailAddress.clearsOnBeginEditing = NO;
    emailAddress.textAlignment = UITextAlignmentLeft;
    emailAddress.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    emailAddress.keyboardType = UIKeyboardTypeEmailAddress;
    [emailAddress addTarget:self action:@selector(emailAddressNextPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    emailAddress.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailAddress.text = accountSetupViewController.setupModel.emailAddress;
    emailAddress.delegate = self;
    
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
    createPass.text = accountSetupViewController.setupModel.password;
    createPass.delegate = self;
    
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
    confirmPass.text = accountSetupViewController.setupModel.password;
    confirmPass.delegate = self;
    
    infoTable.layer.cornerRadius = 10;
    infoTable.scrollEnabled = NO;
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    self.firstName = nil;
    self.lastName = nil;
    self.emailAddress = nil;
    self.createPass = nil;
    self.confirmPass = nil;
    self.infoTable = nil;
    
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
    
    accountSetupViewController.setupModel.firstName = firstName.text;
    accountSetupViewController.setupModel.lastName = lastName.text;
    accountSetupViewController.setupModel.emailAddress = emailAddress.text;
    accountSetupViewController.setupModel.password = createPass.text;
    [accountSetupViewController displayAccountSetup2ViewController];
}

-(IBAction)backButton:(id)sender {
    [accountSetupViewController closeAccountSetup];
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

#pragma mark -
#pragma mark UITextFieldDelegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    // Slide up the view if the keyboard will cover one of the inputs
    CGRect rect = self.view.frame;
    if (textField == createPass && rect.origin.y != kCreatePassOffset) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];
        
        rect.origin.y = kCreatePassOffset;
        
        self.view.frame = rect;
        [UIView commitAnimations];
    } else if (textField == confirmPass && rect.origin.y != kConfirmPassOffset) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];
        
        rect.origin.y = kConfirmPassOffset;
        
        self.view.frame = rect;
        [UIView commitAnimations];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    // Slide down the view if the view is slid up
    CGRect rect = self.view.frame;
    if ((textField == createPass || textField == confirmPass) && rect.origin.y != 0 && ![createPass isFirstResponder] && ![confirmPass isFirstResponder]) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];
        
        rect.origin.y = 0;
        
        self.view.frame = rect;
        [UIView commitAnimations];
    }
}

-(void)dealloc {
    [firstName release];
    [lastName release];
    [emailAddress release];
    [createPass release];
    [confirmPass release];
    [infoTable release];
    
    [super dealloc];
}

@end
