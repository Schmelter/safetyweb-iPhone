//
//  QuartzMapPolygon.m
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuartzMapPolygon.h"

@implementation QuartzMapPolygon

@synthesize lineWidth;
@synthesize lineColor;
@synthesize fillColor;

-(QuartzMapPolygon*)init {
    self = [super init];
    if (self) {
        points = [[NSMutableArray alloc] initWithCapacity:10];
        lineWidth = 1.0;
        lineColor = [UIColor blackColor];
        fillColor = [UIColor clearColor];
    }
    return self;
}

-(void)addPoint:(CLLocationCoordinate2D)point {
    _QMPoint *qmPoint = [[_QMPoint alloc] initWithLocation:point];
    [points addObject:qmPoint];
    [qmPoint release];
}

-(void)removePoint:(CLLocationCoordinate2D)point {
    _QMPoint *qmPoint = [[_QMPoint alloc] initWithLocation:point];
    [points removeObject:qmPoint];
    [qmPoint release];
}

-(BMCoordinateRegion)region {
    // We can't draw anything if we have one or fewer points
    if ([points count] <= 1) return BMCoordinateRegionMake(CLLocationCoordinate2DMake(0, 0), BMCoordinateSpanMake(0, 0));
    
    // We need to figure out the region by finding the highest point, the lowest point, the leftmost point, and the rightmost point
    NSEnumerator *iter = [points objectEnumerator];
    _QMPoint *point = nil;
    double highest = -180.0;
    double lowest = 180.0;
    double leftmost = 180.0;
    double rightmost = -180.0;
    while (point = [iter nextObject]) {
        if (point.longitude < leftmost) leftmost = point.longitude;
        if (point.longitude > rightmost) rightmost = point.longitude;
        if (point.latitude > highest) highest = point.latitude;
        if (point.latitude < lowest) lowest = point.latitude;
    }
    
    return BMCoordinateRegionMake(CLLocationCoordinate2DMake((highest + lowest)/2, (rightmost + leftmost)/2), BMCoordinateSpanMake(highest - lowest, rightmost - leftmost));
}

-(void)drawRect:(CGRect)rect withContext:(CGContextRef)context {
    // We have a rect here that is just big enough to contain our drawing.  So we need to figure out what our max limts
    // are, and map our points based on that
    if ([points count] <= 1) return;
    
    NSEnumerator *iter = [points objectEnumerator];
    _QMPoint *point = nil;
    double highest = -180.0;
    double lowest = 180.0;
    double leftmost = 180.0;
    double rightmost = -180.0;
    while (point = [iter nextObject]) {
        if (point.longitude < leftmost) leftmost = point.longitude;
        if (point.longitude > rightmost) rightmost = point.longitude;
        if (point.latitude > highest) highest = point.latitude;
        if (point.latitude < lowest) lowest = point.latitude;
    }
    
    double latHeight = highest - lowest;
    double longWidth = rightmost - leftmost;
    
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    
    _QMPoint *firstPoint = [points objectAtIndex:0];
    CGContextMoveToPoint(context, (rect.origin.x + (rect.size.width * ((firstPoint.longitude - leftmost) / longWidth))), (rect.origin.y + (rect.size.height * ((highest - firstPoint.latitude) / latHeight))));
    
    iter = [points objectEnumerator];
    [iter nextObject]; // We already placed the first point above
    while (point = [iter nextObject]) {
        CGContextAddLineToPoint(context, (rect.origin.x + (rect.size.width * ((point.longitude - leftmost) / longWidth))), (rect.origin.y + (rect.size.height * ((highest - point.latitude) / latHeight))));
    }
    
    CGContextClosePath(context);
    
    CGContextFillPath(context);
    
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    
    firstPoint = [points objectAtIndex:0];
    CGContextMoveToPoint(context, (rect.origin.x + (rect.size.width * ((firstPoint.longitude - leftmost) / longWidth))), (rect.origin.y + (rect.size.height * ((highest - firstPoint.latitude) / latHeight))));
    
    iter = [points objectEnumerator];
    [iter nextObject]; // We already placed the first point above
    while (point = [iter nextObject]) {
        CGContextAddLineToPoint(context, (rect.origin.x + (rect.size.width * ((point.longitude - leftmost) / longWidth))), (rect.origin.y + (rect.size.height * ((highest - point.latitude) / latHeight))));
    }
    
    CGContextClosePath(context);
    
    CGContextStrokePath(context);
}

-(void)dealloc {
    [points release];
    [lineColor release];
    [fillColor release];
    
    [super dealloc];
}

@end
