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
    timeMessage.text = [Utilities timeIntervalToHumanString:[checkInAlert.timestamp timeIntervalSince1970]];
    
    if (row % 2 == 0) backgroundImage.image = [UIImage imageNamed:@"dark_zebra_BG.png"];
    else backgroundImage.image = nil;
    
    mapView.delegate = self;
    mapView.scrollEnabled = NO;
    mapView.zoomEnabled = NO;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([checkInAlert.locationLat floatValue], [checkInAlert.locationLong floatValue]);
    [mapView setCenterCoordinate:coordinate animated:NO];
    [mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(.005, .0025)) animated:NO];
    
    id<MKAnnotation> annotation = [[SWPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = @"Title";
    annotation.subtitle = @"SubTitle";
    
    [mapView addAnnotation:annotation];
    [annotation release];
    
    // I set this in Interface Builder... but it doesn't seem to do anything unless I set it here as well
    mapView.userInteractionEnabled = NO;
    
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
    mapView.hidden = NO;
}

-(void)contract {
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 320, 70);
    backgroundImage.frame = CGRectMake(backgroundImage.frame.origin.x, backgroundImage.frame.origin.y, 320, 70);
    mapView.hidden = YES;
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
