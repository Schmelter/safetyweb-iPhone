//
//  BasicWebRequest.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/26/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicWebRequest : NSObject <NSURLConnectionDelegate> {
    @private
    NSMutableData *responseData;
    NSURL *url;
    void(^callback)(BOOL, NSData*, NSError*);
    
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, copy) void(^callback)(BOOL, NSData*, NSError*);

-(void)sendRequest;

#pragma mark -
#pragma mark NSURLConnection Delegates
- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)conn;
- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error;

@end
