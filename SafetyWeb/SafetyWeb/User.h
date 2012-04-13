//
//  User.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/10/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Alert, Child;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSDate * tokenStart;
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) NSSet *alerts;
@property (nonatomic, retain) NSDate * userLastRequested;

-(Child*)getChildForId:(NSNumber*)childId;
-(Alert*)getAlertForId:(NSNumber*)alertId;
-(NSArray*)sortedChildren;
-(NSArray*)sortedAlerts;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(Child *)value;
- (void)removeChildrenObject:(Child *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

- (void)addAlertsObject:(Alert *)value;
- (void)removeAlertsObject:(Alert *)value;
- (void)addAlerts:(NSSet *)values;
- (void)removeAlerts:(NSSet *)values;

@end
