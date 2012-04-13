//
//  User.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/10/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "User.h"
#import "Alert.h"
#import "Child.h"
#import "AppProperties.h"

NSInteger childSort(id child1, id child2, void *context);
NSInteger alertSort(id alert1, id alert2, void *context);

@implementation User

@dynamic login;
@dynamic password;
@dynamic tokenStart;
@dynamic children;
@dynamic alerts;
@dynamic userLastRequested;

-(NSString*)token {
    NSString *token = (NSString*)[self primitiveValueForKey:@"token"];
    NSDate *tokenStart = (NSDate*)[self primitiveValueForKey:@"tokenStart"];
    if (token == nil || tokenStart == nil) {
        [self setPrimitiveValue:nil forKey:@"token"];
        [self setPrimitiveValue:nil forKey:@"tokenStart"];
        [self willAccessValueForKey:@"token"];
        token = [self primitiveValueForKey:@"token"];
        [self didAccessValueForKey:@"token"];
        return token;
    }
    
    NSDate *now = [[NSDate alloc] init];
    NSInteger tokenValidTime= [(NSNumber*)[AppProperties getProperty:@"API_TokenExpire" withDefault:nil] intValue];
    if ([now timeIntervalSince1970] - [tokenStart timeIntervalSince1970] > tokenValidTime) {
        [self setPrimitiveValue:nil forKey:@"token"];
        [self setPrimitiveValue:nil forKey:@"tokenStart"];
    }
    [now release];
    
    [self willAccessValueForKey:@"token"];
    token = [self primitiveValueForKey:@"token"];
    [self didAccessValueForKey:@"token"];
    return token;
}

-(void)setToken:(NSString *)aToken {
    if (aToken == nil) {
        [self setPrimitiveValue:nil forKey:@"tokenStart"];
        [self willChangeValueForKey:@"token"];
        [self setPrimitiveValue:nil forKey:@"token"];
        [self didChangeValueForKey:@"token"];
    } else {
        NSDate *newDate = [[NSDate alloc] init];
        [self setPrimitiveValue:newDate forKey:@"tokenStart"];
        [newDate release];
        [self willChangeValueForKey:@"token"];
        [self setPrimitiveValue:aToken forKey:@"token"];
        [self didChangeValueForKey:@"token"];
    }
}

-(Child*)getChildForId:(NSNumber*)childId {
    // TODO: Figure out a better way than just going through the entire NSSet
    for (Child *child in [self children]) {
        if ([child.childId isEqualToNumber:childId]) return child;
    }
    return nil;
}

-(Alert*)getAlertForId:(NSNumber*)alertId {
    // TODO: Figure out a better way than just going through the entire NSSet
    for (Alert *alert in [self alerts]) {
        if ([alert.alertId isEqualToNumber:alertId]) return alert;
    }
    return nil;
}

NSInteger childSort(id child1, id child2, void *context) {
    return [[(Child*)child1 childId] compare:[(Child*)child2 childId]];
}

-(NSArray*)sortedChildren {
    NSSet *unsortedChildren = (NSSet*)[self primitiveValueForKey:@"children"];
    return [[unsortedChildren allObjects] sortedArrayUsingSelector:@selector(childId)];
}

NSInteger alertSort(id alert1, id alert2, void *context) {
    return -[[(Alert*)alert1 alertId] compare:[(Alert*)alert2 alertId]]; // Note the negative makes it a reverse sort
}

-(NSArray*)sortedAlerts {
    NSSet *unsortedAlerts = (NSSet*)[self primitiveValueForKey:@"alerts"];
    return [[unsortedAlerts allObjects] sortedArrayUsingFunction:alertSort context:nil];
}

@end
