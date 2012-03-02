//
//  QuartzMapShape.h
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BingMaps/BingMaps.h>

/**
 * _QMPoint is a wrapper for a lat/long combination
 */

@interface _QMPoint : NSObject {
@private
    CLLocationDegrees latitude;
    CLLocationDegrees longitude;
}

@property (readwrite, assign, nonatomic) CLLocationDegrees latitude;
@property (readwrite, assign, nonatomic) CLLocationDegrees longitude;

-(_QMPoint*)initWithLocation:(CLLocationCoordinate2D)location;

@end

/**
 * Represents a shape in the QuartzMapView that can be drawn.
 */

@protocol QuartzMapShape <NSObject>

-(BMCoordinateRegion)region;

-(void)drawRect:(CGRect)rect withContext:(CGContextRef)context;

@end
