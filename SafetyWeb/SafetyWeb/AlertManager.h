//
//  AlertManager.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/28/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

/**
 * Manages retrieving Alerts from the server for the current user.  There are many different
 * types of Alerts.  We build the type of alert from the given JSON.
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Alert.h"

@protocol AlertRangeResponse <NSObject>
-(void)receiveResponse:(NSArray*)alerts forRange:(NSRange)range;
@end


@protocol AlertIdResponse <NSObject>
-(void)receiveResponse:(Alert*)alert;
@end


@interface AlertRangeRequest : NSObject {
@private
    NSRange range_;
}
@property (nonatomic) NSRange range;
@end

@interface AlertIdRequest : NSObject {
@private
    NSNumber *alertId;
}
@property (nonatomic, retain) NSNumber *alertId;
@end


@interface AlertManager : NSObject

+(void)requestAlertsWithinRange:(AlertRangeRequest*)request withResponse:(id<AlertRangeResponse>)response;
+(void)requestAlertById:(AlertIdRequest*)request withResponse:(id<AlertIdResponse>)response;

@end
