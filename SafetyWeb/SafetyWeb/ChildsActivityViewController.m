//
//  ChildsActivityViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChildsActivityViewController.h"

@implementation ChildsActivityViewController

@synthesize yourEmailAddress;
@synthesize childsEmailAddress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    self.yourEmailAddress = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    self.childsEmailAddress = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    
    yourEmailAddress.placeholder = @"Your Email Address";
    yourEmailAddress.autocorrectionType = UITextAutocorrectionTypeNo;
    yourEmailAddress.returnKeyType = UIReturnKeyNext;
    yourEmailAddress.clearsOnBeginEditing = NO;
    yourEmailAddress.textAlignment = UITextAlignmentLeft;
    yourEmailAddress.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    yourEmailAddress.keyboardType = UIKeyboardTypeEmailAddress;
    [yourEmailAddress addTarget:self action:@selector(yourEmailNextPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    childsEmailAddress.placeholder = @"Your Child's Email Address";
    childsEmailAddress.autocorrectionType = UITextAutocorrectionTypeNo;
    childsEmailAddress.returnKeyType = UIReturnKeyGo;
    childsEmailAddress.clearsOnBeginEditing = NO;
    childsEmailAddress.textAlignment = UITextAlignmentLeft;
    childsEmailAddress.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    childsEmailAddress.keyboardType = UIKeyboardTypeEmailAddress;
    [childsEmailAddress addTarget:self action:@selector(childsEmailGoPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [super viewDidLoad];
}

- (void)viewDidUnload {
    self.yourEmailAddress = nil;
    self.childsEmailAddress = nil;
    
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Child's Activity Button
-(IBAction)seeChildsActivity:(id)sender {
    // Check whether the data makes sense
    if (![Utilities NSStringIsValidEmail:childsEmailAddress.text]) {
        UIAlertView *badEmailAlert = [[UIAlertView alloc] 
                                      initWithTitle:@"Bad E-mail Address"
                                      message:@"Please Enter a Valid E-mail Address"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [badEmailAlert show];
        [badEmailAlert release];
        [childsEmailAddress becomeFirstResponder];
        return;
    } else if (![Utilities NSStringIsValidEmail:yourEmailAddress.text]) {
        UIAlertView *badEmailAlert = [[UIAlertView alloc] 
                                      initWithTitle:@"Bad E-mail Address"
                                      message:@"Please Enter a Valid E-mail Address"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [badEmailAlert show];
        [badEmailAlert release];
        [yourEmailAddress becomeFirstResponder];
        return;
    }
    
    // TODO: Download the child's activity
}

#pragma mark -
#pragma mark Keyboard Done Button Actions
-(IBAction)yourEmailNextPressed:(id)sender {
    // Check that it's an email address
    if (![Utilities NSStringIsValidEmail:yourEmailAddress.text]) {
        UIAlertView *badEmailAlert = [[UIAlertView alloc] 
                                      initWithTitle:@"Bad E-mail Address"
                                      message:@"Please Enter a Valid E-mail Address"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [badEmailAlert show];
        [badEmailAlert release];
        [yourEmailAddress becomeFirstResponder];
        return;
    } else {
        [childsEmailAddress becomeFirstResponder];
    }
}

-(IBAction)childsEmailGoPressed:(id)sender {
    [childsEmailAddress resignFirstResponder];
    [self seeChildsActivity:nil];
}

-(IBAction)backgroundTap:(id)sender {
    if ([yourEmailAddress isFirstResponder] && ![Utilities NSStringIsValidEmail:yourEmailAddress.text]) {
        UIAlertView *badEmailAlert = [[UIAlertView alloc] 
                                      initWithTitle:@"Bad E-mail Address"
                                      message:@"Please Enter a Valid E-mail Address"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [badEmailAlert show];
        [badEmailAlert release];
        [yourEmailAddress becomeFirstResponder];
    } else if ([childsEmailAddress isFirstResponder] && ![Utilities NSStringIsValidEmail:childsEmailAddress.text]) {
        UIAlertView *badEmailAlert = [[UIAlertView alloc] 
                                      initWithTitle:@"Bad E-mail Address"
                                      message:@"Please Enter a Valid E-mail Address"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [badEmailAlert show];
        [badEmailAlert release];
        [childsEmailAddress becomeFirstResponder];
    } else {
        [yourEmailAddress resignFirstResponder];
        [childsEmailAddress resignFirstResponder];
    }
}

-(IBAction)backButton:(id)sender {
    [rootViewController displayLoginViewController];
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
    
    if (indexPath.row == kYourEmailRow) {
        [cell addSubview:yourEmailAddress];
        [yourEmailAddress setClearButtonMode:UITextFieldViewModeWhileEditing];
    } else if (indexPath.row == kChildsEmailRow) {
        [cell addSubview:childsEmailAddress];
        [childsEmailAddress setClearButtonMode:UITextFieldViewModeWhileEditing];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kYourEmailRow) {
        [yourEmailAddress becomeFirstResponder];
    } else if (indexPath.row == kChildsEmailRow) {
        [childsEmailAddress becomeFirstResponder];
    }
}

-(void)dealloc {
    [yourEmailAddress release];
    [childsEmailAddress release];
    
    [super dealloc];
}

@end
