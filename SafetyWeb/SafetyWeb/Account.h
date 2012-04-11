//
//  Account.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/10/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

enum AccountStatus {
    acct_public = 0,
    acct_private = 1,
    acct_other = 2
};

@class Child;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSNumber * accountId;
@property (nonatomic, retain) NSNumber * serviceId;
@property (nonatomic, retain) NSString * profilePicUrl;
@property (nonatomic, retain) NSString * serviceName;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) Child *child;

@end
