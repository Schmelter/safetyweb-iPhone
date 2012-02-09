//
//  AccountSetup2ViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountSetup2ViewController.h"

@implementation AccountSetup2ViewController

@synthesize datePicker;
@synthesize childsFirstName;
@synthesize childsLastName;
@synthesize childsEmailAddr;
@synthesize childsBirthday;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.childsFirstName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    self.childsLastName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    self.childsEmailAddr = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    self.childsBirthday = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    
    [childsFirstName release];
    [childsLastName release];
    [childsEmailAddr release];
    [childsBirthday release];
    
    childsFirstName.placeholder = @"Your Child's First Name";
    childsFirstName.autocorrectionType = UITextAutocorrectionTypeNo;
    childsFirstName.returnKeyType = UIReturnKeyNext;
    childsFirstName.clearsOnBeginEditing = NO;
    childsFirstName.textAlignment = UITextAlignmentLeft;
    childsFirstName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    childsFirstName.keyboardType = UIKeyboardTypeDefault;
    [childsFirstName addTarget:self action:@selector(childsFirstNameNextPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    childsFirstName.clearButtonMode = UITextFieldViewModeWhileEditing;
    childsFirstName.text = accountSetupViewController.setupModel.childFirstName;
    
    childsLastName.placeholder = @"Your Child's Last Name";
    childsLastName.autocorrectionType = UITextAutocorrectionTypeNo;
    childsLastName.returnKeyType = UIReturnKeyNext;
    childsLastName.clearsOnBeginEditing = NO;
    childsLastName.textAlignment = UITextAlignmentLeft;
    childsLastName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    childsLastName.keyboardType = UIKeyboardTypeDefault;
    [childsLastName addTarget:self action:@selector(childsLastNameNextPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    childsLastName.clearButtonMode = UITextFieldViewModeWhileEditing;
    childsLastName.text = accountSetupViewController.setupModel.childLastName;
    
    childsEmailAddr.placeholder = @"Your Child's Email Address";
    childsEmailAddr.autocorrectionType = UITextAutocorrectionTypeNo;
    childsEmailAddr.returnKeyType = UIReturnKeyNext;
    childsEmailAddr.clearsOnBeginEditing = NO;
    childsEmailAddr.textAlignment = UITextAlignmentLeft;
    childsEmailAddr.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    childsEmailAddr.keyboardType = UIKeyboardTypeDefault;
    [childsEmailAddr addTarget:self action:@selector(childsEmailAddrNextPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    childsEmailAddr.clearButtonMode = UITextFieldViewModeWhileEditing;
    childsEmailAddr.text = accountSetupViewController.setupModel.childEmailAddress;
    
    childsBirthday.placeholder = @"Your Child's Date of Birth";
    childsBirthday.autocorrectionType = UITextAutocorrectionTypeNo;
    childsBirthday.returnKeyType = UIReturnKeyGo;
    childsBirthday.clearsOnBeginEditing = NO;
    childsBirthday.textAlignment = UITextAlignmentLeft;
    childsBirthday.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    childsBirthday.keyboardType = UIKeyboardTypeDefault;
    [childsBirthday addTarget:self action:@selector(childsBirthdayPressed:) forControlEvents:UIControlEventTouchUpInside];
    childsBirthday.clearButtonMode = UITextFieldViewModeWhileEditing;
    childsBirthday.enabled = NO;
    childsBirthday.text = [NSDateFormatter localizedStringFromDate:accountSetupViewController.setupModel.childBirthday dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    
    datePicker.maximumDate = [NSDate date];
    datePicker.hidden = YES;
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    self.childsFirstName = nil;
    self.childsLastName = nil;
    self.childsEmailAddr = nil;
    self.childsBirthday = nil;
    self.datePicker = nil;
    
    [super viewDidUnload];
}

#pragma mark -
#pragma mark IBAction Methods

-(IBAction)backgroundTap:(id)sender {
    [childsFirstName resignFirstResponder];
    [childsLastName resignFirstResponder];
    [childsEmailAddr resignFirstResponder];
    [childsBirthday resignFirstResponder];
}

-(IBAction)continueButton:(id)sender {
    // Verify everything in the text fields, and complain if necessary
    if (0 == [childsFirstName.text length]) {
        UIAlertView *badEmailAlert = [[UIAlertView alloc] 
                                      initWithTitle:@"No First Name"
                                      message:@"Please Provide a First Name"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [badEmailAlert show];
        [badEmailAlert release];
        [childsFirstName becomeFirstResponder];
        return;
    } else if (0 == [childsLastName.text length]) {
        UIAlertView *badEmailAlert = [[UIAlertView alloc] 
                                      initWithTitle:@"No Last Name"
                                      message:@"Please Provide a Last Name"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [badEmailAlert show];
        [badEmailAlert release];
        [childsLastName becomeFirstResponder];
        return;
    } else if (![Utilities NSStringIsValidEmail:childsEmailAddr.text]) {
        UIAlertView *badEmailAlert = [[UIAlertView alloc] 
                                      initWithTitle:@"Bad E-mail Address"
                                      message:@"Please Enter a Valid E-mail Address"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [badEmailAlert show];
        [badEmailAlert release];
        [childsEmailAddr becomeFirstResponder];
        return;
    } else if (0 == [childsBirthday.text length]) {
        UIAlertView *badEmailAlert = [[UIAlertView alloc] 
                                      initWithTitle:@"No Birth Date"
                                      message:@"Please Provide a Birth Date"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [badEmailAlert show];
        [badEmailAlert release];
        datePicker.hidden = NO;
        return;
    }
    
    accountSetupViewController.setupModel.childFirstName = childsFirstName.text;
    accountSetupViewController.setupModel.childLastName = childsLastName.text;
    accountSetupViewController.setupModel.childEmailAddress = childsEmailAddr.text;
    accountSetupViewController.setupModel.childBirthday = datePicker.date;
    // TODO: Ask about Mobile Alerts
}

-(IBAction)datePicked:(id)sender {
    childsBirthday.text = [NSDateFormatter localizedStringFromDate:datePicker.date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    datePicker.hidden = YES;
}

-(IBAction)backButton:(id)sender {
    [accountSetupViewController displayAccountSetup1ViewController];
}

#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
        case kChildsFirstNameRow:
            [cell addSubview:childsFirstName];
            break;
        case kChildsLastNameRow:
            [cell addSubview:childsLastName];
            break;
        case kChildsEmailAddrRow:
            [cell addSubview:childsEmailAddr];
            break;
        case kChildsBirthdayRow:
            [cell addSubview:childsBirthday];
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case kChildsFirstNameRow:
            [childsFirstName becomeFirstResponder];
            break;
        case kChildsLastNameRow:
            [childsLastName becomeFirstResponder];
            break;
        case kChildsEmailAddrRow:
            [childsEmailAddr becomeFirstResponder];
            break;
        case kChildsBirthdayRow:
            datePicker.hidden = NO;
            break;
    }
}

#pragma mark -
#pragma mark Keyboard Return methods

-(IBAction)childsFirstNameNextPressed:(id)sender {
    [childsLastName becomeFirstResponder];
}

-(IBAction)childsLastNameNextPressed:(id)sender {
    [childsEmailAddr becomeFirstResponder];
}

-(IBAction)childsEmailAddrNextPressed:(id)sender {
    [childsEmailAddr resignFirstResponder];
    datePicker.hidden = NO;
}

-(IBAction)childsBirthdayPressed:(id)sender {
    datePicker.hidden = NO;
}

-(void)dealloc {
    [datePicker release];
    [childsFirstName release];
    [childsLastName release];
    [childsEmailAddr release];
    [childsBirthday release];
    
    [super dealloc];
}

@end
