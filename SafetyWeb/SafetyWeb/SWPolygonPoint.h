//
//  SWPolygonPoint.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/20/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SWPoint.h"


@interface SWPolygonPoint : SWPoint

@property (nonatomic, retain) NSNumber * order;

@end
