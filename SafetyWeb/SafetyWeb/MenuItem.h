//
//  MenuItem.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 * Represents a pressable, selectable item in the Menu of the MenuViewController.
 * It has two states, selected and unselected.
 * For each state it has properties for: leftImage, textColor, textFont
 * The MenuItemDelegate protocol should be on anything that listens for MenuItem
 * events.
 */

#import <UIKit/UIKit.h>

@interface MenuItem : UIControl {
    @private
    BOOL isSelected;
    NSTimeInterval animationDuration;
    
    UILabel *textLabel;
    UIImageView *leftImageView;
    
    // Properties for when the menu item is not selected
    UIImage *leftImageUnselected;
    UIFont *fontUnselected;
    UIColor *textColorUnselected;
    NSString *textUnselected;
    
    // Properties for when the menu item is selected
    UIImage *leftImageSelected;
    UIFont *fontSelected;
    UIColor *textColorSelected;
    NSString *textSelected;
}

@property (nonatomic) NSTimeInterval animationDuration;
@property (nonatomic, retain) UIImage *leftImageUnselected;
@property (nonatomic, retain) UIFont *fontUnselected;
@property (nonatomic, retain) UIColor *textColorUnselected;
@property (nonatomic, retain) NSString *textUnselected;
@property (nonatomic, retain) UIImage *leftImageSelected;
@property (nonatomic, retain) UIFont *fontSelected;
@property (nonatomic, retain) UIColor *textColorSelected;
@property (nonatomic, retain) NSString *textSelected;

-(void)setSelected:(BOOL)aSelected animated:(BOOL)animated;

@end
