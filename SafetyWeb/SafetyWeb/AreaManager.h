//
//  AreaManager.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/20/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SafetyWebRequest.h"
#import "AppProperties.h"
#import "SWArea.h"
#import "User.h"

typedef void(^AreasResponseBlock)(BOOL, NSArray*, NSError*);
typedef void(^AreaResponseBlock)(BOOL, SWArea*, NSError*);


@interface AreasForChildRequest : NSObject {
    @private
    User *user;
    NSNumber *childId;
    AreasResponseBlock responseBlock;
}
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSNumber *childId;
@property (nonatomic, copy) AreasResponseBlock responseBlock;
-(void)performRequest;
@end


@interface AreaForIdRequest : NSObject{
    @private
    User *user;
    NSNumber *areaId;
    AreaResponseBlock responseBlock;
}
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSNumber *areaId;
@property (nonatomic, copy) AreaResponseBlock responseBlock;
-(void)performRequest;
@end


@interface AreaManager : NSObject {
    
}

@end
