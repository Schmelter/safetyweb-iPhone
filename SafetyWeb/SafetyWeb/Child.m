//
//  Child.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/10/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "Child.h"
#import "Account.h"
#import "User.h"

NSInteger accountSort(id alert1, id alert2, void *context);

@implementation Child

@dynamic childId;
@dynamic firstName;
@dynamic lastName;
@dynamic profilePicUrl;
@dynamic location;
@dynamic address;
@dynamic mobilePhone;
@dynamic lastQueried;
@dynamic accounts;
@dynamic user;

NSInteger accountSort(id account1, id account2, void *context) {
    return [[(Account*)account1 accountId] compare:[(Account*)account2 accountId]];
}

-(NSArray*)sortedAccounts {
    NSSet *unsortedAccounts = (NSSet*)[self primitiveValueForKey:@"accounts"];
    return [[unsortedAccounts allObjects] sortedArrayUsingFunction:accountSort context:nil];
}

@end
