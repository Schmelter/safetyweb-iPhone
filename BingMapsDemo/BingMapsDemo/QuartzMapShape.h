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
 * Represents a shape in the QuartzMapView that can be drawn.
 */

@protocol QuartzMapShape <NSObject>

-(BMCoordinateRegion)region;

-(void)drawRect:(CGRect)rect withContext:(CGContextRef)context;

@end
