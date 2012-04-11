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


@implementation User

@dynamic login;
@dynamic password;
@dynamic tokenStart;
@dynamic children;
@dynamic alerts;


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

@end
