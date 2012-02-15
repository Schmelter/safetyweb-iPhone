//
//  LoadView.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kProgressTotal      100.0f

@interface LoadView : UIView {
    @private
    CGFloat borderWidth;
    CGColorRef outterBorderColor;
    CGColorRef innerBorderColor;
    CGFloat progressCurrent;
}

@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGColorRef outterBorderColor;
@property (nonatomic) CGColorRef innerBorderColor;
@property (nonatomic) CGFloat progressCurrent;

@end
