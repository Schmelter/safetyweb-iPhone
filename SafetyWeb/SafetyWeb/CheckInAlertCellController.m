//
//  CheckInAlertCellController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/29/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "CheckInAlertCellController.h"

@implementation CheckInAlertCellController
@synthesize childName;
@synthesize locationStr;
@synthesize locationApproved;
@synthesize timeMessage;
@synthesize backgroundImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rowHeight = 70;
    }
    return self;
}

-(CGFloat)heightForRow {
    return rowHeight;
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    CheckInAlert *checkInAlert = (CheckInAlert*)alert;
    
    Child *child = [ChildManager getChildForId:checkInAlert.childId];
    childName.text = [NSString stringWithFormat:@"%@ %@", child.firstName, child.lastName];
    locationStr.text = checkInAlert.locationStr;
    locationApproved.text = checkInAlert.locationApproved ? @"Location Approved" : @"Location NOT Approved";
    timeMessage.text = [Utilities timeIntervalToHumanString:checkInAlert.timestamp];
    
    if (row % 2 == 0) backgroundImage.image = [UIImage imageNamed:@"dark_zebra_BG.png"];
    else backgroundImage.image = nil;
    
    [pool release];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)willSelect {
    rowHeight = 140;
    self.view.frame = CGRectMake(0, 0, 320, 140);
    backgroundImage.frame = CGRectMake(0, 0, 320, 140);
}

-(void)willDeselect {
    rowHeight = 70;
    self.view.frame = CGRectMake(0, 0, 320, 70);
    backgroundImage.frame = CGRectMake(0, 0, 320, 70);
}

-(void)dealloc {
    [childName release];
    [locationStr release];
    [locationApproved release];
    [timeMessage release];
    [backgroundImage release];
    
    [super dealloc];
}
@end
