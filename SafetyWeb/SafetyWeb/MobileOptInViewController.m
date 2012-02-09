//
//  MobileOptInViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MobileOptInViewController.h"

@implementation MobileOptInViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark IBAction methods

-(IBAction)yesMobileAlerts:(id)sender {
    accountSetupViewController.setupModel.mobileAlerts = YES;
    [accountSetupViewController displayMobileAlertSetup1ViewController];
}

-(IBAction)noMobileAlerts:(id)sender {
    accountSetupViewController.setupModel.mobileAlerts = NO;
    [accountSetupViewController displayMobileAlertSetup1ViewController];
}

-(IBAction)backButton:(id)sender {
    [accountSetupViewController displayAccountSetup2ViewController];
}

@end
