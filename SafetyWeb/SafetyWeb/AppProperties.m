//
//  AppProperties.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppProperties.h"

static NSString *appPropertiesFile = @"AppProperties.plist";
static NSDictionary *appProperties = nil;

@implementation AppProperties

// This is a purely static class, so keep an implementation from being made
-(id)init {
    if (self) {
        [self release];
    }
    return nil;
}

+(void)initialize {
    // Load the property list
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:appPropertiesFile];
    appProperties = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
}

+(id)getProperty:(NSString*)propName withDefault:(id)aDefault {
    id value = [appProperties objectForKey:propName];
    if (value == nil) return aDefault;
    return value;
}

-(void)dealloc {
    [super dealloc];
}

@end
