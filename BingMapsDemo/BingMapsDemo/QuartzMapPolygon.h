//
//  QuartzMapPolygon.h
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BingMaps/BingMaps.h>
#import "QuartzMapShape.h"

@interface QuartzMapPolygon : NSObject <QuartzMapShape> {
    @private
    NSMutableArray *points;
    double lineWidth;
    UIColor *lineColor;
    UIColor *fillColor;
}

@property (assign, nonatomic) double lineWidth;
@property (retain, nonatomic) UIColor *lineColor;
@property (retain, nonatomic) UIColor *fillColor;

-(void)addPoint:(CLLocationCoordinate2D)point;
-(void)removePoint:(CLLocationCoordinate2D)point;

-(BMCoordinateRegion)region;

-(void)drawRect:(CGRect)rect withContext:(CGContextRef)context;

@end
