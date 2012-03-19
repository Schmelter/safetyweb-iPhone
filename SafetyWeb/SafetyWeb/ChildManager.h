//
//  ChildManager.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

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
    NSMutableArray *accountArr;
    NSMutableDictionary *accountDict;
}

@property (nonatomic, retain) NSNumber *childId;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSURL *profilePicUrl;

-(void)addAccount:(Account*)account;

-(Account*)getAccountForId:(NSNumber*)accountId;

-(NSArray*)getAllAccounts;

@end


@interface ChildManager : NSObject {
    
}

+(void)clearAllChildren;

+(Child*)getChildForId:(NSNumber*)childId;

+(NSArray*)getAllChildren;

+(void)parseChildrenResponse:(NSDictionary*)childrenJson;

+(void)parseChildResponse:(NSDictionary*)childJson;

@end
