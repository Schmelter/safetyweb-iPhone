//
//  FacebookAlertViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/17/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "FacebookAlertViewController.h"

@implementation FacebookAlertViewController
@synthesize alert;
@synthesize childImage;
@synthesize childName;
@synthesize friendName;
@synthesize alertMessage;
@synthesize timeMessage;
@synthesize callChildBtn;
@synthesize messageChildBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // We know the Alert is actually a FacebookAlert, so let's switch it over
    @autoreleasepool {
        
        FacebookAlert *fbAlert = (FacebookAlert*) alert;
        
        ChildAccountRequest *childRequest = [[ChildAccountRequest alloc] init];
        childRequest.childId = fbAlert.childId;
        childRequest.user = [UserManager getCurrentUser];
        childRequest.responseBlock = ^(BOOL success, Child *aChild, NSError *error) {
            if (success) {
                [childName performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%@ %@", aChild.firstName, aChild.lastName] waitUntilDone:NO];
                
                ImageCacheManager *cacheManager = [[ImageCacheManager alloc] init];
                [cacheManager requestImage:self ForUrl:[aChild.profilePicUrl description]];
                [cacheManager release];
                
                [callChildBtn setTitle:[NSString stringWithFormat:@"Call %@", aChild.firstName] forState:UIControlStateNormal];
                [messageChildBtn setTitle:[NSString stringWithFormat:@"Message %@", aChild.firstName] forState:UIControlStateNormal];
            } else {
                
            }
        };
        [childRequest performRequest];
        [childRequest release];
        friendName.text = fbAlert.friendName;
        alertMessage.text = fbAlert.alertText;
        timeMessage.text = [Utilities timeIntervalToHumanString:[fbAlert.timestamp timeIntervalSince1970]];
        
    }
}

- (void)viewDidUnload {
    self.childImage = nil;
    self.childName = nil;
    self.friendName = nil;
    self.alertMessage = nil;
    self.timeMessage = nil;
    self.callChildBtn = nil;
    self.messageChildBtn = nil;
    
    [super viewDidUnload];
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

#pragma mark -
#pragma mark CachedImage Methods
-(void)setImage:(UIImage*)imageData {
    childImage.image = imageData;
}

-(BOOL)expires {
    return YES;
}

-(void)dealloc {
    [alert release];
    [childImage release];
    [childName release];
    [friendName release];
    [alertMessage release];
    [timeMessage release];
    [callChildBtn release];
    [messageChildBtn release];
    
    [super dealloc];
}

@end
