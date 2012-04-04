//
//  SMSAlertCellController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/29/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "SMSAlertCellController.h"

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
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // We know this is actually an SMSAlert, so just convert it over
    SMSAlert *smsAlert = (SMSAlert*)alert;
    Child *child = [ChildManager getChildForId:smsAlert.childId];
    childName.text = [NSString stringWithFormat:@"%@ %@", child.firstName, child.lastName];
    messagePhoneNumber.text = smsAlert.messagePhoneNumber;
    timeMessage.text = [Utilities timeIntervalToHumanString:smsAlert.timestamp];
    
    if (row % 2 == 0) backgroundImage.image = [UIImage imageNamed:@"dark_zebra_BG.png"];
    else backgroundImage.image = nil;
    
    [pool release];
}

- (void)viewDidUnload {
    self.childName = nil;
    self.messagePhoneNumber = nil;
    self.timeMessage = nil;
    self.backgroundImage = nil;
    
    [super viewDidUnload];
}

-(void)dealloc {
    [childName release];
    [messagePhoneNumber release];
    [timeMessage release];
    [backgroundImage release];
    
    [super dealloc];
}

@end