//
//  QuartzMapLine.m
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuartzMapLine.h"

@implementation QuartzMapLine

@synthesize lineColor;
@synthesize lineStart;
@synthesize lineEnd;
@synthesize lineWidth;

-(QuartzMapLine*)init {
    self = [super init];
    if (self) {
        self.lineColor = [UIColor blackColor];
        lineStart = CLLocationCoordinate2DMake(0.0, 0.0);
        lineEnd = lineEnd;
        lineWidth = 1.0;
    }
    return self;
}

-(BMCoordinateRegion)region {
    // Calculate the region necessary to contain the line
    double latitude = (lineStart.latitude + lineEnd.latitude) / 2;
    double longitude = (lineStart.longitude + lineEnd.longitude) / 2;
    
    double latDelta = fabs(lineStart.latitude - lineEnd.latitude);
    double longDelta = fabs(lineStart.longitude - lineEnd.longitude);
    
    return BMCoordinateRegionMake(CLLocationCoordinate2DMake(latitude, longitude), BMCoordinateSpanMake(latDelta, longDelta));
}

-(void)drawRect:(CGRect)rect withContext:(CGContextRef)context {
    // The rect we've been given is perfectly sized for the line, so the line will always start in one corner, and go to another corner
    CGContextSetLineWidth(context, lineWidth);
    CGColorRef colorRef = lineColor.CGColor;
    CGContextSetStrokeColorWithColor(context, colorRef);
    
    if (lineStart.latitude > lineEnd.latitude) {
        // line starts at top
        if (lineStart.longitude < lineEnd.longitude) {
            // line starts at left
            CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
            CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
        } else {
            // line starts at right
            CGContextMoveToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
            CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
        }
    } else {
        // line stat at bottom
        if (lineStart.longitude < lineEnd.longitude) {
            // line starts at left
            CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
            CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
        } else {
            // line starts at right
            CGContextMoveToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
            CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
        }
    }
    
    CGContextStrokePath(context);
}


-(void)dealloc {
    [lineColor release];
    
    [super dealloc];
}

@end
