//
//  LoginManager.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserManager.h"

static User* credentials;

@interface TokenRequest () {
    @private
    id<TokenResponse> response;
}
@property (nonatomic, retain) id<TokenResponse> response;
@end

@implementation UserManager

- (UserManager*)init {
    // This is a purely static class
    [self release];
    return nil;
}

+(void)requestToken:(TokenRequest*)request withResponse:(id<TokenResponse>)response {
    request.response = response;
    [request performSelectorInBackground:@selector(performRequest) withObject:nil];
}

+ (User*)getLastUsedCredentials {
    // TODO: Implement getting these out of the file system or coredata
    return credentials;
}

+ (void)setLastUsedCredentials:(User*)aCredentials {
    // TODO: Store these in the file system or coredata
    [aCredentials retain];
    [credentials release];
    credentials = aCredentials;
}

- (void)dealloc {
    [super dealloc];
}

@end

@implementation TokenRequest
@synthesize login;
@synthesize password;
@synthesize response;

-(void)performRequest {
    @autoreleasepool {
        SafetyWebRequest *tokenRequest = [[SafetyWebRequest alloc] init];
        [tokenRequest request:@"GET" andURL:[NSURL URLWithString:[AppProperties getProperty:@"Endpoint_Login" withDefault:@"No API Endpoint"]] andParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:login, password, @"json", nil] forKeys:[NSArray arrayWithObjects:@"username", @"password", @"type", nil]] withCallback:self];
        
        [tokenRequest release];
    }
}

-(void)gotResponse:(id)aResponse {
    NSDictionary *responseDict = (NSDictionary*)aResponse;
    NSString* result = [responseDict objectForKey:@"result"];
    if ([result isEqualToString:@"OK"]) {
        [response tokenRequestSuccess:[responseDict objectForKey:@"token"]];
    } else {
        [response requestFailure:nil];
    }
    self.response = nil;
}
-(void)notGotResponse:(NSError *)aError {
    [response requestFailure:aError];
    self.response = nil;
}

-(void)dealloc {
    [login release];
    [password release];
    [response release];
    
    [super dealloc];
}

@end
