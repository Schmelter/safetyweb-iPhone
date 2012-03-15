//
//  ChildManager.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Child : NSObject {
    @private
    NSNumber *childId;
    NSString *firstName;
    NSString *lastName;
    NSURL *profilePicUrl;
}

@property (nonatomic, retain) NSNumber *childId;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSURL *profilePicUrl;

@end

@interface ChildManager : NSObject {
    
}

+(void)clearAllChildren;

+(Child*)getChildForId:(NSNumber*)childId;

+(NSArray*)getAllChildren;

+(void)parseChildrenResponse:(NSDictionary*)childrenJson;

+(void)parseChildResponse:(NSDictionary*)childJson;

@end
