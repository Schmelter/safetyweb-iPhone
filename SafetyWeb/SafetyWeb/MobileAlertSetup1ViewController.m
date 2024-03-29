//
//  MobileAlertSetup1ViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MobileAlertSetup1ViewController.h"

@implementation MobileAlertSetup1ViewController

@synthesize attButton;
@synthesize verizonButton;
@synthesize sprintButton;
@synthesize tmobileButton;
@synthesize childsMobileNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mobileServiceProvider = -1; // No provider seleted
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
    mobileServiceProvider = accountSetupViewController.setupModel.mobileServiceProvider;
    
    switch (accountSetupViewController.setupModel.mobileServiceProvider) {
        case kAttMobileServiceProvider:
            [attButton setImage:[UIImage imageNamed:@"ATT_btn_on.png"] forState:UIControlStateNormal];
            break;
        case kVerizonMobileServiceProvider:
            [verizonButton setImage:[UIImage imageNamed:@"Verizon_btn_on.png"] forState:UIControlStateNormal];
            break;
        case kSprintMobileServiceProvider:
            [sprintButton setImage:[UIImage imageNamed:@"Sprint_btn_on.png"] forState:UIControlStateNormal];
            break;
        case kTMobileMobileServiceProvider:
            [tmobileButton setImage:[UIImage imageNamed:@"TMobile_btn_on.png"] forState:UIControlStateNormal];
            break;
    }
    
    childsMobileNumber.text = accountSetupViewController.setupModel.childsMobileNumber;
    
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    self.attButton = nil;
    self.verizonButton = nil;
    self.sprintButton = nil;
    self.tmobileButton = nil;
    self.childsMobileNumber = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UITextFieldDelegate methods
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    // Slide up the view if the keyboard will cover one of the inputs
    CGRect rect = self.view.frame;
    // We only have one text view, so no need to check if it's the right one here
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    
    rect.origin.y = kChildsMobileOffset;
    
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    // Slide down the view if the view is slid up
    CGRect rect = self.view.frame;
    // We only have one text view, so no need to check if it's the right one here
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    
    rect.origin.y = 0;
    
    self.view.frame = rect;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark IBAction methods
-(IBAction)continueButton:(id)sender {
    if ([childsMobileNumber.text length] < 7) {
        UIAlertView *badNumberAlert = [[UIAlertView alloc]
                                       initWithTitle:@"No Child Number"
                                       message:@"Please provide a mobile phone number for your child"
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
        [badNumberAlert show];
        [badNumberAlert release];
        [childsMobileNumber becomeFirstResponder];
        return;
    } else if (mobileServiceProvider == -1) {
        // No mobile service provider was selected
        UIAlertView *noProviderAlert = [[UIAlertView alloc]
                                        initWithTitle:@"No Provider"
                                        message:@"Please provide your mobile service provider"
                                        delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
        [noProviderAlert show];
        [noProviderAlert release];
        return;
    }
    
    accountSetupViewController.setupModel.mobileServiceProvider = mobileServiceProvider;
    accountSetupViewController.setupModel.childsMobileNumber = childsMobileNumber.text;
    
    [accountSetupViewController displayMobileAlertSetup2ViewController];
}

-(IBAction)providerButton:(id)sender {
    // TODO: Switch this out with actual images, right now we're just using representative colors
    
    [attButton setImage:[UIImage imageNamed:@"ATT_btn_off.png"] forState:UIControlStateNormal];
    [verizonButton setImage:[UIImage imageNamed:@"Verizon_btn_off.png"] forState:UIControlStateNormal];
    [sprintButton setImage:[UIImage imageNamed:@"Sprint_btn_off.png"] forState:UIControlStateNormal];
    [tmobileButton setImage:[UIImage imageNamed:@"TMobile_btn_off.png"] forState:UIControlStateNormal];
    
    // They pressed one of the provider buttons, figure out which
    if (sender == attButton) {
        [attButton setImage:[UIImage imageNamed:@"ATT_btn_on.png"] forState:UIControlStateNormal];
        mobileServiceProvider = kAttMobileServiceProvider;
    } else if (sender == verizonButton) {
        [verizonButton setImage:[UIImage imageNamed:@"Verizon_btn_on.png"] forState:UIControlStateNormal];
        mobileServiceProvider = kVerizonMobileServiceProvider;
    } else if (sender == sprintButton) {
        [sprintButton setImage:[UIImage imageNamed:@"Sprint_btn_on.png"] forState:UIControlStateNormal];
        mobileServiceProvider = kSprintMobileServiceProvider;
    } else if (sender == tmobileButton) {
        [tmobileButton setImage:[UIImage imageNamed:@"TMobile_btn_on.png"] forState:UIControlStateNormal];
        mobileServiceProvider = kTMobileMobileServiceProvider;
    }
}

-(IBAction)backgroundTap:(id)sender {
    [childsMobileNumber resignFirstResponder];
}

-(IBAction)backButton:(id)sender {
    [accountSetupViewController displayMobileAlertOptInViewController];
}

-(void)dealloc {
    [attButton release];
    [verizonButton release];
    [sprintButton release];
    [tmobileButton release];
    [childsMobileNumber release];
    
    [super dealloc];
}

@end
