//
//  Child.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/10/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account, User;

@interface Child : NSManagedObject

@property (nonatomic, retain) NSNumber * childId;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * profilePicUrl;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * mobilePhone;
@property (nonatomic, retain) NSDate * lastQueried;
@property (nonatomic, retain) NSSet *accounts;
@property (nonatomic, retain) User *user;
@end

@interface Child (CoreDataGeneratedAccessors)

- (void)addAccountsObject:(Account *)value;
- (void)removeAccountsObject:(Account *)value;
- (void)addAccounts:(NSSet *)values;
- (void)removeAccounts:(NSSet *)values;

- (NSArray*)sortedAccounts;

@end
