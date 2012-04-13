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

@protocol ChildResponse <NSObject>
-(void)childRequestSuccess:(Child*)child;
-(void)requestFailure:(NSError*)error;
@end

@interface ChildAccountRequest : NSObject <SafetyWebRequestCallback> {
@private
    NSNumber *childId;
    User *user;
}

@property (nonatomic, retain) NSNumber *childId;
@property (nonatomic, retain) User *user;
@end

@interface ChildManager : NSObject {
    
}

+(Child*)initChildFromJson:(NSDictionary*)jsonChildDict;

+(void)requestChildAccount:(ChildAccountRequest*)request withResponse:(id<ChildResponse>)response;

@end
