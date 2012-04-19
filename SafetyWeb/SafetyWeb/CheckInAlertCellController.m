//
//  CheckInAlertCellController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/29/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "CheckInAlertCellController.h"
//#import "RMCloudMadeMapSource.h"
//#import "RMVirtualEarthSource.h"
#import "RMMarkerManager.h"
#import "RMMarker.h"
#import "CheckInAlertViewController.h"

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
    
    @autoreleasepool {
        
        CheckInAlert *checkInAlert = (CheckInAlert*)alert;
        
        ChildAccountRequest *childRequest = [[ChildAccountRequest alloc] init];
        childRequest.childId = checkInAlert.childId;
        childRequest.user = [UserManager getCurrentUser];
        childRequest.responseBlock = ^(BOOL success, Child *aChild, NSError *error) {
            if (success) {
                [childName performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%@ %@", aChild.firstName, aChild.lastName] waitUntilDone:NO];
            } else {
                
            }
        };
        [childRequest performRequest];
        [childRequest release];
        
        locationStr.text = checkInAlert.locationStr;
        locationApproved.text = checkInAlert.locationApproved ? @"Location Approved" : @"Location NOT Approved";
        timeMessage.text = [Utilities timeIntervalToHumanString:[checkInAlert.timestamp timeIntervalSince1970]];
        
        if (row % 2 == 0) backgroundImage.image = [UIImage imageNamed:@"Alerts_Screen_ZebraStripe.png"];
        else backgroundImage.image = nil;
        
        mapView.delegate = self;
        //mapContents = [[RMMapContents alloc] initWithView:mapView
        //                                       tilesource:[[RMCloudMadeMapSource alloc] initWithAccessKey:@"0199bdee456e59ce950b0156029d6934" styleNumber:7]];
        
        //mapContents = [[RMMapContents alloc] initWithView:mapView
        //                         tilesource:[[RMVirtualEarthSource alloc] initWithHybridThemeUsingAccessKey:@"invalidKey"]];
        
        [mapView setNeedsLayout];
        [mapView setNeedsDisplay];
        
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([checkInAlert.locationLat floatValue], [checkInAlert.locationLong floatValue]);
        [mapView moveToLatLong:location];
        [mapView zoomByFactor:1.0 near:CGPointMake(mapView.frame.origin.x + (mapView.frame.size.width / 2), mapView.frame.origin.y + (mapView.frame.size.height / 2)) animated:NO];
        
        // All of these need to be after the moveToLatLong call, because that will call the initial setup of the map
        mapView.enableDragging = NO;
        mapView.enableZoom = NO;
        mapView.enableRotate = NO;
        
        
        UIImage *childImage = [UIImage imageNamed:@"point.png"];
        RMMarker *childMarker = [[RMMarker alloc] initWithUIImage:childImage];
        [mapView.markerManager addMarker:childMarker AtLatLong:location];
        [childMarker release];
        
        /*id<MKAnnotation> annotation = [[SWPointAnnotation alloc] init];
         annotation.coordinate = checkInAlert.location;
         annotation.title = @"Title";
         annotation.subtitle = @"SubTitle";
         
         [mapView addAnnotation:annotation];
         [annotation release];*/
        
        // I set this in Interface Builder... but it doesn't seem to do anything unless I set it here as well
        mapView.userInteractionEnabled = NO;
        
    }
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
#pragma mark IBAction Methods
-(IBAction)detailPressed:(id)sender {
    CheckInAlertViewController *viewAlert = [[CheckInAlertViewController alloc] initWithNibName:@"CheckInAlertViewController" bundle:nil];
    viewAlert.alert = (CheckInAlert*)alert;
    [[[self.alertsViewController getMenuViewController] getRootViewController] displayGenericViewController:viewAlert];
    [viewAlert release];
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
