//
//  SWMenuViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWMenuViewController.h"
#import "AlertsViewController.h"
#import "CheckInViewController.h"
#import "MyPeopleViewController.h"
#import "SettingsViewController.h"

static enum __MenuSelected {
    alertsMS,
    checkInMS,
    myPeopleMS,
    myPlacesMS,
    settingsMS
    } selectedMS = alertsMS;

@implementation SWMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        super.delegate = self;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    @autoreleasepool {
        
        UIImage *selectedImage = [UIImage imageNamed:@"point.png"];
        UIFont *unselectedFont = [UIFont fontWithName:@"Helvetica" size:21];
        UIFont *selectedFont = [UIFont fontWithName:@"Helvetica-Bold" size:21];
        
        UIColor *selectedColor = [UIColor colorWithCGColor:CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){0.3125, 0.63671, 0.8125, 1.0})];
        
        [alertsMI release];
        alertsMI = [[MenuItem alloc] initWithFrame:CGRectMake(0, 0, kMenuItemWidth, kMenuItemHeight)];
        alertsMI.animationDuration = kMenuItemAnim;
        alertsMI.textUnselected = @"Alerts";
        alertsMI.leftImage = selectedImage;
        alertsMI.fontUnselected = unselectedFont;
        alertsMI.textColorUnselected = [UIColor whiteColor];
        alertsMI.textSelected = @"Alerts";
        alertsMI.fontSelected = selectedFont;
        alertsMI.textColorSelected = selectedColor;
        [self addMenuItem:alertsMI];
        
        [checkInMI release];
        checkInMI = [[MenuItem alloc] initWithFrame:CGRectMake(0, 0, kMenuItemWidth, kMenuItemHeight)];
        checkInMI.animationDuration = kMenuItemAnim;
        checkInMI.textUnselected = @"Check In";
        checkInMI.leftImage = selectedImage;
        checkInMI.fontUnselected = unselectedFont;
        checkInMI.textColorUnselected = [UIColor whiteColor];
        checkInMI.textSelected = @"Check In";
        checkInMI.fontSelected = selectedFont;
        checkInMI.textColorSelected = selectedColor;
        [self addMenuItem:checkInMI];
        
        [myPeopleMI release];
        myPeopleMI = [[MenuItem alloc] initWithFrame:CGRectMake(0, 0, kMenuItemWidth, kMenuItemHeight)];
        myPeopleMI.animationDuration = kMenuItemAnim;
        myPeopleMI.textUnselected = @"My People";
        myPeopleMI.leftImage = selectedImage;
        myPeopleMI.fontUnselected = unselectedFont;
        myPeopleMI.textColorUnselected = [UIColor whiteColor];
        myPeopleMI.textSelected = @"My People";
        myPeopleMI.fontSelected = selectedFont;
        myPeopleMI.textColorSelected = selectedColor;
        [self addMenuItem:myPeopleMI];
        
        [myPlacesMI release];
        myPlacesMI = [[MenuItem alloc] initWithFrame:CGRectMake(0, 0, kMenuItemWidth, kMenuItemHeight)];
        myPlacesMI.animationDuration = kMenuItemAnim;
        myPlacesMI.textUnselected = @"My Places";
        myPlacesMI.leftImage = selectedImage;
        myPlacesMI.fontUnselected = unselectedFont;
        myPlacesMI.textColorUnselected = [UIColor whiteColor];
        myPlacesMI.textSelected = @"My Places";
        myPlacesMI.fontSelected = selectedFont;
        myPlacesMI.textColorSelected = selectedColor;
        [self addMenuItem:myPlacesMI];
        
        [settingsMI release];
        settingsMI = [[MenuItem alloc] initWithFrame:CGRectMake(0, 0, kMenuItemWidth, kMenuItemHeight)];
        settingsMI.animationDuration = kMenuItemAnim;
        settingsMI.textUnselected = @"Settings";
        settingsMI.leftImage = selectedImage;
        settingsMI.fontUnselected = unselectedFont;
        settingsMI.textColorUnselected = [UIColor whiteColor];
        settingsMI.textSelected = @"Settings";
        settingsMI.fontSelected = selectedFont;
        settingsMI.textColorSelected = selectedColor;
        [self addMenuItem:settingsMI];
        
        // Set the selected menu based on the selectedMS
        switch (selectedMS) {
            case alertsMS:
                [self setSelectedMenuItem:alertsMI animated:NO];
                break;
            case checkInMS:
                [self setSelectedMenuItem:checkInMI animated:NO];
                break;
            case myPeopleMS:
                [self setSelectedMenuItem:myPeopleMI animated:NO];
                break;
            case myPlacesMS:
                [self setSelectedMenuItem:myPlacesMI animated:NO];
                break;
            case settingsMS:
                [self setSelectedMenuItem:settingsMI animated:NO];
                break;
            default:
                selectedMS = alertsMS;
                [self setSelectedMenuItem:alertsMI animated:NO];
                break;
        }
        
    }
}

- (void)viewDidUnload {
    [alertsMI release];
    alertsMI = nil;
    [checkInMI release];
    checkInMI = nil;
    [myPeopleMI release];
    myPeopleMI = nil;
    [myPlacesMI release];
    myPlacesMI = nil;
    [settingsMI release];
    settingsMI = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark MenuViewControllerDelegate Methods
-(SubMenuViewController*)initContentViewControllerForMenuItem:(MenuItem*)aMenuItem {
    if (aMenuItem == alertsMI) { selectedMS = alertsMS; return [[AlertsViewController alloc] initWithNibName:@"AlertsViewController" bundle:nil]; }
    else if (aMenuItem == checkInMI) { selectedMS = checkInMS;  return [[CheckInViewController alloc] initWithNibName:@"CheckInViewController" bundle:nil]; }
    else if (aMenuItem == myPeopleMI) { selectedMS = myPeopleMS; return [[MyPeopleViewController alloc] initWithNibName:@"MyPeopleViewController" bundle:nil]; }
    else if (aMenuItem == myPlacesMI) { selectedMS = myPlacesMS; return nil; }
    else if (aMenuItem == settingsMI) { selectedMS = settingsMS; return [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil]; }
    else { selectedMS = alertsMS; return [[AlertsViewController alloc] initWithNibName:@"AlertsViewController" bundle:nil]; }
}

-(void)dealloc {
    [alertsMI release];
    [checkInMI release];
    [myPeopleMI release];
    [myPlacesMI release];
    [settingsMI release];
    
    [super dealloc];
}

@end
