//
//  MenuViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController

@synthesize contentView;
@synthesize menuView;
@synthesize delegate;
@synthesize menuButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        nextMenuItemY = 0;
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
    
    @autoreleasepool {
        
        [menuItems release];
        menuItems = [[NSMutableArray alloc] initWithCapacity:10];
        
        menuView.frame = CGRectMake(-[self getMenuWidth], menuView.frame.origin.y, [self getMenuWidth], menuView.frame.size.height);
        
        if (selectedMI) [self setSelectedMenuItem:selectedMI animated:NO];
        
    }
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
        contentRect.origin.x = [self getMenuWidth];
        contentView.frame = contentRect;
        
        if (animated) {
            [UIView commitAnimations];
        }
        
        [menuButton setBackgroundImage:[UIImage imageNamed:@"MenuButton-On.png"] forState:UIControlStateNormal];
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
        menuRect.origin.x = -[self getMenuWidth];
        menuView.frame = menuRect;
        contentRect.origin.x = 0;
        contentView.frame = contentRect;
        
        if (animated) {
            [UIView commitAnimations];
        }
        
        [menuButton setBackgroundImage:[UIImage imageNamed:@"MenuButton-Off.png"] forState:UIControlStateNormal];
    }
    
    isMenuShowing = NO;
}

-(void)setSelectedMenuItem:(MenuItem*)aSelected animated:(BOOL)animated {
    NSTimeInterval menuDelay = kMenuItemAnim + 0.5;
    if (selectedMI != aSelected) {
        [selectedMI setSelected:NO animated:animated];
        selectedMI = aSelected;
        [selectedMI setSelected:YES animated:animated];
        menuDelay = 0.5;
    }
    
    SubMenuViewController *nextViewController = [delegate initContentViewControllerForMenuItem:selectedMI];
    
    [nextViewController setMenuViewController:self];
    [currentViewController.view removeFromSuperview];
    [self setCurrentViewController:nextViewController];
    [contentView addSubview:currentViewController.view];
    [nextViewController release];
    
    [self hideMenu:animated withDelay:menuDelay];
}

-(void)addMenuItem:(MenuItem*)aMenuItem {
    [menuItems addObject:aMenuItem];
    
    [aMenuItem addTarget:self action:@selector(menuItemPressed:) forControlEvents:UIControlEventTouchDown];
    aMenuItem.frame = CGRectMake(0, nextMenuItemY, aMenuItem.frame.size.width, aMenuItem.frame.size.height);
    nextMenuItemY += aMenuItem.frame.size.height;
    [menuView insertSubview:aMenuItem atIndex:[[menuView subviews] count]];
}

// Subclasses should override this for variable menu widths
-(NSInteger)getMenuWidth {
    return 170;
}

#pragma mark -
#pragma mark IBAction Methods
-(IBAction)menuItemPressed:(id)sender {
    [self setSelectedMenuItem:sender animated:YES];
}

-(IBAction)menuButtonPressed:(id)sender {
    // Always animate this.  If they can press the menu button, then they can see everything here.
    if (isMenuShowing) [self hideMenu:YES withDelay:0.0];
    else [self showMenu:YES];
}

- (void)viewDidUnload
{
    self.contentView = nil;
    self.menuView = nil;
    [selectedMI release];
    selectedMI = nil;
    [menuItems release];
    menuItems = nil;
    self.menuButton = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(RootViewController*)getRootViewController {
    return rootViewController;
}

-(void)dealloc {
    [contentView release];
    [menuView release];
    [menuButton release];
    
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
