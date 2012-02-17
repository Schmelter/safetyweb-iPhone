//
//  SafetyWebRequest.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SafetyWebRequest.h"
#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_4
#import <CommonCrypto/CommonHMAC.h>
#else
#import "CommonHMAC.h"
#endif

@implementation SafetyWebRequest

- (SafetyWebRequest*)init {
    self = [super init];
    responseData = [[NSMutableData alloc] init];
    return self;
}

- (void)dealloc {
    [requestMethod release];
    [paramDict release];
    [url release];
    [responseData release];
    
    [super dealloc];
}

- (NSString*)getFormattedTimestamp {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSString* formattedDate = [formatter stringFromDate:date];
    [formatter release];
    NSLog(@"Formatted Date: %@", formattedDate);
    return formattedDate;
}

// The call back should be a method with one parameter, an NSString
- (void)setCallback:(id<SafetyWebRequestCallback>)aCallback {
    callbackObj = aCallback;
}

- (void)request:(NSString *)aRequestMethod andURL:(NSURL *)aURL andParams:(NSDictionary *)aParamDict {
    [self retain]; // We need to retain ourselves while we're waiting for the response back from the server
    
    [aRequestMethod retain];
    [requestMethod release];
    requestMethod = aRequestMethod;
    
    [paramDict release];
    paramDict = [aParamDict mutableCopy];
    
    [aURL retain];
    [url release];
    url = aURL;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [paramDict setObject:[AppProperties getProperty:@"API_Id" withDefault:@"No API Id"] forKey:@"api_id"];
    [paramDict setObject:[self getFormattedTimestamp] forKey:@"timestamp"];
    
    // Now, sort the parameters, so that we can use them to build a key
    NSMutableArray *paramKeys = [NSMutableArray arrayWithArray:[paramDict allKeys]];
    
    // Build the parameters into a properly formatted string
	NSMutableString *paramStr = [[NSMutableString alloc] initWithCapacity:1024];
	BOOL isFirst = TRUE;
	NSEnumerator *paramEnum = [[paramKeys sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
	id paramKey = NULL;
	while (paramKey = [paramEnum nextObject]) {
		if (!isFirst) {
			[paramStr appendString:@"&"];
		}
		[paramStr appendString:paramKey];
		[paramStr appendString:@"="];
		NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																					   NULL,
																					   (CFStringRef)[paramDict objectForKey:paramKey],
																					   NULL,
																					   (CFStringRef)@" !*'();:@&=+$,/?%#[]",
																					   kCFStringEncodingUTF8 );
		//NSString* escapedUrlString = [[paramDict objectForKey:paramKey] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]; 
		[paramStr appendString:encodedString];
		[encodedString release];
		
		isFirst = FALSE;
	}
    
    // Create the key that we need to sign
	NSMutableString* toSign = [[NSMutableString alloc] initWithCapacity:1024];
	[toSign appendString:[requestMethod uppercaseString]];
	[toSign appendString:@"\n"];
	[toSign appendString:[url.host lowercaseString]];
    if (url.port != nil && [url.port intValue] != 0) {
        if (([url.scheme isEqualToString:@"http"] && [url.port intValue] != 80) || ([url.scheme isEqualToString:@"https"] && [url.port intValue] != 443)) {
            [toSign appendFormat:@":%i", [url.port intValue]];
        }
    }
	[toSign appendString:@"\n"];
    NSString* path = url.path;
    if (path == nil || [path length] == 0) path = @"/";
    [toSign appendString:path];
    [toSign appendString:@"\n"];
	[toSign appendString:paramStr];
    
    NSLog(@"To Sign: %@", toSign);
    
    // Turn it into a classic C String
	const char *cSecretKey  = [[AppProperties getProperty:@"API_Key" withDefault:@"No Secret Key"] cStringUsingEncoding:NSASCIIStringEncoding];
	const char *cToSign = [toSign cStringUsingEncoding:NSASCIIStringEncoding];
	[toSign release];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    // Hash it
	CCHmac(kCCHmacAlgSHA256, cSecretKey, strlen(cSecretKey), cToSign, strlen(cToSign), cHMAC);
	// Turn the byte array back into an NSData
	NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
										  length:sizeof(cHMAC)];
	// Turn the NSData into an NString with base64 encoding
	NSString *sig = [SafetyWebRequest Base64Encode:HMAC];
	[HMAC release];
    
    // Append the sig to the params, and build the full URL
    if (!isFirst) {
		[paramStr appendString:@"&"];
	}
	[paramStr appendString:@"signature"];
	[paramStr appendString:@"="];
	NSString* newSig = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                           NULL,
                                                                           (CFStringRef)sig,
                                                                           NULL,
                                                                           (CFStringRef)@" !*'();:@&=+$,/?%#[]",
                                                                           kCFStringEncodingUTF8 );
	[paramStr appendString:newSig];
	[newSig release];
    
    NSMutableString* fullURL = [[NSMutableString alloc] initWithCapacity:1024];
	[fullURL appendString:url.absoluteString];
	[fullURL appendString:@"?"];
	[fullURL appendString:paramStr];
	[paramStr release];
    NSLog(@"Full URL: %@", fullURL);
    
    // Now, we have the URL necessary, so let's call the service, and get the data
	NSURL *requestURL = [NSURL URLWithString:fullURL];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
	NSURLConnection *connection = [[NSURLConnection alloc]  initWithRequest:request delegate:self ] ;
    
	if (connection) {
        
        
        
	} else {
		NSLog(@"No connection");
	}
    
	[fullURL release];
    [pool release];
}

