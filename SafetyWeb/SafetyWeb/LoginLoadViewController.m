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

@interface ChildrenCallback : AllChildRequest <AllChildResponse>
@property (nonatomic, retain) LoginLoadViewController* callback;
@end;

@interface ChildCallback : ChildAccountRequest <ChildResponse>
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
    [tokenRequest request:@"GET" andURL:[NSURL URLWithString:[AppProperties getProperty:@"Endpoint_Login" withDefault:@"No API Endpoint"]] andParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:credentials.login, credentials.password, @"json", nil] forKeys:[NSArray arrayWithObjects:@"username", @"password", @"type", nil]]];
    [tokenCallback release];
    [tokenRequest release];
    
    [pool release];
}

-(void)makeChildrenRequest {
    [ChildManager clearAllChildren];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    ChildrenCallback *childrenCallback = [[ChildrenCallback alloc] init];
    childrenCallback.response = childrenCallback;
    childrenCallback.callback = self;
    
    [ChildManager requestAllChildren:childrenCallback];
    [childrenCallback release];
    progressView.progressCurrent = 40.0f;
    
    [pool release];
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (credentials.token != nil) {
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
    self.credentials.token = aToken;
    // TODO: Is this the proper place to set the credentials?  We haven't fully logged them in, but we have verified their login info...
    [UserManager setLastUsedCredentials:self.credentials];
    progressView.progressCurrent = 30.f;
    [self makeChildrenRequest];
}

-(void)childrenRequestSuccess:(NSArray*)children {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // For each child, fire off a request to get more information about that child
    // All ChildCallbacks are the same, so we only need one
    totalChildRequests = [children count];
    totalChildRequests = totalChildRequests == 0 ? 1 : totalChildRequests;  // Just to guarantee we never divide by zero
    for (Child *child in children) {
        @synchronized(self) {
            pendingChildRequests++;
        }
        
        ChildCallback *childCallback = [[ChildCallback alloc] init];
        childCallback.response = childCallback;
        childCallback.callback = self;
        childCallback.childId = child.childId;
        [ChildManager requestChildAccount:childCallback];
        [childCallback release];
    }
    
    [pool release];
    progressView.progressCurrent = 50.0;
}

-(void)childRequestSuccess:(Child*)aChild {
    // We need to block until all pending requests are fulfilled...
    @synchronized(self) {
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

-(void)childrenRequestSuccess:(NSArray *)children {
    [self.callback childrenRequestSuccess:children];
}

-(void)requestFailure:(NSError*)error {
    [self.callback requestFailure:error];
}

-(void)dealloc {
    [callback release];
    
    [super dealloc];
}
@end

@implementation ChildCallback
@synthesize callback;

-(void)childRequestSuccess:(Child*)child {
    [self.callback childRequestSuccess:child];
}

-(void)requestFailure:(NSError*)error {
    [self.callback requestFailure:error];
}

-(void)dealloc {
    [callback release];
    
    [super dealloc];
}
@end


