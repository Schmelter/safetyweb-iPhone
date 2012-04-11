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
    [ChildManager requestChildForId:childIdRequest withResponse:self];
    [childIdRequest release];
    
    locationStr.text = checkInAlert.locationStr;
    locationApproved.text = checkInAlert.locationApproved ? @"Location Approved" : @"Location NOT Approved";
    timeMessage.text = [Utilities timeIntervalToHumanString:[checkInAlert.timestamp timeIntervalSince1970]];
    
    if (row % 2 == 0) backgroundImage.image = [UIImage imageNamed:@"dark_zebra_BG.png"];
    else backgroundImage.image = nil;
    
<<<<<<< HEAD
=======
    mapView.delegate = self;
    //mapContents = [[RMMapContents alloc] initWithView:mapView
    //                                       tilesource:[[RMCloudMadeMapSource alloc] initWithAccessKey:@"0199bdee456e59ce950b0156029d6934" styleNumber:7]];
    
    //mapContents = [[RMMapContents alloc] initWithView:mapView
    //                         tilesource:[[RMVirtualEarthSource alloc] initWithHybridThemeUsingAccessKey:@"invalidKey"]];
    
    [mapView setNeedsLayout];
    [mapView setNeedsDisplay];
    
    mapView.enableDragging = NO;
    mapView.enableZoom = NO;
    mapView.enableRotate = NO;
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([checkInAlert.locationLat floatValue], [checkInAlert.locationLong floatValue]);
    [mapView moveToLatLong:location];
    [mapView zoomByFactor:1.0 near:CGPointMake(mapView.frame.origin.x + (mapView.frame.size.width / 2), mapView.frame.origin.y + (mapView.frame.size.height / 2)) animated:NO];
    
    
    UIImage *childImage = [UIImage imageNamed:@"point.png"];
    RMMarker *childMarker = [[RMMarker alloc] initWithUIImage:childImage];
    [mapView.markerManager addMarker:childMarker AtLatLong:location];
    [childMarker release];
    [childImage release];
    
    /*id<MKAnnotation> annotation = [[SWPointAnnotation alloc] init];
    annotation.coordinate = checkInAlert.location;
    annotation.title = @"Title";
    annotation.subtitle = @"SubTitle";
    
    [mapView addAnnotation:annotation];
    [annotation release];*/
    
    // I set this in Interface Builder... but it doesn't seem to do anything unless I set it here as well
    mapView.userInteractionEnabled = NO;
    
>>>>>>> d6bab80... Half way through moving to CoreData.  All of the basic data Objects are now NSManagedObjects, but nothing is being persisted, and none of the UIs are listening for data changes
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
