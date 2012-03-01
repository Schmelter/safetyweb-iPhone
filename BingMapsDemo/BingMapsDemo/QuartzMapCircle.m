//
//  QuartzMapCircle.m
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuartzMapCircle.h"

@implementation QuartzMapCircle

@synthesize center;
@synthesize metersRadius;
@synthesize lineWidth;
@synthesize lineColor;
@synthesize fillColor;

-(QuartzMapCircle*)init {
    self = [super init];
    if (self) {
        center = CLLocationCoordinate2DMake(0.0, 0.0);
        metersRadius = 1609; // 1 mile
        lineWidth = 1.0;
        self.lineColor = [UIColor blackColor];
        self.fillColor = [UIColor clearColor];
    }
    return self;
}

-(BMCoordinateRegion)region {
    return BMCoordinateRegionMakeWithDistance(center, metersRadius, metersRadius);
}

-(void)drawRect:(CGRect)rect withContext:(CGContextRef)context {
    // The rectangle we're given will perfectly fit our circle, so draw the biggest circle possible
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillEllipseInRect(context, rect);
}

-(void)dealloc {
    [lineColor release];
    [fillColor release];
    
    [super dealloc];
}
@end
