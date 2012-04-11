//
//  Alert.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/10/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Alert : NSManagedObject

@property (nonatomic, retain) NSNumber * alertId;
@property (nonatomic, retain) NSNumber * childId;
@property (nonatomic, retain) User *user;

@end
