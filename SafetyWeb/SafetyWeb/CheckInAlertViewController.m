//
//  CheckInAlertViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/17/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "CheckInAlertViewController.h"
#import "Utilities.h"
#import "RMMarkerManager.h"
#import "RMMarker.h"

@implementation CheckInAlertViewController
@synthesize alert;
@synthesize childImage;
@synthesize childName;
@synthesize locationStr;
@synthesize locationApproved;
@synthesize timeMessage;
@synthesize mapView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
                
                ImageCacheManager *cacheManager = [[ImageCacheManager alloc] init];
                [cacheManager requestImage:self ForUrl:[aChild.profilePicUrl description]];
                [cacheManager release];
            } else {
                
            }
        };
        [childRequest performRequest];
        [childRequest release];
        
        locationStr.text = checkInAlert.locationStr;
        locationApproved.text = checkInAlert.locationApproved ? @"Location Approved" : @"Location NOT Approved";
        timeMessage.text = [Utilities timeIntervalToHumanString:[checkInAlert.timestamp timeIntervalSince1970]];
        
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
        
        
        UIImage *pinImage = [UIImage imageNamed:@"point.png"];
        RMMarker *childMarker = [[RMMarker alloc] initWithUIImage:pinImage];
        [mapView.markerManager addMarker:childMarker AtLatLong:location];
        [childMarker release];
        
    }
}

- (void)viewDidUnload {
    self.childImage = nil;
    self.childName = nil;
    self.locationStr = nil;
    self.locationApproved = nil;
    self.timeMessage = nil;
    self.mapView = nil;
    
    [super viewDidUnload];
}

#pragma mark -
#pragma mark IBAction Methods
-(IBAction)backPressed:(id)sender {
    [rootViewController displayMenuViewController];
}

#pragma mark -
#pragma mark CachedImage Methods
-(void)setImage:(UIImage*)imageData {
    childImage.image = imageData;
}

-(BOOL)expires {
    return YES;
}

-(void)dealloc {
    [alert release];
    [childImage release];
    [childName release];
    [locationStr release];
    [locationApproved release];
    [timeMessage release];
    [mapView release];
    
    [super dealloc];
}

@end
