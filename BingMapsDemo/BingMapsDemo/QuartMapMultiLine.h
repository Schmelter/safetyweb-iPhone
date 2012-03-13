//
//  QuartMapMultiLine.h
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BingMaps/BingMaps.h>
#import "QuartzMapShape.h"

@interface QuartMapMultiLine : NSObject <QuartzMapShape> {
@private
    NSMutableArray *points;
    double lineWidth;
    UIColor *lineColor;
}

@property (assign, nonatomic) double lineWidth;
@property (retain, nonatomic) UIColor *lineColor;

-(void)addPoint:(CLLocationCoordinate2D)point;
-(void)removePoint:(CLLocationCoordinate2D)point;

-(BMCoordinateRegion)region;

-(void)drawRect:(CGRect)rect withContext:(CGContextRef)context;

-(int)qmPoints:(CLLocationCoordinate2D**)pointArr;

@end
