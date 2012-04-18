//
//  FacebookAlertCellController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/28/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "FacebookAlertCellController.h"
#import "FacebookAlertViewController.h"

@implementation FacebookAlertCellController
@synthesize childName;
@synthesize friendName;
@synthesize alertMessage;
@synthesize timeMessage;
@synthesize backgroundImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(CGFloat)heightForRow {
    return 70;
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // We know the Alert is actually a FacebookAlert, so let's switch it over
    @autoreleasepool {
        
        FacebookAlert *fbAlert = (FacebookAlert*) alert;
        
        ChildAccountRequest *childRequest = [[ChildAccountRequest alloc] init];
        childRequest.childId = fbAlert.childId;
        childRequest.user = [UserManager getCurrentUser];
        [ChildManager requestChildAccount:childRequest withResponse:self];
        [childRequest release];
        friendName.text = fbAlert.friendName;
        alertMessage.text = fbAlert.alertText;
        timeMessage.text = [Utilities timeIntervalToHumanString:[fbAlert.timestamp timeIntervalSince1970]];
        
        if (row % 2 == 0) backgroundImage.image = [UIImage imageNamed:@"Alerts_Screen_ZebraStripe.png"];
        else backgroundImage.image = nil;
        
    }
}

- (void)viewDidUnload {
    self.childName = nil;
    self.friendName = nil;
    self.alertMessage = nil;
    self.timeMessage = nil;
    self.backgroundImage = nil;
    
    [super viewDidUnload];
}

#pragma mark -
#pragma mark IBAction Methods
-(IBAction)detailPressed:(id)sender {
    FacebookAlertViewController *viewAlert = [[FacebookAlertViewController alloc] initWithNibName:@"FacebookAlertViewController" bundle:nil];
    viewAlert.alert = (FacebookAlert*)alert;
    [[[self.alertsViewController getMenuViewController] getRootViewController] displayGenericViewController:viewAlert];
    [viewAlert release];
}

#pragma mark -
#pragma mark ChildResponse Methods
-(void)childRequestSuccess:(Child *)child {
    [childName performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%@ %@", child.firstName, child.lastName] waitUntilDone:NO];
}

-(void)requestFailure:(NSError *)error {
    
}

-(void)dealloc {
    [childName release];
    [friendName release];
    [alertMessage release];
    [timeMessage release];
    [backgroundImage release];
    
    [super dealloc];
}

@end
