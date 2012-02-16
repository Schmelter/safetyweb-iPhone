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

@interface SafetyWebRequest : NSObject <NSURLConnectionDelegate> {
    @private
    NSMutableData *responseData;
    SEL gotResponse;
    SEL notGotResponse;
    id callbackObj;
    NSString *requestMethod;
    NSMutableDictionary *paramDict;
    NSURL *url;
}

- (void) setCallback:(id)aCallback withGotResponse:(SEL)aGotResponse withNotGotResponse:(SEL)aNotGotResponse;
- (void)request:(NSString *)aRequestMethod andURL:(NSURL *)aURL andParams:(NSDictionary *)aParamDict;
+(NSString *)Base64Encode:(NSData *)data;

#pragma mark -
#pragma mark NSURLConnection Delegates
- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)conn;
- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error;

@end
