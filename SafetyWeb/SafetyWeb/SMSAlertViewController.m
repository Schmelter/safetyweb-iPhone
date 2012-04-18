//
//  SMSAlertViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/17/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "SMSAlertViewController.h"
#import "Utilities.h"

@implementation SMSAlertViewController
@synthesize alert;
@synthesize childImage;
@synthesize childName;
@synthesize messagePhoneNumber;
@synthesize timeMessage;
@synthesize callChildBtn;
@synthesize messageChildBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // We know this is actually an SMSAlert, so just convert it over
    SMSAlert *smsAlert = (SMSAlert*)alert;
    
    ChildAccountRequest *childRequest = [[ChildAccountRequest alloc] init];
    childRequest.childId = smsAlert.childId;
    childRequest.user = [UserManager getCurrentUser];
    [ChildManager requestChildAccount:childRequest withResponse:self];
    [childRequest release];
    
    messagePhoneNumber.text = smsAlert.messagePhoneNumber;
    timeMessage.text = [Utilities timeIntervalToHumanString:[smsAlert.timestamp timeIntervalSince1970]];
    
    [pool release];
}

- (void)viewDidUnload {
    self.childImage = nil;
    self.childName = nil;
    self.messagePhoneNumber = nil;
    self.timeMessage = nil;
    self.callChildBtn = nil;
    self.messageChildBtn = nil;
    
    [super viewDidUnload];
}

#pragma mark -
#pragma mark ChildResponse Methods
-(void)childRequestSuccess:(Child *)child {
    [childName performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%@ %@", child.firstName, child.lastName] waitUntilDone:NO];
    
    ImageCacheManager *cacheManager = [[ImageCacheManager alloc] init];
    [cacheManager requestImage:self ForUrl:[child.profilePicUrl description]];
    [cacheManager release];
    
    [callChildBtn setTitle:[NSString stringWithFormat:@"Call %@", child.firstName] forState:UIControlStateNormal];
    [messageChildBtn setTitle:[NSString stringWithFormat:@"Message %@", child.firstName] forState:UIControlStateNormal];
}

-(void)requestFailure:(NSError *)error {
    
}

#pragma mark -
#pragma mark CachedImage Methods
-(void)setImage:(UIImage*)imageData {
    childImage.image = imageData;
}

-(BOOL)expires {
    return YES;
}

#pragma mark -
#pragma mark IBAction Methods
-(IBAction)ignoreThisAlertPressed:(id)sender {
    
}

-(IBAction)messageChildPressed:(id)sender {
    // Check for SMS capability
}

-(IBAction)callChildPressed:(id)sender {
    // Check for phone call capability
}

-(IBAction)contactPolicePressed:(id)sender {
    // Check for phone call capability
}

-(IBAction)backPressed:(id)sender {
    [rootViewController displayMenuViewController];
}

-(void)dealloc {
    [alert release];
    [childImage release];
    [childName release];
    [messagePhoneNumber release];
    [timeMessage release];
    [callChildBtn release];
    [messageChildBtn release];
    
    [super dealloc];
}

@end
