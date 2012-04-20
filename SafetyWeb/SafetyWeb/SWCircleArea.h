//
//  SWCircleArea.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/20/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SWArea.h"

@class SWPoint;

@interface SWCircleArea : SWArea

@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) SWPoint *centerPoint;

@end
