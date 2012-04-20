//
//  SWPolygonArea.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/20/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SWArea.h"

@class SWPolygonPoint;

@interface SWPolygonArea : SWArea

@property (nonatomic, retain) NSSet *points;
@end

@interface SWPolygonArea (CoreDataGeneratedAccessors)

- (void)addPointsObject:(SWPolygonPoint *)value;
- (void)removePointsObject:(SWPolygonPoint *)value;
- (void)addPoints:(NSSet *)values;
- (void)removePoints:(NSSet *)values;

-(NSArray*)sortedPoints;
@end
