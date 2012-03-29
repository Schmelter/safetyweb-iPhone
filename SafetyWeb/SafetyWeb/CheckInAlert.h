//
//  CheckInAlert.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/29/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlertManager.h"

@interface CheckInAlert : NSObject <Alert> {
    @private
    NSNumber *alertId;
    NSNumber *childId;
    NSString *locationStr;
    CLLocationCoordinate2D location;
    BOOL locationApproved;
    NSTimeInterval timestamp;
}

@property (nonatomic, retain) NSNumber *alertId;
@property (nonatomic, retain) NSNumber *childId;
@property (nonatomic, retain) NSString *locationStr;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic) BOOL locationApproved;
@property (nonatomic) NSTimeInterval timestamp;

@end
