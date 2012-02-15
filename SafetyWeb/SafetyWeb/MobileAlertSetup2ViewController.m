//
//  MobileAlertSetup2ViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MobileAlertSetup2ViewController.h"

@implementation MobileAlertSetup2ViewController

@synthesize mobileUserId;
@synthesize mobilePassword;
@synthesize providerImage;
@synthesize userIDLabel;
@synthesize passwordLabel;

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
    switch (accountSetupViewController.setupModel.mobileServiceProvider) {
        case kAttMobileServiceProvider:
            userIDLabel.text = @"Your User ID for Your AT&T Wireless Account:";
            passwordLabel.text = @"Your Password for Your AT&T Wireless Account:";
            providerImage.image = [UIImage imageNamed:@"ServiceProviderATT.png"];
            break;
        case kVerizonMobileServiceProvider:
            userIDLabel.text = @"Your User ID for Your Verizon Wireless Account:";
            passwordLabel.text = @"Your Password for Your Verizon Wireless Account:";
            providerImage.image = [UIImage imageNamed:@"ServiceProviderVerizon.png"];
            break;
        case kSprintMobileServiceProvider:
            userIDLabel.text = @"Your User ID for Your Sprint Wireless Account:";
            passwordLabel.text = @"Your Password for Your Sprint Wireless Account:";
            providerImage.image = [UIImage imageNamed:@"ServiceProviderSprint.png"];
            break;
        case kTMobileMobileServiceProvider:
            userIDLabel.text = @"Your User ID for Your T-Mobile Wireless Account:";
            passwordLabel.text = @"Your Password for Your T-Mobile Wireless Account:";
            providerImage.image = [UIImage imageNamed:@"ServiceProviderTMobile.png"];
            break;
    }
    
    mobileUserId.text = accountSetupViewController.setupModel.mobileUserId;
    mobilePassword.text = accountSetupViewController.setupModel.mobilePassword;
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    self.mobileUserId = nil;
    self.mobilePassword = nil;
    self.providerImage = nil;
    self.userIDLabel = nil;
    self.passwordLabel = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UITextFieldDelegate methods
-(IBAction)didEndOnExit:(id)sender {
    if (sender == mobileUserId) {
        if ([mobileUserId.text length] <= 0) {
            UIAlertView *badUserAlert = [[UIAlertView alloc]
                                         initWithTitle:@"No User Given"
                                         message:@"Please provide a valid user name for this mobile account"
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            [badUserAlert show];
            [badUserAlert release];
            [mobileUserId becomeFirstResponder];
            return;
        } else {
            [mobilePassword becomeFirstResponder];
        }
    } else if (sender == mobilePassword) {
        if ([mobilePassword.text length] <= 0) {
            UIAlertView *badPassword = [[UIAlertView alloc]
                                        initWithTitle:@"No Password Given"
                                        message:@"Please provide a valid password for this mobile account"
                                        delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
            [badPassword show];
            [badPassword release];
            [mobilePassword becomeFirstResponder];
            return;
        } else {
            [self continueButton:sender];
        }
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    // Slide up the view if the keyboard will cover one of the inputs
    CGRect rect = self.view.frame;
    if (textField == mobileUserId) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];
        
        rect.origin.y = kMobileUserIdOffset;
        
        self.view.frame = rect;
        [UIView commitAnimations];
    } else if (textField == mobilePassword) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];
        
        rect.origin.y = kMobilePasswordOffset;
        
        self.view.frame = rect;
        [UIView commitAnimations];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    // Slide down the view if the view is slid up
    CGRect rect = self.view.frame;
    if (textField == mobileUserId || textField == mobilePassword) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];
        
        rect.origin.y = 0;
        
        self.view.frame = rect;
        [UIView commitAnimations];
    }
}

#pragma mark -
#pragma mark IBAction methods
-(IBAction)backgroundTap:(id)sender {
    [mobileUserId resignFirstResponder];
    [mobilePassword resignFirstResponder];
}

-(IBAction)continueButton:(id)sender {
    if ([mobileUserId.text length] <= 0) {
        UIAlertView *badUserAlert = [[UIAlertView alloc]
                                     initWithTitle:@"No User Given"
                                     message:@"Please provide a valid user name for this mobile account"
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        [badUserAlert show];
        [badUserAlert release];
        [mobileUserId becomeFirstResponder];
        return;
    } else if ([mobilePassword.text length] <= 0) {
        UIAlertView *badPassword = [[UIAlertView alloc]
                                    initWithTitle:@"No Password Given"
                                    message:@"Please provide a valid password for this mobile account"
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
        [badPassword show];
        [badPassword release];
        [mobilePassword becomeFirstResponder];
        return;
    }
    
    accountSetupViewController.setupModel.mobileUserId = mobileUserId.text;
    accountSetupViewController.setupModel.mobilePassword = mobilePassword.text;
    
    // TODO: Start the account creation process here, or ask the AccountSetupViewController to start it
    [accountSetupViewController closeAccountSetup];
}

-(IBAction)backButton:(id)sender {
    [accountSetupViewController displayMobileAlertSetup1ViewController];
}

-(void)dealloc {
    [mobileUserId release];
    [mobilePassword release];
    [providerImage release];
    [userIDLabel release];
    [passwordLabel release];
    
    [super dealloc];
}

@end
