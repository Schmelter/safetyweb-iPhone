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
    CGColorRef borderColor;
    CGFloat progressCurrent;
}

@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGColorRef borderColor;
@property (nonatomic) CGFloat progressCurrent;

@end
