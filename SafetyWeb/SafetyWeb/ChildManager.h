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
    id<AllChildResponse> response;
}
@property (nonatomic, assign) id<AllChildResponse> response;
@end

@interface ChildIdRequest : NSObject <SafetyWebRequestCallback> {
@private
    NSNumber *childId;
    id<ChildResponse> response;
}

@property (nonatomic, retain) NSNumber *childId;
@property (nonatomic, assign) id<ChildResponse> response;
@end

@interface ChildAccountRequest : NSObject <SafetyWebRequestCallback> {
@private
    NSNumber *childId;
    id<ChildResponse> response;
}

@property (nonatomic, retain) NSNumber *childId;
@property (nonatomic, assign) id<ChildResponse> response;
@end

@interface ChildManager : NSObject {
    
}

+(void)clearAllChildren;

+(void)requestAllChildren:(AllChildRequest*)request;
+(void)requestChildForId:(ChildIdRequest*)request;
+(void)requestChildAccount:(ChildAccountRequest*)request;

@end