+(NSString *)Base64Encode:(NSData *)data{
	//Point to start of the data and set buffer sizes
	int inLength = [data length];
	int outLength = ((((inLength * 4)/3)/4)*4) + (((inLength * 4)/3)%4 ? 4 : 0);
	const char *inputBuffer = [data bytes];
	char *outputBuffer = malloc(outLength);
	outputBuffer[outLength] = 0;
	
	//64 digit code
	static char Encode[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	
	//start the count
	int cycle = 0;
	int inpos = 0;
	int outpos = 0;
	char temp = '\0';
	
	//Pad the last to bytes, the outbuffer must always be a multiple of 4
	outputBuffer[outLength-1] = '=';
	outputBuffer[outLength-2] = '=';
	
	/* http://en.wikipedia.org/wiki/Base64
	 Text content   M           a           n
	 ASCII          77          97          110
	 8 Bit pattern  01001101    01100001    01101110
	 
	 6 Bit pattern  010011  010110  000101  101110
	 Index          19      22      5       46
	 Base64-encoded T       W       F       u
	 */
	
	
	while (inpos < inLength){
		switch (cycle) {
			case 0:
				outputBuffer[outpos++] = Encode[(inputBuffer[inpos]&0xFC)>>2];
				cycle = 1;
				break;
			case 1:
				temp = (inputBuffer[inpos++]&0x03)<<4;
				outputBuffer[outpos] = Encode[temp];
				cycle = 2;
				break;
			case 2:
				outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xF0)>> 4];
				temp = (inputBuffer[inpos++]&0x0F)<<2;
				outputBuffer[outpos] = Encode[temp];
				cycle = 3;                  
				break;
			case 3:
				outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xC0)>>6];
				cycle = 4;
				break;
			case 4:
				outputBuffer[outpos++] = Encode[inputBuffer[inpos++]&0x3f];
				cycle = 0;
				break;                          
			default:
				cycle = 0;
				break;
		}
	}
	NSString *pictemp = [NSString stringWithUTF8String:outputBuffer];
	free(outputBuffer); 
	return pictemp;
}

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data 
{
	[responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    
	[conn release];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	if (callbackObj) 
		[callbackObj gotResponse:[responseData objectFromJSONData]];
    
    [pool release];
	[self release]; // Alright, our job is finally done
}

- (void)didFailWithError:(NSError*)error
{
    
	if (callbackObj) 
		[callbackObj notGotResponse:error];
	[self release]; // Alright, our job is finally done
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    
	[conn release];
	if (callbackObj) 
		[callbackObj notGotResponse:error];
	[self release]; // Alright, our job is finally done
}

@end
