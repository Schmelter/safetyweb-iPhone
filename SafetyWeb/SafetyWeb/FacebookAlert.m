//
//  FacebookAlert.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/28/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "FacebookAlert.h"

@implementation FacebookAlert
@synthesize alertId;
@synthesize childId;
@synthesize friendName;
@synthesize alertText;
@synthesize timestamp;

-(FacebookAlert*)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -
#pragma mark Alert Methods
-(void)parseJSON:(NSString*)jsonString {
    
}

-(void)dealloc {
    [alertId release];
    [childId release];
    
    [super dealloc];
}

@end
