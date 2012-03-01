//
//  QuartzMapCircle.h
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BingMaps/BingMaps.h>
#import "QuartzMapShape.h"

@interface QuartzMapCircle : NSObject <QuartzMapShape> {
    @private
    CLLocationCoordinate2D center;
    NSInteger metersRadius;
    double lineWidth;
    UIColor *lineColor;
    UIColor *fillColor;
}

@property (assign, nonatomic) CLLocationCoordinate2D center;
@property (assign, nonatomic) NSInteger metersRadius;
@property (assign, nonatomic) double lineWidth;
@property (retain, nonatomic) UIColor *lineColor;
@property (retain, nonatomic) UIColor *fillColor;

-(BMCoordinateRegion)region;

-(void)drawRect:(CGRect)rect withContext:(CGContextRef)context;

@end
