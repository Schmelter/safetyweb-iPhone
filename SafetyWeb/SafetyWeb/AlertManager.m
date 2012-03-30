//
//  AlertManager.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/28/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "AlertManager.h"

// TODO: Take out these imports when we're actually hitting the server
#import "FacebookAlert.h"
#import "SMSAlert.h"
#import "CheckInAlert.h"
#import "ChildManager.h"

static NSMutableDictionary* alertDict;
static NSMutableArray* alertArr;

@implementation AlertManager

-(AlertManager*)init {
    // This is a purely static class
    [self release];
    return nil;
}

+(void)initialize {
    alertDict = [[NSMutableDictionary alloc] init];
    alertArr = [[NSMutableArray alloc] init];
    
    // TODO: Take this out later when we're actually hitting the server
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSInteger alertId = 1;
    for (Child* child in [ChildManager getAllChildren]) {
        FacebookAlert *facebookAlert = [[FacebookAlert alloc] init];
        facebookAlert.alertId = [NSNumber numberWithInt:alertId++];
        facebookAlert.childId = child.childId;
        facebookAlert.friendName = @"Johnny Jumper";
        facebookAlert.alertText = @"Who is 23 years older than her";
        facebookAlert.timestamp = 1330495200; // 02/29/2012
        
        [alertArr addObject:facebookAlert];
        [alertDict setObject:facebookAlert forKey:facebookAlert.alertId];
        [FacebookAlert release];
        
        SMSAlert *smsAlert = [[SMSAlert alloc] init];
        smsAlert.alertId = [NSNumber numberWithInt:alertId++];
        smsAlert.childId = child.childId;
        smsAlert.messagePhoneNumber = @"720.982.6931";
        smsAlert.timestamp = 1332738000; // 03/26/2012
        
        [alertArr addObject:smsAlert];
        [alertDict setObject:smsAlert forKey:smsAlert.alertId];
        [smsAlert release];
        
        CheckInAlert *checkInAlert = [[CheckInAlert alloc] init];
        checkInAlert.alertId = [NSNumber numberWithInt:alertId++];
        checkInAlert.childId = child.childId;
        checkInAlert.locationStr = @"Coors Field";
        checkInAlert.location = CLLocationCoordinate2DMake(39.75529012333774, -104.99408483505249);
        checkInAlert.locationApproved = YES;
        checkInAlert.timestamp = 1333061858; // 03/29/2012 4:58 pm
        
        [alertArr addObject:checkInAlert];
        [alertDict setObject:checkInAlert forKey:checkInAlert.alertId];
        [checkInAlert release];
    }
    
    [pool release];
}

+(NSArray*)getAllAlerts {
    return alertArr;
}

+(void)requestAlertsWithinRange:(AlertRangeRequest*)request {
    // TODO: Take this out later when we're actually hitting the server
    // Check that the range is within the size of our array
    // NOTE: Make sure to retain the AlertRangeRequest when the request will be asynchronous
    NSRange range = request.range;
    
    range.location = range.location > [alertArr count] ? [alertArr count] : range.location;
    range.length = range.location + range.length > [alertArr count] ? [alertArr count] - range.location : range.length;
    
    [request.response receiveResponse:[alertArr subarrayWithRange:range] forRange:range];
}

+(void)requestAlertById:(AlertIdRequest*)request {
    // TODO: Alter this when we're actually hitting the server
    // NOTE: Make sure to retain the AlertIdRequest when the request will be asynchronous
    [request.response receiveResponse:[alertDict objectForKey:request.alertId]];
}

-(void)dealloc {    
    [super dealloc];
}

@end


@implementation AlertRangeRequest
@synthesize range;
@synthesize response;

-(void)dealloc {    
    [super dealloc];
}
@end


@implementation AlertIdRequest
@synthesize alertId;
@synthesize response;

-(void)dealloc {
    [alertId release];
    
    [super dealloc];
}

@end
