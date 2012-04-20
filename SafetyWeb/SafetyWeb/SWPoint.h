//
//  SWPoint.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/20/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SWLocation.h"

@class SWArea;

@interface SWPoint : SWLocation

@property (nonatomic, retain) SWArea *area;

@end
