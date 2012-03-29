//
//  FacebookAlertCellController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/28/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "FacebookAlertCellController.h"

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
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    FacebookAlert *fbAlert = (FacebookAlert*) alert;
    Child *child = [ChildManager getChildForId:[fbAlert childId]];
    childName.text = [NSString stringWithFormat:@"%@ %@", child.firstName, child.lastName];
    friendName.text = fbAlert.friendName;
    alertMessage.text = fbAlert.alertText;
    timeMessage.text = [Utilities timeIntervalToHumanString:fbAlert.timestamp];
    
    if (row % 2 == 0) backgroundImage.image = [UIImage imageNamed:@"dark_zebra_BG.png"];
    else backgroundImage.image = nil;
    
    [pool release];
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
