//
//  CheckInAlert.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/29/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "CheckInAlert.h"

@implementation CheckInAlert
@synthesize alertId;
@synthesize childId;
@synthesize locationStr;
@synthesize location;
@synthesize locationApproved;
@synthesize timestamp;

-(CheckInAlert*)init {
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
    [locationStr release];
    
    [super dealloc];
}

@end
