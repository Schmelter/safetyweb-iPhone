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

typedef void (^AlertRangeResponseBlock)(BOOL, NSArray*, NSError*);
typedef void (^AlertIdResponseBlock)(BOOL, Alert*, NSError*);

@interface AlertRangeRequest : NSObject {
@private
    User *user;
    NSRange range_;
    AlertRangeResponseBlock responseBlock;
}
@property (nonatomic, retain) User *user;
@property (nonatomic) NSRange range;
@property (nonatomic, copy) AlertRangeResponseBlock responseBlock;

-(void)performRequest;
@end

@interface AlertIdRequest : NSObject {
@private
    User *user;
    NSNumber *alertId;
    AlertIdResponseBlock responseBlock;
}
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSNumber *alertId;
@property (nonatomic, copy) AlertIdResponseBlock responseBlock;

-(void)performRequest;
@end


@interface AlertManager : NSObject

+(void)generateFakeAlertsForUser:(User*)user;

@end
