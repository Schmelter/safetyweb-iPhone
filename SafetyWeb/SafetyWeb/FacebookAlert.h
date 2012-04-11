//
//  FacebookAlert.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/10/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Alert.h"


@interface FacebookAlert : Alert

@property (nonatomic, retain) NSString * friendName;
@property (nonatomic, retain) NSString * alertText;
@property (nonatomic, retain) NSDate * timestamp;

@end
