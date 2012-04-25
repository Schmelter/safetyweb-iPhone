//
//  MyPlacesViewControllerViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/23/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "MyPlacesViewController.h"
#import "ChildMarker.h"
#import "RMMarker.h"
#import "UserManager.h"
#import "RMMarkerManager.h"
#import "RMOpenStreetMapSource.h"
#import "RMProjection.h"

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
        NSLog(@"Observation Info: %@", [child observationInfo]);
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
    
    [super viewDidUnload];
}

-(void)addChildMarker:(Child *)aChild {
    CLLocationCoordinate2D location = [aChild.location getLocation];
    ChildMarker *childMarker = [[ChildMarker alloc] init];
    [childMarker setChildData:aChild];
    childMarker.data = aChild;
    //UIImage *pinImage = [UIImage imageNamed:@"point.png"];
    //[childMarker replaceUIImage:pinImage anchorPoint:CGPointMake(0.5,0.5)];
    [mapView.markerManager addMarker:childMarker AtLatLong:location];
    [childIdToMarker setObject:childMarker forKey:aChild.childId];
    [childMarker release];
    NSLog(@"Location Lat: %f Location Long: %f ChildMarker: %@", location.latitude, location.longitude, childMarker);
}

-(void)removeChildMarker:(Child *)aChild {
    ChildMarker *marker = [childIdToMarker objectForKey:aChild.childId];
    if (marker) {
        [mapView.markerManager removeMarker:marker];
        [childIdToMarker removeObjectForKey:aChild.childId];
    }
}

#pragma mark -
#pragma mark RMMapViewDelegate Methods
-(void)tapOnMarker:(RMMarker*)marker onMap:(RMMapView*)map {
    ChildMarker *childMarker = (ChildMarker*)marker;
    [childMarker setExpanded:![childMarker isExpanded] animated:YES];
    
    
    NSLog(@"Marker tapped");
    NSLog(@"Marker: %@", marker);
    NSLog(@"Marker Data: %@", marker.data);
}

-(void)tapOnMarker:(RMMarker*)marker subLayer:(CALayer*)subLayer onMap:(RMMapView*)map {
    ChildMarker *childMarker = (ChildMarker*)marker;
    [childMarker setExpanded:![childMarker isExpanded] animated:YES];
    
    NSLog(@"Marker tapped");
    NSLog(@"Marker: %@", marker);
    NSLog(@"Marker Data: %@", marker.data);
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
    
    [super dealloc];
}

@end
