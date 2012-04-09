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
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(CGFloat)expandedHeight {
    return 140;
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    CheckInAlert *checkInAlert = (CheckInAlert*)alert;
    
    ChildIdRequest *childIdRequest = [[ChildIdRequest alloc] init];
    childIdRequest.childId = checkInAlert.childId;
    childIdRequest.response = self;
    [ChildManager requestChildForId:childIdRequest];
    [childIdRequest release];
    
    locationStr.text = checkInAlert.locationStr;
    locationApproved.text = checkInAlert.locationApproved ? @"Location Approved" : @"Location NOT Approved";
    timeMessage.text = [Utilities timeIntervalToHumanString:checkInAlert.timestamp];
    
    if (row % 2 == 0) backgroundImage.image = [UIImage imageNamed:@"dark_zebra_BG.png"];
    else backgroundImage.image = nil;
    
    [pool release];
}

- (void)viewDidUnload {
    self.childName = nil;
    self.locationStr = nil;
    self.timeMessage = nil;
    self.backgroundImage = nil;
    self.mapView = nil;
    
    [super viewDidUnload];
}

-(void)expand {
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 320, 140);
    backgroundImage.frame = CGRectMake(backgroundImage.frame.origin.x, backgroundImage.frame.origin.y, 320, 140);
    
    CheckInAlert *checkInAlert = (CheckInAlert*)alert;
    // Add the mapView
    self.mapView = [[BMMapView alloc] initWithFrame:CGRectMake(10, 75, 300, 60)];
    [mapView setDelegate:self];
    mapView.scrollEnabled = NO;
    mapView.zoomEnabled = NO;
    [mapView setCenterCoordinate:checkInAlert.location animated:NO];
    [mapView setRegion:BMCoordinateRegionMake(checkInAlert.location, BMCoordinateSpanMake(.005, .0025)) animated:NO];
    BMEntity *childEntity = [[BMEntity alloc] initWithCoordinate:checkInAlert.location bingAddressDictionary:nil];
    [mapView addMarker:childEntity];
    [childEntity release];
    
    // I set this in Interface Builder... but it doesn't seem to do anything unless I set it here as well
    mapView.userInteractionEnabled = NO;
    
    [self.view addSubview:mapView];
    mapView.hidden = NO;
}

-(void)contract {
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 320, 70);
    backgroundImage.frame = CGRectMake(backgroundImage.frame.origin.x, backgroundImage.frame.origin.y, 320, 70);
    mapView.hidden = YES;
    
    // Remove the mapView
    [mapView removeFromSuperview];
    self.mapView = nil;
}

-(BOOL)expandable {
    return YES;
}

#pragma mark -
#pragma mark ChildResponse Methods
-(void)childRequestSuccess:(Child*)child {
    [childName performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%@ %@", child.firstName, child.lastName] waitUntilDone:NO];
}

-(void)requestFailure:(NSError*)error {
    
}

-(void)dealloc {
    [childName release];
    [locationStr release];
    [locationApproved release];
    [timeMessage release];
    [backgroundImage release];
    [mapView release];
    
    [super dealloc];
}
@end
