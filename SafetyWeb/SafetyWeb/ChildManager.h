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

typedef void(^ChildAccountResponseBlock)(BOOL, Child*, NSError*);

@interface ChildAccountRequest : NSObject <SafetyWebRequestCallback> {
@private
    NSNumber *childId;
    User *user;
    ChildAccountResponseBlock responseBlock;
}

@property (nonatomic, retain) NSNumber *childId;
@property (nonatomic, retain) User *user;
@property (nonatomic, copy) ChildAccountResponseBlock responseBlock;

-(void)performRequest;
@end

@interface ChildManager : NSObject {
    
}

+(Child*)initChildFromJson:(NSDictionary*)jsonChildDict;

@end
