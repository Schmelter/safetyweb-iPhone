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
@synthesize borderColor;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.borderWidth = 10.0f;
        self.progressCurrent = 0.0f;
        self.borderColor = [[UIColor whiteColor] CGColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.borderWidth = 10.0f;
        self.progressCurrent = 0.0f;
        self.borderColor = [[UIColor whiteColor] CGColor];
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
    CGContextSetStrokeColorWithColor(contextRef, borderColor);
    CGContextSetLineWidth(contextRef, borderWidth);
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

-(void)dealloc {
    [super dealloc];
}

@end
