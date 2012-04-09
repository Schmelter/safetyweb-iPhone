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

#define kTwoHourTimeInterval    7200

enum AccountStatus {
    acct_public = 0,
    acct_private = 1,
    acct_other = 2
};

@interface Account : NSObject {
@private
    NSNumber *accountId;
    NSURL *profilePicUrl;
    NSNumber *serviceId;
    NSString *serviceName;
    enum AccountStatus status;
    NSURL *url;
    NSString *username;
}

@property (nonatomic, retain) NSNumber *accountId;
@property (nonatomic, retain) NSURL *profilePicUrl;
@property (nonatomic, retain) NSNumber *serviceId;
@property (nonatomic, retain) NSString *serviceName;
@property (nonatomic) enum AccountStatus status;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSString *username;

@end
           

@interface Child : NSObject {
    @private
    NSNumber *childId;
    NSString *firstName;
    NSString *lastName;
    NSURL *profilePicUrl;
    NSString *address;
    NSString *mobilePhone;
    NSMutableArray *accountArr;
    NSMutableDictionary *accountDict;
    
    NSDate *lastQueried;
}

@property (nonatomic, retain) NSNumber *childId;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSURL *profilePicUrl;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *mobilePhone;
@property (nonatomic, retain) NSDate *lastQueried;

-(void)addAccount:(Account*)account;

-(Account*)getAccountForId:(NSNumber*)accountId;

-(NSArray*)getAllAccounts;

@end


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
