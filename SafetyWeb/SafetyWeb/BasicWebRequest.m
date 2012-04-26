//
//  BasicWebRequest.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/26/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "BasicWebRequest.h"

@implementation BasicWebRequest
@synthesize url;
@synthesize callback;

-(BasicWebRequest*)init {
    self = [super init];
    if (self) {
        responseData = [[NSMutableData alloc] init];
    }
    return self;
}

-(void)sendRequest {
    [self retain];
    @autoreleasepool {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
        
        NSURLConnection *connection = [[NSURLConnection alloc]  initWithRequest:request delegate:self ] ;
        
        if (connection) {
            [connection start];
            CFRunLoopRun(); // Keep the thread from exiting before we get a response
        } else {
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:@"Failed to do something wicked" forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"SafetyWeb" code:200 userInfo:errorDetail];
            if (callback) callback(NO, nil, error);
            self.callback = nil;
            [connection release];
            [self release];
        }
    }
}

#pragma mark -
#pragma mark NSURLConnection Delegates
- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response {
    
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    
	[conn release];
    
    @autoreleasepool {
        if (callback) callback(YES, responseData, nil);
        self.callback = nil;
        [self release];
        CFRunLoopStop(CFRunLoopGetCurrent());
    }
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error {
    [conn release];
    if (callback) callback(NO, nil, error);
    self.callback = nil;
    [self release];
    CFRunLoopStop(CFRunLoopGetCurrent());
}

-(void)dealloc {
    [responseData release];
    [url release];
    [callback release];
    
    [super dealloc];
}

@end
