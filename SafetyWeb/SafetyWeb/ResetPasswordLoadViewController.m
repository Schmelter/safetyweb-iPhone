//
//  ResetPasswordLoadViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResetPasswordLoadViewController.h"

@interface ResetPasswordCallback : NSObject <SafetyWebRequestCallback>
@property (nonatomic, assign) ResetPasswordLoadViewController* callback;
@end

@implementation ResetPasswordLoadViewController
@synthesize emailAddress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    @autoreleasepool {
        
        // Start the password reset request
        ResetPasswordCallback *rpCallback = [[ResetPasswordCallback alloc] init];
        rpCallback.callback = self;
        
        SafetyWebRequest *rpRequest = [[SafetyWebRequest alloc] init];
        [rpRequest request:@"GET" andURL:[NSURL URLWithString:[AppProperties getProperty:@"Endpoint_ForgotPassword" withDefault:@"No API Endpoint"]] andParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:emailAddress, @"json", nil] forKeys:[NSArray arrayWithObjects:@"email", @"type", nil]] withCallback:rpCallback];
        //    [tokenRequest request:@"GET" andURL:[NSURL URLWithString:[AppProperties getProperty:@"Endpoint_Login" withDefault:@"No API Endpoint"]] andParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:credentials.username, credentials.password, @"json", nil] forKeys:[NSArray arrayWithObjects:@"username", @"password", @"type", nil]]];
        [rpCallback release];
        [rpRequest release];
        
    }
}

-(void)requestFailure:(NSError*)aError {
    // If we have an error, then the server was unreachable
    // If there's no error, then the request failed, and we need to tell them so
    if (aError == nil) {
        UIAlertView *loginFailedAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Reset Failed"
                                         message:@"Please check your e-mail address and try again"
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
    [rootViewController displayResetPasswordViewController];
}

-(void)viewDidUnload {
    [super viewDidUnload];
}

-(void)dealloc {
    [emailAddress release];
    
    [super dealloc];
}

@end


@implementation ResetPasswordCallback
@synthesize callback;
-(void)gotResponse:(id)aResponse {
    NSLog(@"Child: %@", [aResponse description]);
}
-(void)notGotResponse:(NSError *)aError {
    [self.callback requestFailure:aError];
}
@end
