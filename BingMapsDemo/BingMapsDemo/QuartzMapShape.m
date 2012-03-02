//
//  QuartzMapShapel.m
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuartzMapShape.h"

@implementation _QMPoint

@synthesize latitude;
@synthesize longitude;

-(_QMPoint*)initWithLocation:(CLLocationCoordinate2D)location {
    self = [super init];
    if (self) {
        latitude = location.latitude;
        longitude = location.longitude;
    }
    return self;
}

-(BOOL)isEqual:(id)other {
    if (other == self) return YES;
    if (!other || ![other isKindOfClass:[_QMPoint class]]) return NO;
    _QMPoint *otherPoint = (_QMPoint*)other;
    return otherPoint.latitude == latitude && otherPoint.longitude == longitude;
}

-(NSUInteger)hash {
    int prime = 31;
    int result = 1;
    result = prime * result + latitude;
    result = prime * result + longitude;
    return result;
}

-(void)dealloc {
    
    [super dealloc];
}

@end
