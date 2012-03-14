//
//  LoginLoadViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginLoadViewController.h"

@interface TokenCallback : NSObject <SafetyWebRequestCallback> 
@property (nonatomic, assign) LoginLoadViewController* callback;
@end

@interface ChildrenCallback : NSObject <SafetyWebRequestCallback>
@property (nonatomic, assign) LoginLoadViewController* callback;
@end;

@interface ChildCallback : NSObject <SafetyWebRequestCallback>
@property (nonatomic, assign) LoginLoadViewController* callback;
@end

@implementation LoginLoadViewController

@synthesize credentials;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)makeTokenRequest {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    TokenCallback *tokenCallback = [[TokenCallback alloc] init];
    tokenCallback.callback = self;
    
    SafetyWebRequest *tokenRequest = [[SafetyWebRequest alloc] init];
    [tokenRequest setCallbackObj:tokenCallback];
    [tokenRequest request:@"GET" andURL:[NSURL URLWithString:[AppProperties getProperty:@"Endpoint_Login" withDefault:@"No API Endpoint"]] andParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:credentials.username, credentials.password, @"json", nil] forKeys:[NSArray arrayWithObjects:@"username", @"password", @"type", nil]]];
    [tokenCallback release];
    [tokenRequest release];
    
    [pool release];
}

-(void)makeChildrenRequest {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    ChildrenCallback *childrenCallback = [[ChildrenCallback alloc] init];
    childrenCallback.callback = self;
    
    SafetyWebRequest *childrenRequest = [[SafetyWebRequest alloc] init];
    [childrenRequest setCallbackObj:childrenCallback];
    [childrenRequest request:@"GET" andURL:[NSURL URLWithString:[AppProperties getProperty:@"Endpoint_Children" withDefault:@"No API Endpoint"]] andParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:credentials.userToken, @"json", nil] forKeys:[NSArray arrayWithObjects:@"token", @"type", nil]]];
    [childrenRequest release];
    [childrenCallback release];
    progressView.progressCurrent = 60.0f;
    
    [pool release];
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (credentials.userToken != nil) {
        // The token is valid and has not expired
        [self makeChildrenRequest];
        progressView.progressCurrent = 40.0f;
    } else {
        // The token does not exist, or is not valid, get a new one
        [self makeTokenRequest];
        progressView.progressCurrent = 10.0f;
    }
}

-(void)tokenRequestSuccess:(NSString*)aToken {
    self.credentials.userToken = aToken;
    progressView.progressCurrent = 40.f;
    [self makeChildrenRequest];
}

-(void)childrenRequestSuccess:(NSDictionary*)aChildren {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Pull out the children in the array
    NSObject *childObj = [aChildren objectForKey:@"child"];
    
    // It's possible that the childObj is one child alone, or an array of multiple children.
    if ([childObj isKindOfClass:[NSDictionary class]]) {
        NSDictionary* child = (NSDictionary*)childObj;
        ChildCallback *childCallback = [[ChildCallback alloc] init];
        childCallback.callback = self;
        
        SafetyWebRequest *childRequest = [[SafetyWebRequest alloc] init];
        [childRequest setCallbackObj:childCallback];
        [childRequest request:@"GET" andURL:[NSURL URLWithString:[NSString stringWithFormat:[AppProperties getProperty:@"Endpoint_Child" withDefault:@"No API Endpoint"], [child objectForKey:@"child_id"]]] andParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:credentials.userToken, @"json", @"id", nil] forKeys:[NSArray arrayWithObjects:@"token", @"type", [child objectForKey:@"child_id"], nil]]];
        [childRequest release];
        [childCallback release];
    } else if ([childObj isKindOfClass:[NSArray class]]) {
        NSArray *childArr = (NSArray*)childObj;
        for (NSDictionary *child in childArr) {
            ChildCallback *childCallback = [[ChildCallback alloc] init];
            childCallback.callback = self;
            
            SafetyWebRequest *childRequest = [[SafetyWebRequest alloc] init];
            [childRequest setCallbackObj:childCallback];
            [childRequest request:@"GET" andURL:[NSURL URLWithString:[NSString stringWithFormat:[AppProperties getProperty:@"Endpoint_Child" withDefault:@"No API Endpoint"], [child objectForKey:@"child_id"]]] andParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:credentials.userToken, @"json", @"id", nil] forKeys:[NSArray arrayWithObjects:@"token", @"type", [child objectForKey:@"child_id"], nil]]];
            [childRequest release];
            [childCallback release];
        }
    }
    
    [pool release];
}

-(void)childRequestSuccess:(NSDictionary*)aChild {
    @synchronized(self) {
        
    }
}

-(void)requestFailure:(NSError*)aError {
    // If we have an error, then the server was unreachable
    // If there's no error, then the login failed and we need to ask for a new login
    if (aError != nil) {
        UIAlertView *loginFailedAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Login Failed"
                                     message:@"Please check your username and password and try again"
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        [loginFailedAlert show];
        [loginFailedAlert release];
    } else {
        UIAlertView *serverUnreachable = [[UIAlertView alloc]
                                     initWithTitle:@"Server Unreachable"
                                     message:@"The service is currently down.  Please try again later."
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        [serverUnreachable show];
        [serverUnreachable release];
    }
    [rootViewController displayLoginViewController];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc {
    [credentials release];
    
    [super dealloc];
}

@end


@implementation TokenCallback
@synthesize callback;
-(void)gotResponse:(id)aResponse {
    NSLog(@"Token: %@", [aResponse description]);
    NSDictionary *response = (NSDictionary*)aResponse;
    NSString* result = [response objectForKey:@"result"];
    if ([result isEqualToString:@"OK"]) {
        [self.callback tokenRequestSuccess:[response objectForKey:@"token"]];
    } else {
        [self.callback requestFailure:nil];
    }
}

-(void)notGotResponse:(NSError *)aError {
    [self.callback requestFailure:aError];
}
@end

@implementation ChildrenCallback
@synthesize callback;
-(void)gotResponse:(id)aResponse {
    NSLog(@"Children: %@", [aResponse description]);
    NSDictionary *response = (NSDictionary*)aResponse;
    NSString *result = [response objectForKey:@"result"];
    if ([result isEqualToString:@"OK"]) {
        [self.callback childrenRequestSuccess:[response objectForKey:@"children"]];
    } else {
        [self.callback requestFailure:nil];
    }
}
-(void)notGotResponse:(NSError *)aError {
    [self.callback requestFailure:aError];
}
@end

@implementation ChildCallback
@synthesize callback;
-(void)gotResponse:(id)aResponse {
    NSLog(@"Child: %@", [aResponse description]);
}
-(void)notGotResponse:(NSError *)aError {
    [self.callback requestFailure:aError];
}
@end


