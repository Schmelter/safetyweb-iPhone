//
//  AccountSetupViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountSetupViewController.h"
#import "AccountSetup1ViewController.h"
#import "AccountSetup2ViewController.h"

@implementation AccountSetupViewController

@synthesize setupModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        setupModel = [[AccountSetupModel alloc] init];
    }
    return self;
}

- (void)setCurrentViewController:(SubAccountSetupViewController*)viewController {
    [viewController retain];
    [currentViewController release];
    currentViewController = viewController;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.view = tempView;
    [tempView release];
}

- (void)viewDidLoad {
    [self displayAccountSetup1ViewController];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Account Setup Display View Controllers

- (void)closeAccountSetup {
    [rootViewController displayLoginViewController];
}

- (void)displayAccountSetup1ViewController {
    AccountSetup1ViewController *accSetup1ViewController = [[AccountSetup1ViewController alloc] initWithNibName:@"AccountSetup1View" bundle:nil];
    [accSetup1ViewController setAccountSetupViewController:self];
    [currentViewController.view removeFromSuperview];
    [self setCurrentViewController:accSetup1ViewController];
    [self.view addSubview:currentViewController.view];
    [accSetup1ViewController release];
}

- (void)displayAccountSetup2ViewController {
    AccountSetup2ViewController *accSetup2ViewController = [[AccountSetup2ViewController alloc] initWithNibName:@"AccountSetup2View" bundle:nil];
    [accSetup2ViewController setAccountSetupViewController:self];
    [currentViewController.view removeFromSuperview];
    [self setCurrentViewController:accSetup2ViewController];
    [self.view addSubview:currentViewController.view];
    [accSetup2ViewController release];
}

- (void)displayMobileAlertOptInViewController {
    
}

- (void)displayMobileAlertSetup1ViewController {
    
}

- (void)displayMobileAlertSetup2ViewController {
    
}

-(void)dealloc {
    [setupModel release];
    [currentViewController release];
    
    [super dealloc];
}

@end

@implementation SubAccountSetupViewController

-(void)setAccountSetupViewController:(AccountSetupViewController *)aAccountSetupViewController {
    // Do not retain, this is our parent
    accountSetupViewController = aAccountSetupViewController;
}

-(void)dealloc {
    // DO NOT release the rootViewController, it's our parent, and we never retained it
    
    [super dealloc];
}

@end
