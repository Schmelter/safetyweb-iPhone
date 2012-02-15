//
//  LoadView.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadView.h"

@implementation LoadView

@synthesize borderWidth;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.borderWidth = 10.0f;
        self.progressCurrent = 0.0f;
        self.outterBorderColor = [[UIColor blackColor] CGColor];
        self.innerBorderColor = [[UIColor whiteColor] CGColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.borderWidth = 10.0f;
        self.progressCurrent = 0.0f;
        self.outterBorderColor = [[UIColor blackColor] CGColor];
        self.innerBorderColor = [[UIColor whiteColor] CGColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (progressCurrent == 0.0f) return; // Nothing to draw
    
    // Find the middle point of the rect we're being drawn within
    CGPoint center = CGPointMake(rect.origin.x + (rect.size.width/2), rect.origin.y + (rect.size.height/2));
    CGFloat radius = rect.size.width < rect.size.height ? rect.size.width / 2 : rect.size.height / 2;
    radius -= borderWidth/2.0f;
    
    // Find the length of the arc in radians
    float radians = ((2.0f * M_PI) * (progressCurrent/kProgressTotal)) - M_PI_2;
    
    // In the special case where we need to draw a full circle, set the radians to slightly less than 1.5*pi
    if (kProgressTotal == progressCurrent) {
        radians = 1.5f*M_PI - 0.001;
    }
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextRetain(contextRef);
    
    CGContextSetLineCap(contextRef, kCGLineCapRound);
    
    // Draw the outter border
    CGContextSetStrokeColorWithColor(contextRef, outterBorderColor);
    CGContextSetLineWidth(contextRef, borderWidth);
    CGContextAddArc(contextRef, center.x, center.y, radius, M_PI * 1.5f, radians, 0);
    CGContextStrokePath(contextRef);
    
    // Draw the inner border
    CGContextSetStrokeColorWithColor(contextRef, innerBorderColor);
    CGContextSetLineWidth(contextRef, borderWidth/2.0f);
    CGContextAddArc(contextRef, center.x, center.y, radius, M_PI * 1.5f, radians, 0);
    CGContextStrokePath(contextRef);
    
    CGContextRelease(contextRef);
}

-(void)setProgressCurrent:(CGFloat)aProgressCurrent {
    progressCurrent = aProgressCurrent;
    [self setNeedsDisplay];
}

-(CGFloat)progressCurrent {
    return progressCurrent;
}

-(void)setOutterBorderColor:(CGColorRef)aOutterBorderColor {
    CGColorRetain(aOutterBorderColor);
    CGColorRelease(outterBorderColor);
    outterBorderColor = aOutterBorderColor;
}

-(CGColorRef)outterBorderColor {
    return outterBorderColor;
}

-(void)setInnerBorderColor:(CGColorRef)aInnerBorderColor {
    CGColorRetain(aInnerBorderColor);
    CGColorRelease(innerBorderColor);
    innerBorderColor = aInnerBorderColor;
}

-(CGColorRef)innerBorderColor {
    return innerBorderColor;
}

-(void)dealloc {
    CGColorRelease(outterBorderColor);
    CGColorRelease(innerBorderColor);
    
    [super dealloc];
}

@end
