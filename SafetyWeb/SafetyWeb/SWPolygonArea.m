//
//  SWPolygonArea.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/20/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "SWPolygonArea.h"
#import "SWPolygonPoint.h"

NSInteger pointSort(id point1, id point2, void *context);

@implementation SWPolygonArea

@dynamic points;

NSInteger pointSort(id point1, id point2, void *context) {
    return [[(SWPolygonPoint*)point1 order] compare:[(SWPolygonPoint*)point2 order]];
}

-(NSArray*)sortedPoints {
    NSSet *unsortedPoints = (NSSet*)[self primitiveValueForKey:@"points"];
    return [[unsortedPoints allObjects] sortedArrayUsingFunction:pointSort context:nil];
}

@end
