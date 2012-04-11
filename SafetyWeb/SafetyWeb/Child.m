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


@implementation Child

@dynamic childId;
@dynamic firstName;
@dynamic lastName;
@dynamic profilePicUrl;
@dynamic address;
@dynamic mobilePhone;
@dynamic lastQueried;
@dynamic accounts;
@dynamic user;

-(NSArray*)sortedAccounts {
    NSSet *unsortedAccounts = (NSSet*)[self primitiveValueForKey:@"accounts"];
    return [[unsortedAccounts allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:@"accountId"]];
}

@end
