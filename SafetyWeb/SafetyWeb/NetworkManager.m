//
//  NetworkManager.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/27/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "NetworkManager.h"

static BOOL useCached;

@implementation NetworkManager

- (NetworkManager*)init {
    // This is a purely static class
    [self release];
    return nil;
}

-(void)initialize {
    useCached = NO;
}

+(void)setUseCached:(BOOL)aUseCached {
    useCached = aUseCached;
}

+(BOOL)getUseCached {
    return useCached;
}

-(void)dealloc {
    [super dealloc];
}

@end
