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
        childRequest.responseBlock = ^(BOOL success, Child *aChild, NSError *error) {
            if (success) {
                [childName performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%@ %@", aChild.firstName, aChild.lastName] waitUntilDone:NO];
            } else {
                
            }
        };
        [childRequest performRequest];
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

-(void)dealloc {
    [childName release];
    [friendName release];
    [alertMessage release];
    [timeMessage release];
    [backgroundImage release];
    
    [super dealloc];
}

@end
