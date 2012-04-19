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

@implementation AlertRangeRequest
@synthesize user;
@synthesize range = range_;
@synthesize responseBlock;

-(void)performRequest {
    void(^block)() = [^{
        @autoreleasepool {
            if (user.alerts == nil || [user.alerts count] == 0) {
                usleep(1000000); // 1 seconds
                // TODO: Get this working with the server, and get the timeout for alerts working.
                // For now, just check if they don't have any alerts, and give them some
                [AlertManager generateFakeAlertsForUser:user];
            }
            
            NSArray *alertArr = [user sortedAlerts];
            
            range_.location = range_.location > [alertArr count] ? [alertArr count] : range_.location;
            range_.length = range_.location + range_.length > [alertArr count] ? [alertArr count] - range_.location : range_.length;
            
            responseBlock(YES, [alertArr subarrayWithRange:range_], nil);
        }
        self.responseBlock = nil;
    } copy];
    dispatch_async([SWAppDelegate dataModelQ], block);
    
    [block release];
}

-(void)dealloc {
    [user release];
    [responseBlock release];
    
    [super dealloc];
}
@end


@implementation AlertIdRequest
@synthesize user;
@synthesize alertId;
@synthesize responseBlock;

-(void)performRequest {
    void(^block)(void) = [^{
        if (user.alerts == nil || [user.alerts count] == 0) {
            usleep(1000000); // 1 seconds
            // TODO: Get this working with the server, and get the timeout for alerts working.
            // For now, just check if they don't have any alerts, and give them some
            [AlertManager generateFakeAlertsForUser:user];
        }
        
        responseBlock(YES, [user getAlertForId:alertId], nil);
        self.responseBlock = nil;
    } copy];
    dispatch_async([SWAppDelegate dataModelQ], block);
    
    [block release];
}

-(void)dealloc {
    [user release];
    [alertId release];
    [responseBlock release];
    
    [super dealloc];
}

@end


@implementation AlertManager

-(AlertManager*)init {
    // This is a purely static class
    [self release];
    return nil;
}

+(void)generateFakeAlertsForUser:(User*)user {
    @autoreleasepool {
        
        NSInteger alertId = 1;
        NSDate *facebookTimestamp = [[NSDate alloc] initWithTimeIntervalSince1970:1330495200]; // 02/29/2012
        NSDate *smsTimestamp = [[NSDate alloc] initWithTimeIntervalSince1970:1332738000]; // 03/26/2012
        NSDate *checkInTimestamp = [[NSDate alloc] initWithTimeIntervalSince1970:1333061858]; // 03/29/2012 4:58 pm
        
        NSNumber *locationLat = [[NSNumber alloc] initWithDouble:39.75529012333774];
        NSNumber *locationLong = [[NSNumber alloc] initWithDouble:-104.99408483505249];
        NSNumber *locationApproved = [[NSNumber alloc] initWithInt:1];
        
        NSManagedObjectContext *context = ((SWAppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
        
        for (Child* child in user.children) {
            FacebookAlert *facebookAlert = [[FacebookAlert alloc] initWithEntity:[NSEntityDescription entityForName:@"FacebookAlert" inManagedObjectContext:context] insertIntoManagedObjectContext:context]; 
            facebookAlert.alertId = [NSNumber numberWithInt:alertId++];
            facebookAlert.childId = child.childId;
            facebookAlert.friendName = @"Johnny Jumper";
            facebookAlert.alertText = @"Who is 23 years older than her";
            facebookAlert.timestamp = facebookTimestamp;
            facebookAlert.user = user;
            [user addAlertsObject:facebookAlert];
            
            [FacebookAlert release];
            
            SMSAlert *smsAlert = [[SMSAlert alloc] initWithEntity:[NSEntityDescription entityForName:@"SMSAlert" inManagedObjectContext:context] insertIntoManagedObjectContext:context]; 
            smsAlert.alertId = [NSNumber numberWithInt:alertId++];
            smsAlert.childId = child.childId;
            smsAlert.messagePhoneNumber = @"720.982.6931";
            smsAlert.timestamp = smsTimestamp;
            smsAlert.user = user;
            [user addAlertsObject:smsAlert];
            
            [smsAlert release];
            
            CheckInAlert *checkInAlert = [[CheckInAlert alloc] initWithEntity:[NSEntityDescription entityForName:@"CheckInAlert" inManagedObjectContext:context] insertIntoManagedObjectContext:context]; 
            checkInAlert.alertId = [NSNumber numberWithInt:alertId++];
            checkInAlert.childId = child.childId;
            checkInAlert.locationStr = @"Coors Field";
            checkInAlert.locationLat = locationLat;
            checkInAlert.locationLong = locationLong;
            checkInAlert.locationApproved = locationApproved;
            checkInAlert.timestamp = checkInTimestamp;
            checkInAlert.user = user;
            [user addAlertsObject:checkInAlert];
            
            [checkInAlert release];
        }
        [facebookTimestamp release];
        [smsTimestamp release];
        [checkInTimestamp release];
        
        [locationLat release];
        [locationLong release];
        [locationApproved release];
    }
}

-(void)dealloc {    
    [super dealloc];
}

@end
