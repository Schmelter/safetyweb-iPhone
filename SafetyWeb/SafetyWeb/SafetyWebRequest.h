//
//  SafetyWebRequest.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 * Represents a request being made to the SafetyWeb REST services.
 */

#import <Foundation/Foundation.h>
#import "AppProperties.h"
#import "JSONKit.h"

/**
 * Any class that can respond to a SafetyWebRequest must extend this class for
 * callbacks.
 */

#import <Foundation/Foundation.h>

@protocol SafetyWebRequestCallback <NSObject>

-(void)gotResponse:(id)aResponse;
-(void)notGotResponse:(NSError*)aError;

@end

@interface SafetyWebRequest : NSObject <NSURLConnectionDelegate> {
    @private
    NSMutableData *responseData;
    id<SafetyWebRequestCallback> callbackObj;
    NSString *requestMethod;
    NSMutableDictionary *paramDict;
    NSURL *url;
}

- (void) setCallback:(id<SafetyWebRequestCallback>)aCallback;
- (void)request:(NSString *)aRequestMethod andURL:(NSURL *)aURL andParams:(NSDictionary *)aParamDict;
+(NSString *)Base64Encode:(NSData *)data;

#pragma mark -
#pragma mark NSURLConnection Delegates
- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)conn;
- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error;

@end
