//
//  LocationManager.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/20/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWLocation.h"

typedef void(^LocationsResponseBlock)(BOOL, NSArray*, NSError*);
typedef void(^LocationResponseBlock)(BOOL, SWLocation*, NSError*);

@interface LocationManager : NSObject

@end
