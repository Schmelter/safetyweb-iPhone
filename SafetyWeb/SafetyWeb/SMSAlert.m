//
//  SMSAlert.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/29/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "SMSAlert.h"

@implementation SMSAlert
@synthesize alertId;
@synthesize childId;
@synthesize messagePhoneNumber;
@synthesize timestamp;

-(SMSAlert*)init {
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
    [messagePhoneNumber release];
    
    [super dealloc];
}
@end
