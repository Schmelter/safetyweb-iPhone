//
//  AlertManager.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/28/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "AlertManager.h"
#import "SWAppDelegate.h"

// TODO: Take out these imports when we're actually hitting the server
#import "FacebookAlert.h"
#import "SMSAlert.h"
#import "CheckInAlert.h"
#import "ChildManager.h"

static NSMutableDictionary* alertDict;
static NSMutableArray* alertArr;

@interface ChildAlertResponse : NSObject <AllChildResponse>
@end

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
    
    ChildAlertResponse *childResponse = [[ChildAlertResponse alloc] init];
    AllChildRequest *allChildRequest = [[AllChildRequest alloc] init];
    allChildRequest.response = childResponse;
    [ChildManager requestAllChildren:allChildRequest];
    [allChildRequest release];
    
    [pool release];
}

+(void)responseAlertsWithinRange:(AlertRangeRequest*)request {
    @autoreleasepool {
        
    
        NSLog(@"Before Sleep");
        usleep(1000000);  // 1 seconds
        NSLog(@"After Sleep");
    
        NSRange range = request.range;
    
        range.location = range.location > [alertArr count] ? [alertArr count] : range.location;
        range.length = range.location + range.length > [alertArr count] ? [alertArr count] - range.location : range.length;
    
        [request.response receiveResponse:[alertArr subarrayWithRange:range] forRange:range];
        NSLog(@"Thread Over");
    }
}

+(void)requestAlertsWithinRange:(AlertRangeRequest*)request {
    // TODO: Take this out later when we're actually hitting the server
    // Check that the range is within the size of our array
    // NOTE: Make sure to retain the AlertRangeRequest when the request will be asynchronous
    [NSThread detachNewThreadSelector:@selector(responseAlertsWithinRange:) toTarget:[self class] withObject:request];
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


@implementation ChildAlertResponse
-(void)childrenRequestSuccess:(NSArray *)children {
    @autoreleasepool {
        
        NSInteger alertId = 1;
        NSDate *facebookTimestamp = [[NSDate alloc] initWithTimeIntervalSince1970:1330495200]; // 02/29/2012
        NSDate *smsTimestamp = [[NSDate alloc] initWithTimeIntervalSince1970:1332738000]; // 03/26/2012
        NSDate *checkInTimestamp = [[NSDate alloc] initWithTimeIntervalSince1970:1333061858]; // 03/29/2012 4:58 pm
        
        NSNumber *locationLat = [[NSNumber alloc] initWithDouble:39.75529012333774];
        NSNumber *locationLong = [[NSNumber alloc] initWithDouble:-104.99408483505249];
        NSNumber *locationApproved = [[NSNumber alloc] initWithInt:1];
        
        NSManagedObjectContext *context = ((SWAppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
        
        for (Child* child in children) {
            FacebookAlert *facebookAlert = [[FacebookAlert alloc] initWithEntity:[NSEntityDescription entityForName:@"FacebookAlert" inManagedObjectContext:context] insertIntoManagedObjectContext:context]; 
            facebookAlert.alertId = [NSNumber numberWithInt:alertId++];
            facebookAlert.childId = child.childId;
            facebookAlert.friendName = @"Johnny Jumper";
            facebookAlert.alertText = @"Who is 23 years older than her";
            facebookAlert.timestamp = facebookTimestamp;
            
            [alertArr addObject:facebookAlert];
            [alertDict setObject:facebookAlert forKey:facebookAlert.alertId];
            [FacebookAlert release];
            
            SMSAlert *smsAlert = [[SMSAlert alloc] initWithEntity:[NSEntityDescription entityForName:@"SMSAlert" inManagedObjectContext:context] insertIntoManagedObjectContext:context]; 
            smsAlert.alertId = [NSNumber numberWithInt:alertId++];
            smsAlert.childId = child.childId;
            smsAlert.messagePhoneNumber = @"720.982.6931";
            smsAlert.timestamp = smsTimestamp;
            
            [alertArr addObject:smsAlert];
            [alertDict setObject:smsAlert forKey:smsAlert.alertId];
            [smsAlert release];
            
            CheckInAlert *checkInAlert = [[CheckInAlert alloc] initWithEntity:[NSEntityDescription entityForName:@"CheckInAlert" inManagedObjectContext:context] insertIntoManagedObjectContext:context]; 
            checkInAlert.alertId = [NSNumber numberWithInt:alertId++];
            checkInAlert.childId = child.childId;
            checkInAlert.locationStr = @"Coors Field";
            checkInAlert.locationLat = locationLat;
            checkInAlert.locationLong = locationLong;
            checkInAlert.locationApproved = locationApproved;
            checkInAlert.timestamp = checkInTimestamp;
            
            [alertArr addObject:checkInAlert];
            [alertDict setObject:checkInAlert forKey:checkInAlert.alertId];
            [checkInAlert release];
        }
        [facebookTimestamp release];
        [smsTimestamp release];
        [checkInTimestamp release];
        
        [locationLat release];
        [locationLong release];
        [locationApproved release];
        
    }
    // We're done, so get rid of ourselves
    [self release];
}

-(void)requestFailure:(NSError*)error {
    [self release];
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
