//
//  MenuViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "MenuItem.h"

#define kMenuStartX -170
#define kContentEndX 170
#define kMenuItemAnim 0.5

@class SubMenuViewController;

@interface MenuViewController : SubRootViewController {
    @private
    SubMenuViewController *currentViewController;
    BOOL isMenuShowing;
    
    MenuItem *alertsMI;
    MenuItem *checkInMI;
    MenuItem *myPeopleMI;
    MenuItem *myPlacesMI;
    MenuItem *settingsMI;
    MenuItem *selectedMI;
    
    UIView *contentView;
    UIView *menuView;
}

@property (nonatomic, retain) IBOutlet MenuItem *alertsMI;
@property (nonatomic, retain) IBOutlet MenuItem *checkInMI;
@property (nonatomic, retain) IBOutlet MenuItem *myPeopleMI;
@property (nonatomic, retain) IBOutlet MenuItem *myPlacesMI;
@property (nonatomic, retain) IBOutlet MenuItem *settingsMI;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UIView *menuView;

-(IBAction)menuItemPressed:(id)sender;
-(IBAction)menuButtonPressed:(id)sender;

@end

@interface SubMenuViewController : UIViewController {
@private
    MenuViewController *menuViewController;
}

-(void)setMenuViewController:(MenuViewController *)aMenuViewController;

@end
