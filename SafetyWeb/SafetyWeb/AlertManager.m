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

@interface AlertRangeRequest () {
    @private
    id<AlertRangeResponse> response;
}
@property (nonatomic, retain) id<AlertRangeResponse> response;
@end

@interface AlertIdRequest () {
    @private
    id<AlertIdResponse> response;
}
@property (nonatomic, retain) id<AlertIdResponse> response;
@end

@implementation AlertRangeRequest
@synthesize user;
@synthesize range = range_;
@synthesize response;

-(void)performRequest {
    @autoreleasepool {
        
        usleep(1000000);  // 1 seconds
        
        NSRange range = self.range;
        
        NSArray *alertArr = [user sortedAlerts];
        
        range.location = range.location > [alertArr count] ? [alertArr count] : range.location;
        range.length = range.location + range.length > [alertArr count] ? [alertArr count] - range.location : range.length;
        
        [self.response receiveResponse:[alertArr subarrayWithRange:range] forRange:range];
    }
    
    self.response = nil;
}

-(void)dealloc {
    [user release];
    [response release];
    
    [super dealloc];
}
@end


@implementation AlertIdRequest
@synthesize user;
@synthesize alertId;
@synthesize response;

-(void)performRequest {
    [self.response receiveResponse:[user getAlertForId:self.alertId]];
    
    self.response = nil;
}

-(void)dealloc {
    [user release];
    [alertId release];
    [response release];
    
    [super dealloc];
}

@end

// TODO: Take this out later when we're actually hitting the server
@interface UserAlertResponse : NSObject <UserResponse>
@end

@implementation AlertManager

-(AlertManager*)init {
    // This is a purely static class
    [self release];
    return nil;
}

+(void)initialize {
    // TODO: Take this out later when we're actually hitting the server
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    UserAlertResponse *userResponse = [[UserAlertResponse alloc] init];
    UserRequest *userRequest = [[UserRequest alloc] init];
    userRequest.token = [UserManager getLastUsedToken];
    [UserManager requestUser:userRequest withResponse:userResponse];
    [userRequest release];
    [userResponse release];
    NSLog(@"UserResponse Retain Count: %i", [userResponse retainCount]);
    
    [pool release];
}

+(void)requestAlertsWithinRange:(AlertRangeRequest*)request withResponse:(id<AlertRangeResponse>)response {
    // TODO: Take this out later when we're actually hitting the server
    // Check that the range is within the size of our array
    // NOTE: Make sure to retain the AlertRangeRequest when the request will be asynchronous
    request.response = response;
    [request performSelectorInBackground:@selector(performRequest) withObject:nil];
}

+(void)requestAlertById:(AlertIdRequest*)request withResponse:(id<AlertIdResponse>)response {
    // TODO: Alter this when we're actually hitting the server
    // NOTE: Make sure to retain the AlertIdRequest when the request will be asynchronous
    request.response = response;
    [request performSelectorInBackground:@selector(performRequest) withObject:nil];
}

-(void)dealloc {    
    [super dealloc];
}

@end


@implementation UserAlertResponse
-(void)userRequestSuccess:(User *)user {
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

-(void)requestFailure:(NSError*)error {
    
}
@end
