//
//  LoginLoadViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginLoadViewController.h"

@interface TokenCallback : NSObject <SafetyWebRequestCallback> 
@property (nonatomic, retain) LoginLoadViewController* callback;
@end

@interface ChildrenCallback : NSObject <SafetyWebRequestCallback>
@property (nonatomic, retain) LoginLoadViewController* callback;
@end;

@interface ChildCallback : NSObject <SafetyWebRequestCallback>
@property (nonatomic, retain) LoginLoadViewController* callback;
@end

@implementation LoginLoadViewController

@synthesize credentials;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        pendingChildRequests = 0;
        totalChildRequests = 0;
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
    [ChildManager clearAllChildren];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    ChildrenCallback *childrenCallback = [[ChildrenCallback alloc] init];
    childrenCallback.callback = self;
    
    SafetyWebRequest *childrenRequest = [[SafetyWebRequest alloc] init];
    [childrenRequest setCallbackObj:childrenCallback];
    [childrenRequest request:@"GET" andURL:[NSURL URLWithString:[AppProperties getProperty:@"Endpoint_Children" withDefault:@"No API Endpoint"]] andParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:credentials.userToken, @"json", nil] forKeys:[NSArray arrayWithObjects:@"token", @"type", nil]]];
    [childrenRequest release];
    [childrenCallback release];
    progressView.progressCurrent = 40.0f;
    
    [pool release];
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (credentials.userToken != nil) {
        // The token is valid and has not expired
        [self makeChildrenRequest];
        progressView.progressCurrent = 30.0f;
    } else {
        // The token does not exist, or is not valid, get a new one
        [self makeTokenRequest];
        progressView.progressCurrent = 10.0f;
    }
}

-(void)tokenRequestSuccess:(NSString*)aToken {
    self.credentials.userToken = aToken;
    progressView.progressCurrent = 30.f;
    [self makeChildrenRequest];
}

-(void)childrenRequestSuccess:(NSDictionary*)aChildren {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [ChildManager parseChildrenResponse:aChildren];
    
    // For each child, fire off a request to get more information about that child
    // All ChildCallbacks are the same, so we only need one
    ChildCallback *childCallback = [[ChildCallback alloc] init];
    childCallback.callback = self;
    totalChildRequests = [[ChildManager getAllChildren] count];
    totalChildRequests = totalChildRequests == 0 ? 1 : totalChildRequests;  // Just to guarantee we never divide by zero
    for (Child *child in [ChildManager getAllChildren]) {
        @synchronized(self) {
            pendingChildRequests++;
        }
        
        SafetyWebRequest *childRequest = [[SafetyWebRequest alloc] init];
        [childRequest setCallbackObj:childCallback];
        [childRequest request:@"GET" andURL:[NSURL URLWithString:[NSString stringWithFormat:[AppProperties getProperty:@"Endpoint_Child" withDefault:@"No API Endpoint"], child.childId]] andParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:credentials.userToken, @"json", @"id", nil] forKeys:[NSArray arrayWithObjects:@"token", @"type", child.childId, nil]]];
        [childRequest release];
    }
    [childCallback release];
    
    [pool release];
    progressView.progressCurrent = 50.0;
}

-(void)childRequestSuccess:(NSDictionary*)aChild {
    // We need to block until all pending requests are fulfilled...
    @synchronized(self) {
        [ChildManager parseChildResponse:aChild];
        pendingChildRequests--;
        
        progressView.progressCurrent = 50.0 + (50.0*((totalChildRequests - pendingChildRequests)/totalChildRequests));
        
        if (pendingChildRequests == 0) {
            // The login actually worked, and they got in just fine
            // Store the credentials, and show the main menu
            [UserManager setLastUsedCredentials:credentials];
            [rootViewController displayMenuViewController];
        }
    }
}

-(void)requestFailure:(NSError*)aError {
    // If we have an error, then the server was unreachable
    // If there's no error, then the login failed and we need to ask for a new login
    if (aError == nil) {
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
    //NSLog(@"Token: %@", [aResponse description]);
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
-(void)dealloc {
    [callback release];
    
    [super dealloc];
}
@end

@implementation ChildrenCallback
@synthesize callback;
-(void)gotResponse:(id)aResponse {
    //NSLog(@"Children: %@", [aResponse description]);
    NSDictionary *response = (NSDictionary*)aResponse;
    NSString *result = [response objectForKey:@"result"];
    if ([result isEqualToString:@"OK"]) {
        [self.callback childrenRequestSuccess:response];
    } else {
        [self.callback requestFailure:nil];
    }
}
-(void)notGotResponse:(NSError *)aError {
    [self.callback requestFailure:aError];
}
-(void)dealloc {
    [callback release];
    
    [super dealloc];
}
@end

@implementation ChildCallback
@synthesize callback;
-(void)gotResponse:(id)aResponse {
    //NSLog(@"Child: %@", [aResponse description]);
    NSDictionary *response = (NSDictionary*)aResponse;
    NSString *result = [response objectForKey:@"result"];
    if ([result isEqualToString:@"OK"]) {
        [self.callback childRequestSuccess:response];
    } else {
        [self.callback requestFailure:nil];
    }
}
-(void)notGotResponse:(NSError *)aError {
    [self.callback requestFailure:aError];
}
-(void)dealloc {
    [callback release];
    
    [super dealloc];
}
@end


