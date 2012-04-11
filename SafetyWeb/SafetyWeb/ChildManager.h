//
//  ChildManager.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SafetyWebRequest.h"
#import "AppProperties.h"
#import "UserManager.h"
#import "Account.h"
#import "Child.h"

#define kTwoHourTimeInterval    7200

@protocol AllChildResponse <NSObject>
-(void)childrenRequestSuccess:(NSArray*)children;
-(void)requestFailure:(NSError*)error;
@end


@protocol ChildResponse <NSObject>
-(void)childRequestSuccess:(Child*)child;
-(void)requestFailure:(NSError*)error;
@end


@interface AllChildRequest : NSObject <SafetyWebRequestCallback> {
@private
}
@end

@interface ChildIdRequest : NSObject <SafetyWebRequestCallback> {
@private
    NSNumber *childId;
}

@property (nonatomic, retain) NSNumber *childId;
@end

@interface ChildAccountRequest : NSObject <SafetyWebRequestCallback> {
@private
    NSNumber *childId;
}

@property (nonatomic, retain) NSNumber *childId;
@end

@interface ChildManager : NSObject {
    
}

+(void)clearAllChildren;

+(void)requestAllChildren:(AllChildRequest*)request withResponse:(id<AllChildResponse>)response;
+(void)requestChildForId:(ChildIdRequest*)request withResponse:(id<ChildResponse>)response;
+(void)requestChildAccount:(ChildAccountRequest*)request withResponse:(id<ChildResponse>)response;

@end
