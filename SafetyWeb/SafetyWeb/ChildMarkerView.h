//
//  ChildMarkerView.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/24/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Child.h"

@protocol ChildMarkerViewDelegate <NSObject>
-(void)detailsButtonPressed:(Child*)aChild;
@end



@interface ChildMarkerView : UIControl {
    @private
    BOOL isExpanded;
    
    UILabel *childName;
    UILabel *childLocation;
    UIImageView *childImage;
    UIButton *detailsButton;
}

@property (nonatomic, readonly) BOOL isExpanded;

-(ChildMarkerView*)initDefaultSize;

-(void)setExpanded:(BOOL)expanded animated:(BOOL)animated;

-(void)setChildName:(NSString*)aChildName;
-(void)setChildLocation:(NSString*)aChildLocation;
-(void)setChildImage:(UIImage*)aChildImage;

@end
