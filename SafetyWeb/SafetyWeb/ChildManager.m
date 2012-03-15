//
//  ChildManager.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 * Stores the children downloaded from the website.
 */

#import "ChildManager.h"

static NSMutableDictionary* childDict;
static NSMutableArray* childArr;

@implementation ChildManager

-(ChildManager*)init {
    // This is a purely static class
    [self release];
    return nil;
}

+(void)initialize {
    childDict = [[NSMutableDictionary alloc] init];
    childArr = [[NSMutableArray alloc] init];
}

+(void)clearAllChildren {
    [childDict removeAllObjects];
    [childArr removeAllObjects];
}

+(Child*)getChildForId:(NSNumber*)childId {
    return [childDict objectForKey:childId];
}

+(NSArray*)getAllChildren {
    return childArr;
}

+(void)parseChildrenResponse:(NSDictionary*)childrenJson {
    if (childrenJson == nil) {
        return;
    }
    NSDictionary *childrenDict = [childrenJson objectForKey:@"children"];
    if (childrenDict == nil) {
        return;
    }
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSObject *childObj = [childrenDict objectForKey:@"child"];
    if ([childObj isKindOfClass:[NSArray class]]) {
        // Multiple children
        for (NSDictionary *jsonChildDict in (NSArray*)childObj) {
            Child *child = [[Child alloc] init];
            
            child.childId = (NSNumber*)[jsonChildDict objectForKey:@"child_id"];
            child.firstName = (NSString*)[jsonChildDict objectForKey:@"first_name"];
            child.lastName = (NSString*)[jsonChildDict objectForKey:@"last_name"];
            child.profilePicUrl = [NSURL URLWithString:(NSString*)[jsonChildDict objectForKey:@"profile_pic"]];
            
            [childArr addObject:child];
            [childDict setObject:child forKey:child.childId];
            [child release];
        }
    } else if ([childObj isKindOfClass:[NSDictionary class]]) {
        // Only one child
        NSDictionary *jsonChildDict = (NSDictionary*)childObj;
        Child *child = [[Child alloc] init];
        
        child.childId = (NSNumber*)[jsonChildDict objectForKey:@"child_id"];
        child.firstName = (NSString*)[jsonChildDict objectForKey:@"first_name"];
        child.lastName = (NSString*)[jsonChildDict objectForKey:@"last_name"];
        child.profilePicUrl = [NSURL URLWithString:(NSString*)[jsonChildDict objectForKey:@"profile_pic"]];
        
        [childArr addObject:child];
        [childDict setObject:child forKey:child.childId];
        [child release];
    }
    
    [pool release];
}

+(void)parseChildResponse:(NSDictionary *)childJson {
    
}

-(void)dealloc {
    [super dealloc];
}

@end


@implementation Child
@synthesize childId;
@synthesize firstName;
@synthesize lastName;
@synthesize profilePicUrl;

-(Child*)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(void)dealloc {
    [childId release];
    [firstName release];
    [lastName release];
    [profilePicUrl release];
    
    [super dealloc];
}

@end
