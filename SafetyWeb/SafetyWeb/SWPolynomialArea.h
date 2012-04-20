//
//  SWPolynomialArea.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/20/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SWArea.h"

@class SWPolynomialPoint;

@interface SWPolynomialArea : SWArea

@property (nonatomic, retain) NSSet *points;
@end

@interface SWPolynomialArea (CoreDataGeneratedAccessors)

- (void)addPointsObject:(SWPolynomialPoint *)value;
- (void)removePointsObject:(SWPolynomialPoint *)value;
- (void)addPoints:(NSSet *)values;
- (void)removePoints:(NSSet *)values;
@end
