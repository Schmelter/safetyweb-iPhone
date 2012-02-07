//
//  ResetPasswordViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResetPasswordViewController.h"

@implementation ResetPasswordViewController

@synthesize emailAddress;

#pragma mark -
#pragma mark View Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
}

- (void)viewDidUnload {
    self.emailAddress = nil;
    
    [super viewDidUnload];
}

#pragma mark -
#pragma mark IBActions
-(IBAction)backgroundTap:(id)sender {
    [emailAddress resignFirstResponder];
}

-(IBAction)emailGoButton:(id)sender {
    NSString *emailAddressStr = [emailAddress text];
    if (![Utilities NSStringIsValidEmail:emailAddressStr]) {
        UIAlertView *badEmailAlert = [[UIAlertView alloc] 
                                      initWithTitle:@"Bad E-mail Address"
                                      message:@"Please Enter a Valid E-mail Address"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [badEmailAlert show];
        [badEmailAlert release];
        return;
    }
    // TODO: Ask the UserManager or some other Manager to request an email with their username
    [rootViewController displayLoginViewController];
}

-(void)dealloc {
    [emailAddress release];
    
    [super dealloc];
}

@end
