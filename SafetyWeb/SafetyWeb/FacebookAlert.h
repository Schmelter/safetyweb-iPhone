//
//  FacebookAlert.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/28/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlertManager.h"

@interface FacebookAlert : NSObject <Alert> {
    @private
    NSNumber *alertId;
    NSNumber *childId;
    NSString *friendName;
    NSString *alertText;
    NSTimeInterval timestamp;
}

@property (nonatomic, retain) NSNumber *alertId;
@property (nonatomic, retain) NSNumber *childId;
@property (nonatomic, retain) NSString *friendName;
@property (nonatomic, retain) NSString *alertText;
@property (nonatomic) NSTimeInterval timestamp;

@end
