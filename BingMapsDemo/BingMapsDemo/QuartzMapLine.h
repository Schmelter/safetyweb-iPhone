//
//  QuartzMapLine.h
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BingMaps/BingMaps.h>
#import "QuartzMapShape.h"

@interface QuartzMapLine : NSObject <QuartzMapShape> {
@private
    UIColor *lineColor;
    CLLocationCoordinate2D lineStart;
    CLLocationCoordinate2D lineEnd;
    double lineWidth;
}

@property (retain, nonatomic) UIColor *lineColor;
@property (assign, nonatomic) CLLocationCoordinate2D lineStart;
@property (assign, nonatomic) CLLocationCoordinate2D lineEnd;
@property (nonatomic) double lineWidth;

-(BMCoordinateRegion)region;

-(void)drawRect:(CGRect)rect withContext:(CGContextRef)context;

-(int)qmPoints:(CLLocationCoordinate2D**)pointArr;

@end
