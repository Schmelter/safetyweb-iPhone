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

@protocol Alert <NSObject>

-(NSNumber*)alertId;
-(NSNumber*)childId;
-(void)parseJSON:(NSString*)jsonString;

@end


@protocol AlertRangeResponse <NSObject>
-(void)receiveResponse:(NSArray*)alerts forRange:(NSRange)range;
@end


@protocol AlertIdResponse <NSObject>
-(void)receiveResponse:(id<Alert>)alert;
@end


@interface AlertRangeRequest : NSObject {
@private
    NSRange range;
    id<AlertRangeResponse> response;
}
@property (nonatomic) NSRange range;
@property (nonatomic, assign) id<AlertRangeResponse> response;
@end

@interface AlertIdRequest : NSObject {
@private
    NSNumber *alertId;
    id<AlertIdResponse> response;
}
@property (nonatomic, retain) NSNumber *alertId;
@property (nonatomic, assign) id<AlertIdResponse> response;
@end


@interface AlertManager : NSObject

+(void)requestAlertsWithinRange:(AlertRangeRequest*)request;
+(void)requestAlertById:(AlertIdRequest*)request;

@end
