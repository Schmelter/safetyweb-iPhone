//
//  SafetyWebRequestTestCase.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <unistd.h>
#import "SafetyWebRequest.h"

@interface SafetyWebRequestTestCase : GHTestCase{
    @private
    BOOL loginComplete;
    NSError *loginCallbackError;
    NSCondition *condition;
}
@property (nonatomic) BOOL loginComplete;
@property (nonatomic, retain) NSError *loginCallbackError;
@property (nonatomic, readonly) NSCondition *condition;
@end

@interface LoginRequestCallback : NSObject <SafetyWebRequestCallback> {
    @private
    SafetyWebRequestTestCase *callback;
}
@property (nonatomic, assign) SafetyWebRequestTestCase *callback;
@end


@implementation SafetyWebRequestTestCase

@synthesize loginComplete;
@synthesize loginCallbackError;
@synthesize condition;

-(void)setUp {
    loginComplete = NO;
    loginCallbackError = nil;
    condition = [[NSCondition alloc] init];
}

-(void)testBase64Encode {
    NSString *encodeMeStr = @"Hello World!";
    const char *encodeMeBytes = [encodeMeStr cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *encodeMeDat = [NSData dataWithBytes:encodeMeBytes length:[encodeMeStr length]];
    
    NSString *encodedStr = [SafetyWebRequest Base64Encode:encodeMeDat];
    NSLog(@"Encoded String: %@", encodedStr);
    
    GHAssertEqualStrings(@"SGVsbG8gV29ybGQh", encodedStr, @"Checking if Test String encodes to Base64 properly", nil);
}

-(void)testBuildRequestUrl {
    // This is just to make sure that we're building the URLs correctly, not that the URL goes to the right location or anything
    // like that
    NSString *requestMethod = @"GET";
    NSURL *url = [NSURL URLWithString:@"https://www.safetyweb.com/api/v1/login"];
    NSString *formattedDate = @"2012-02-22T22:08:24.362Z";
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    
    [paramDict setObject:@"ashleysdad" forKey:@"username"];
    [paramDict setObject:@"abc123" forKey:@"password"];
    [paramDict setObject:@"json" forKey:@"type"];
    
    NSString *requestUrl = [SafetyWebRequest buildRequestURL:requestMethod andURL:url andParams:paramDict andDate:formattedDate];
    
    [paramDict release];
    
    GHAssertEqualStrings(requestUrl, @"https://www.safetyweb.com/api/v1/login?api_id=59a0466d76db208dd32aa70ed2ee370c&password=abc123&timestamp=2012-02-22T22%3A08%3A24.362Z&type=json&username=ashleysdad&signature=ETaStbY5gOahmPPSWm7PEMa7NEVzi5mkQs2ifQ0iMR8%3D", @"Checking if URLs built by SafetyWebRequest are formatted correctly");
}

-(void)testLoginRequest {
    // This tests actually logging into the website
    NSString *requestMethod = @"GET";
    NSURL *url = [NSURL URLWithString:@"https://www.safetyweb.com/api/v1/login"];
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    
    [paramDict setObject:@"ashleysdad" forKey:@"username"];
    [paramDict setObject:@"abc123" forKey:@"password"];
    [paramDict setObject:@"json" forKey:@"type"];
    
    SafetyWebRequest *request = [[SafetyWebRequest alloc] init];
    LoginRequestCallback *callback = [[LoginRequestCallback alloc] init];
    
    [request setCallback:callback];
    [request request:requestMethod andURL:url andParams:paramDict];
    
    [callback release];
    [request release];
    [paramDict release];
    
    [condition lock];
    [condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:100]];
    [condition unlock];
    
    GHAssertNil(loginCallbackError, @"Error received while logging in: %@", loginCallbackError);
    GHAssertTrue(loginComplete, @"No response from server when attempting to login"); // We never got any response within 10 seconds
}

-(void)tearDown {
    [loginCallbackError release];
    [condition release];
}

@end

@implementation LoginRequestCallback 
@synthesize callback;

-(void)gotResponse:(id)aResponse {
    // We're expecting an NSDictionary filled with login credentials
    if (aResponse == nil || ![aResponse isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *details = [[NSMutableDictionary alloc] initWithCapacity:1];
        [details setValue:@"Response was nil or not an NSDictionary" forKey:NSLocalizedDescriptionKey];
        NSError *error = [[NSError alloc] initWithDomain:@"world" code:200 userInfo:details];
        callback.loginCallbackError = error;
        [error release];
        [details release];
        
        [callback.condition lock];
        [callback.condition signal];
        [callback.condition unlock];
        
        return;
    }
    NSDictionary *responseDict = (NSDictionary*)aResponse;
    NSString *token = [responseDict objectForKey:@"token"];
    if (token == nil || ![token isKindOfClass:[NSString class]] || [token length] == 0) {
        NSMutableDictionary *details = [[NSMutableDictionary alloc] initWithCapacity:1];
        [details setValue:@"Token missing from response, or not a string" forKey:NSLocalizedDescriptionKey];
        NSError *error = [[NSError alloc] initWithDomain:@"world" code:200 userInfo:details];
        callback.loginCallbackError = error;
        [error release];
        [details release];
        
        [callback.condition lock];
        [callback.condition signal];
        [callback.condition unlock];
        
        return;
    }
    
    
    callback.loginComplete = YES;
    
    [callback.condition lock];
    [callback.condition signal];
    [callback.condition unlock];
}

-(void)notGotResponse:(NSError*)aError {
    // Request failed completely
    callback.loginCallbackError = aError;
    
    [callback.condition lock];
    [callback.condition signal];
    [callback.condition unlock];
}

@end
