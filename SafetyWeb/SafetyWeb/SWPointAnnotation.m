//
//  SWPointAnnotation.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/5/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "SWPointAnnotation.h"

@implementation SWPointAnnotation
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

-(SWPointAnnotation*)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)dealloc {
    [title release];
    [subtitle release];
    
    [super dealloc];
}

@end
