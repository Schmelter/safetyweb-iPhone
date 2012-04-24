//
//  SWLocation.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/20/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SWLocation : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

-(CLLocationCoordinate2D)getLocation;

@end
