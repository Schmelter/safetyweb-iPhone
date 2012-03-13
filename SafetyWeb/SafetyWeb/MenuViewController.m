//
//  MenuViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"
#import "AlertsViewController.h"
#import "CheckInViewController.h"

@implementation MenuViewController

@synthesize alertsMI;
@synthesize checkInMI;
@synthesize myPeopleMI;
@synthesize myPlacesMI;
@synthesize settingsMI;
@synthesize contentView;
@synthesize menuView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isMenuShowing = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)setCurrentViewController:(SubMenuViewController*)aSubMenuViewController {
    [aSubMenuViewController retain];
    [currentViewController release];
    currentViewController = aSubMenuViewController;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    UIImage *selectedImage = [UIImage imageNamed:@"point.png"];
    UIFont *unselectedFont = [UIFont fontWithName:@"Helvetica" size:21];
    UIFont *selectedFont = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    
    UIColor *selectedColor = [UIColor colorWithCGColor:CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){0.3125, 0.63671, 0.8125, 1.0})];
    
    alertsMI.animationDuration = kMenuItemAnim;
    alertsMI.textUnselected = @"Alerts";
    alertsMI.leftImageUnselected = nil;
    alertsMI.fontUnselected = unselectedFont;
    alertsMI.textColorUnselected = [UIColor whiteColor];
    alertsMI.textSelected = @"Alerts";
    alertsMI.leftImageSelected = selectedImage;
    alertsMI.fontSelected = selectedFont;
    alertsMI.textColorSelected = selectedColor;
    
    checkInMI.animationDuration = kMenuItemAnim;
    checkInMI.textUnselected = @"Check In";
    checkInMI.leftImageUnselected = nil;
    checkInMI.fontUnselected = unselectedFont;
    checkInMI.textColorUnselected = [UIColor whiteColor];
    checkInMI.textSelected = @"Check In";
    checkInMI.leftImageSelected = selectedImage;
    checkInMI.fontSelected = selectedFont;
    checkInMI.textColorSelected = selectedColor;
    
    myPeopleMI.animationDuration = kMenuItemAnim;
    myPeopleMI.textUnselected = @"My People";
    myPeopleMI.leftImageUnselected = nil;
    myPeopleMI.fontUnselected = unselectedFont;
    myPeopleMI.textColorUnselected = [UIColor whiteColor];
    myPeopleMI.textSelected = @"My People";
    myPeopleMI.leftImageSelected = selectedImage;
    myPeopleMI.fontSelected = selectedFont;
    myPeopleMI.textColorSelected = selectedColor;
    
    myPlacesMI.animationDuration = kMenuItemAnim;
    myPlacesMI.textUnselected = @"My Places";
    myPlacesMI.leftImageUnselected = nil;
    myPlacesMI.fontUnselected = unselectedFont;
    myPlacesMI.textColorUnselected = [UIColor whiteColor];
    myPlacesMI.textSelected = @"My Places";
    myPlacesMI.leftImageSelected = selectedImage;
    myPlacesMI.fontSelected = selectedFont;
    myPlacesMI.textColorSelected = selectedColor;
    
    settingsMI.animationDuration = kMenuItemAnim;
    settingsMI.textUnselected = @"Settings";
    settingsMI.leftImageUnselected = nil;
    settingsMI.fontUnselected = unselectedFont;
    settingsMI.textColorUnselected = [UIColor whiteColor];
    settingsMI.textSelected = @"Settings";
    settingsMI.leftImageSelected = selectedImage;
    settingsMI.fontSelected = selectedFont;
    settingsMI.textColorSelected = selectedColor;
                             
    [pool release];
}

#pragma mark -
#pragma mark Menu Control Methods
-(void)showMenu:(BOOL)animated {
    // Check if we need to move the menu
    CGRect menuRect = menuView.frame;
    CGRect contentRect = contentView.frame;
    if (!isMenuShowing) {
        if (animated) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:1.0];
        }
        
        // Slide the menu out
        menuRect.origin.x = 0;
        menuView.frame = menuRect;
        contentRect.origin.x = kContentEndX;
        contentView.frame = contentRect;
        
        if (animated) {
            [UIView commitAnimations];
        }
    }
    
    isMenuShowing = YES;
}

-(void)hideMenu:(BOOL)animated withDelay:(NSTimeInterval)delay {
    // Check if we need to move the menu
    CGRect menuRect = menuView.frame;
    CGRect contentRect = contentView.frame;
    if (isMenuShowing) {
        if (animated) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationDelay:delay];
        }
        
        // Slide the menu in
        menuRect.origin.x = kMenuStartX;
        menuView.frame = menuRect;
        contentRect.origin.x = 0;
        contentView.frame = contentRect;
        
        if (animated) {
            [UIView commitAnimations];
        }
    }
    
    isMenuShowing = NO;
}

#pragma mark -
#pragma mark IBAction Methods
-(IBAction)menuItemPressed:(id)sender {
    [selectedMI setSelected:NO animated:YES];
    selectedMI = sender;
    [selectedMI setSelected:YES animated:YES];
    
    
    SubMenuViewController *nextViewController = nil;
    if (selectedMI == alertsMI) nextViewController = [[AlertsViewController alloc] initWithNibName:@"AlertsViewController" bundle:nil];
    else if (selectedMI == checkInMI) nextViewController = [[CheckInViewController alloc] initWithNibName:@"CheckInViewController" bundle:nil];
    
    
    [nextViewController setMenuViewController:self];
    [currentViewController.view removeFromSuperview];
    [self setCurrentViewController:nextViewController];
    [contentView addSubview:currentViewController.view];
    [nextViewController release];
    
    [self hideMenu:YES withDelay:kMenuItemAnim];
}

-(IBAction)menuButtonPressed:(id)sender {
    // Always animate this.  If they can press the menu button, then they can see everything here.
    if (isMenuShowing) [self hideMenu:YES withDelay:0.0];
    else [self showMenu:YES];
}

- (void)viewDidUnload
{
    self.alertsMI = nil;
    self.checkInMI = nil;
    self.myPeopleMI = nil;
    self.myPlacesMI = nil;
    self.settingsMI = nil;
    self.contentView = nil;
    self.menuView = nil;
    selectedMI = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc {
    [alertsMI release];
    [checkInMI release];
    [myPeopleMI release];
    [myPlacesMI release];
    [settingsMI release];
    [contentView release];
    [menuView release];
    
    [super dealloc];
}

@end


@implementation SubMenuViewController

-(void)setMenuViewController:(MenuViewController *)aMenuViewController {
    // Do not retain, this is our parent
    menuViewController = aMenuViewController;
}

-(void)dealloc {
    // DO NOT release the menuViewController, it's our parent, and we never retained it
    
    [super dealloc];
}

@end
