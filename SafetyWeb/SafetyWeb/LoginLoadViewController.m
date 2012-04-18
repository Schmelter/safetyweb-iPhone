//
//  LoginLoadViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginLoadViewController.h"

@interface UserCallback : UserRequest <UserResponse>
@property (nonatomic, retain) LoginLoadViewController* callback;
@end;

@interface ChildCallback : ChildAccountRequest <ChildResponse>
@property (nonatomic, retain) LoginLoadViewController* callback;
@end

@implementation LoginLoadViewController

@synthesize login;
@synthesize password;

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
    @autoreleasepool {
        
        /*TokenCallback *tokenCallback = [[TokenCallback alloc] init];
         tokenCallback.callback = self;
         tokenCallback.login = login;
         tokenCallback.password = password;
         
         [UserManager requestToken:tokenCallback withResponse:tokenCallback];
         [tokenCallback release];*/
        TokenRequest *tokenRequest = [[TokenRequest alloc] init];
        tokenRequest.login = login;
        tokenRequest.password = password;
        __block LoginLoadViewController *selff = self;
        tokenRequest.responseBlock = ^(BOOL success, NSString *aToken, NSError *aError) {
            if (success) {
                [selff tokenRequestSuccess:aToken];
            } else {
                [selff requestFailure:aError];
            }    
        };
        [tokenRequest performRequest];
        [tokenRequest release];
        
    }
}

-(void)makeUserRequest {
    @autoreleasepool {
        
        [UserManager setCurrentUser:nil];
        
        UserCallback *userCallback = [[UserCallback alloc] init];
        userCallback.callback = self;
        userCallback.token = token;
        
        [UserManager requestUser:userCallback withResponse:userCallback];
        [userCallback release];
        progressView.progressCurrent = 40.0f;
        
    }
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (token != nil) {
        // The token is valid and has not expired
        [self makeUserRequest];
        progressView.progressCurrent = 30.0f;
    } else {
        // The token does not exist, or is not valid, get a new one
        [self makeTokenRequest];
        progressView.progressCurrent = 10.0f;
    }
}

-(void)tokenRequestSuccess:(NSString*)aToken {
    [aToken retain];
    [token release];
    token = aToken;
    // TODO: Is this the proper place to set the credentials?  We haven't fully logged them in, but we have verified their login info...
    [UserManager setLastUsedLogin:self.login];
    [UserManager setLastUsedPassword:self.password];
    [UserManager setLastUsedToken:aToken];
    progressView.progressCurrent = 30.f;
    [self makeUserRequest];
}

-(void)userRequestSuccess:(User*)user {
    @autoreleasepool {
        
        [UserManager setCurrentUser:user];
        
        // For each child, fire off a request to get more information about that child
        // All ChildCallbacks are the same, so we only need one
        totalChildRequests = [[user children] count];
        totalChildRequests = totalChildRequests == 0 ? 1 : totalChildRequests;  // Just to guarantee we never divide by zero
        for (Child *child in [user children]) {
            @synchronized(self) {
                pendingChildRequests++;
            }
            
            ChildCallback *childCallback = [[ChildCallback alloc] init];
            childCallback.callback = self;
            childCallback.childId = child.childId;
            childCallback.user = user;
            [ChildManager requestChildAccount:childCallback withResponse:childCallback];
            [childCallback release];
        }
        
    }
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
    [login release];
    [password release];
    
    [super dealloc];
}

@end


@implementation UserCallback
@synthesize callback;

-(void)userRequestSuccess:(User*)user {
    [self.callback userRequestSuccess:user];
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


