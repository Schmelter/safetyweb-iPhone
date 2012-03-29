//
//  SMSAlert.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/29/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlertManager.h"

@interface SMSAlert : NSObject <Alert> {
    @private
    NSNumber *alertId;
    NSNumber *childId;
    NSString *messagePhoneNumber;
    NSTimeInterval timestamp;
}

@property (nonatomic, retain) NSNumber *alertId;
@property (nonatomic, retain) NSNumber *childId;
@property (nonatomic, retain) NSString *messagePhoneNumber;
@property (nonatomic) NSTimeInterval timestamp;

@end
