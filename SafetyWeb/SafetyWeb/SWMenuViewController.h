//
//  SWMenuViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

#define kMenuItemWidth 170
#define kMenuItemHeight 45

@interface SWMenuViewController : MenuViewController <MenuViewControllerDelegate> {
    @private
    MenuItem *alertsMI;
    MenuItem *checkInMI;
    MenuItem *myPeopleMI;
    MenuItem *myPlacesMI;
    MenuItem *settingsMI;
}

@end
