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

#define kMenuItemAnim 0.5

@class SubMenuViewController;

@protocol MenuViewControllerDelegate <NSObject>

-(SubMenuViewController*)initContentViewControllerForMenuItem:(MenuItem*)aMenuItem;

@end

@interface MenuViewController : SubRootViewController {
    @private
    SubMenuViewController *currentViewController;
    BOOL isMenuShowing;
    
    NSMutableArray *menuItems;
    NSInteger nextMenuItemY;
    MenuItem *selectedMI;
    
    id<MenuViewControllerDelegate> delegate;
    
    UIView *contentView;
    UIView *menuView;
    
    UIButton *menuButton;
}

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UIView *menuView;
@property (nonatomic, assign) id<MenuViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIButton *menuButton;

-(IBAction)menuItemPressed:(id)sender;
-(IBAction)menuButtonPressed:(id)sender;

-(void)setSelectedMenuItem:(MenuItem*)aSelected animated:(BOOL)animated;
-(void)addMenuItem:(MenuItem*)aMenuItem;
-(NSInteger)getMenuWidth;

-(RootViewController*)getRootViewController;

@end

@interface SubMenuViewController : UIViewController {
@protected
    MenuViewController *menuViewController;
}

-(void)setMenuViewController:(MenuViewController *)aMenuViewController;

@end
