//
//  CheckInAlert.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/10/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Alert.h"


@interface CheckInAlert : Alert

@property (nonatomic, retain) NSString * locationStr;
@property (nonatomic, retain) NSNumber * locationLat;
@property (nonatomic, retain) NSNumber * locationLong;
@property (nonatomic, retain) NSNumber * locationApproved;
@property (nonatomic, retain) NSDate * timestamp;

@end
