//
//  SWAppDelegate.h
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoordinateViewController.h"
#import "ButtonDrivenViewController.h"
#import "QuartzMapViewController.h"

@interface SWAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) UITabBarController *tabBarController;

@end
