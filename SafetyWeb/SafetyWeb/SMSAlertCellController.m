//
//  SMSAlertCellController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/29/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "SMSAlertCellController.h"
#import "SMSAlertViewController.h"

@implementation SMSAlertCellController
@synthesize childName;
@synthesize messagePhoneNumber;
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
    
    @autoreleasepool {
        
        // We know this is actually an SMSAlert, so just convert it over
        SMSAlert *smsAlert = (SMSAlert*)alert;
        
        ChildAccountRequest *childRequest = [[ChildAccountRequest alloc] init];
        childRequest.childId = smsAlert.childId;
        childRequest.user = [UserManager getCurrentUser];
        childRequest.responseBlock = ^(BOOL success, Child *aChild, NSError *error) {
            if (success) {
                [childName performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%@ %@", aChild.firstName, aChild.lastName] waitUntilDone:NO];
            } else {
                
            }
        };
        [childRequest performRequest];
        [childRequest release];
        
        messagePhoneNumber.text = smsAlert.messagePhoneNumber;
        timeMessage.text = [Utilities timeIntervalToHumanString:[smsAlert.timestamp timeIntervalSince1970]];
        
        if (row % 2 == 0) backgroundImage.image = [UIImage imageNamed:@"Alerts_Screen_ZebraStripe.png"];
        else backgroundImage.image = nil;
        
    }
}

- (void)viewDidUnload {
    self.childName = nil;
    self.messagePhoneNumber = nil;
    self.timeMessage = nil;
    self.backgroundImage = nil;
    
    [super viewDidUnload];
}

#pragma mark -
#pragma mark IBAction Methods
-(IBAction)detailPressed:(id)sender {
    SMSAlertViewController *viewAlert = [[SMSAlertViewController alloc] initWithNibName:@"SMSAlertViewController" bundle:nil];
    viewAlert.alert = (SMSAlert*)alert;
    [[[self.alertsViewController getMenuViewController] getRootViewController] displayGenericViewController:viewAlert];
    [viewAlert release];
}

-(void)dealloc {
    [childName release];
    [messagePhoneNumber release];
    [timeMessage release];
    [backgroundImage release];
    
    [super dealloc];
}

@end
