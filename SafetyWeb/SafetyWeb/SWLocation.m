//
//  SWLocation.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/20/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "SWLocation.h"


@implementation SWLocation

@dynamic latitude;
@dynamic longitude;

-(CLLocationCoordinate2D)getLocation {
    return CLLocationCoordinate2DMake([[self primitiveValueForKey:@"latitude"] floatValue], [[self primitiveValueForKey:@"longitude"] floatValue]);
}

@end
