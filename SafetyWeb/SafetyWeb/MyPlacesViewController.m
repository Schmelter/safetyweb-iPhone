//
//  MyPlacesViewControllerViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/23/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "MyPlacesViewController.h"
#import "UserManager.h"
#import "RMMarkerManager.h"
#import "RMOpenStreetMapSource.h"
#import "RMProjection.h"
#import "ViewProfileViewController.h"
#import "SWAppDelegate.h"

@interface MyPlacesViewController () {
    NSMutableDictionary *childIdToMarker;
}
@property (nonatomic, retain) NSMutableDictionary *childIdToMarker;
-(void)removeChildMarker:(Child*)aChild;
-(void)addChildMarker:(Child*)aChild;
@end

@implementation MyPlacesViewController
@synthesize mapView;
@synthesize childIdToMarker;
@synthesize locationSearch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mySpacesQ = dispatch_queue_create("com.safetyweb.myspacesq", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *newChildIdToMarker = [[NSMutableDictionary alloc] initWithCapacity:10];
    self.childIdToMarker = newChildIdToMarker;
    [newChildIdToMarker release];
    
    mapView.delegate = self;
    RMOpenStreetMapSource *source = [[RMOpenStreetMapSource alloc] init];
    RMMapContents *contents = [[RMMapContents alloc] initWithView:mapView
                                                       tilesource:source
                                                     //centerLatLon:CLLocationCoordinate2DMake(northernMostLat - southernMostLat, easternMostLong - westernMostLong)
                                                     centerLatLon:CLLocationCoordinate2DMake(0, 0)
                                                        zoomLevel:13.0
                                                     maxZoomLevel:kDefaultMaximumZoomLevel
                                                     minZoomLevel:kDefaultMinimumZoomLevel
                                                  backgroundImage:nil
                                                      screenScale:0];
    mapView.contents = contents;
    [source release];
    [contents release];
    
    User *currentUser = [UserManager getCurrentUser];
    
    BOOL firstChild = YES;
    float northernMostLat = 0;
    float southernMostLat = 0;
    float easternMostLong = 0;
    float westernMostLong = 0;
    
    for (Child *child in currentUser.children) {
        CLLocationCoordinate2D location = [child.location getLocation];
        if (firstChild) {
            northernMostLat = location.latitude;
            southernMostLat = location.latitude;
            easternMostLong = location.longitude;
            westernMostLong = location.longitude;
            firstChild = NO;
        } else {
            if (location.latitude > northernMostLat) northernMostLat = location.latitude;
            if (location.latitude < southernMostLat) southernMostLat = location.latitude;
            if (location.longitude > easternMostLong) easternMostLong = location.longitude;
            if (location.longitude < westernMostLong) westernMostLong = location.longitude;
        }
        [child addObserver:self forKeyPath:@"location" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        [self addChildMarker:child];
    }
    
    [mapView setNeedsLayout];
    [mapView setNeedsDisplay];
    
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake((northernMostLat + southernMostLat)/2, (westernMostLong + easternMostLong)/2);
    
    [mapView moveToLatLong:location];
    [mapView zoomByFactor:0.01 near:CGPointMake(mapView.frame.origin.x + (mapView.frame.size.width / 2), mapView.frame.origin.y + (mapView.frame.size.height / 2)) animated:NO];
    
    // All of these need to be after the moveToLatLong call, because that will call the initial setup of the map
    mapView.enableDragging = YES;
    mapView.enableZoom = YES;
    mapView.enableRotate = NO;
    
    
    /*
    // TODO: Take out later
    __block int childCount = 0;
    __block void(^moveChild)(void) = [^{
        sleep(1); // 1 second
        
        int count = [[[UserManager getCurrentUser] children] count];
        int childNum = childCount % count;
        for (Child *child in [[UserManager getCurrentUser] children]) {
            if (childNum == 0){
                SWLocation *location = child.location;
                location.latitude = [NSNumber numberWithFloat:[location.latitude floatValue] + 1.0];
                NSLog(@"New Latitude: %@", location.latitude);
                child.location = location;
            }
            childNum--;
        }
        childCount++;
        dispatch_async(mySpacesQ, moveChild);
    } copy];
    dispatch_async(mySpacesQ, moveChild);
    [moveChild release];
     */
}

- (void)viewDidUnload {
    self.mapView = nil;
    // Remove observers from each child before releasing the children
    for (ChildMarker *marker in [childIdToMarker allValues]) {
        [(Child*)marker.data removeObserver:self forKeyPath:@"location"];
    }
    self.childIdToMarker = nil;
    self.locationSearch = nil;
    
    [super viewDidUnload];
}

-(void)addChildMarker:(Child *)aChild {
    CLLocationCoordinate2D location = [aChild.location getLocation];
    ChildMarker *childMarker = [[ChildMarker alloc] init];
    childMarker.delegate = self;
    [childMarker setChildData:aChild];
    childMarker.data = aChild;
    //UIImage *pinImage = [UIImage imageNamed:@"point.png"];
    //[childMarker replaceUIImage:pinImage anchorPoint:CGPointMake(0.5,0.5)];
    [mapView.markerManager addMarker:childMarker AtLatLong:location];
    [childIdToMarker setObject:childMarker forKey:aChild.childId];
    [childMarker release];
}

-(void)removeChildMarker:(Child *)aChild {
    ChildMarker *marker = [childIdToMarker objectForKey:aChild.childId];
    if (marker) {
        [mapView.markerManager removeMarker:marker];
        [childIdToMarker removeObjectForKey:aChild.childId];
    }
}

-(IBAction)locationSearchButtonPressed:(id)sender {
    NSLog(@"Location Search: %@", [locationSearch text]);
    NSString *locationText = [locationSearch text];
    
    void(^requestLatLong)(void) = [^{
        NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", locationText];
        NSLog(@"URL String: %@", urlString);
        NSString *locationString = [[[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]] autorelease];
        NSLog(@"Locaton String: %@", locationString);
    } copy];
    dispatch_async([SWAppDelegate dataModelQ], requestLatLong);
    
    [requestLatLong release];
}

#pragma mark -
#pragma mark RMMapViewDelegate Methods
-(void)tapOnMarker:(RMMarker*)marker onMap:(RMMapView*)map {
    [locationSearch resignFirstResponder];
    ChildMarker *childMarker = (ChildMarker*)marker;
    [childMarker setExpanded:![childMarker isExpanded] animated:YES];
}

-(void)tapOnMarker:(RMMarker*)marker subLayer:(CALayer*)subLayer onMap:(RMMapView*)map {
    [locationSearch resignFirstResponder];
    ChildMarker *childMarker = (ChildMarker*)marker;
    [childMarker markerPressed:subLayer];
}

-(void)singleTapOnMap:(RMMapView*)map At:(CGPoint)point {
    [locationSearch resignFirstResponder];
}

#pragma mark -
#pragma mark ChildMarkerDelegate Methods
-(void)childDetailsPressed:(ChildMarker*)aMarker ForData:(id)aData {
    Child *child = (Child*)aData;
    ViewProfileViewController *viewProfile = [[ViewProfileViewController alloc] initWithNibName:@"ViewProfileViewController" bundle:nil];
    viewProfile.child = child;
    [[menuViewController getRootViewController] displayGenericViewController:viewProfile];
    [viewProfile release];
}

#pragma mark -
#pragma mark NSKeyValueObserving informal protocol
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([@"location" isEqualToString:keyPath]) {
        Child *child = (Child*)object;
        ChildMarker *marker = [childIdToMarker objectForKey:child.childId];
        
        [mapView.markerManager moveMarker:marker AtLatLon:(RMLatLong)[child.location getLocation]];
    }
}

-(void)dealloc {
    [mapView release];
    // Remove observers from each child before releasing the children
    for (ChildMarker *marker in [childIdToMarker allValues]) {
        [(Child*)marker.data removeObserver:self forKeyPath:@"location"];
    }
    [childIdToMarker release];
    [locationSearch release];
    
    [super dealloc];
}

@end
