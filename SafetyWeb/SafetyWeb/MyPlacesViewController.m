//
//  MyPlacesViewControllerViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/23/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "MyPlacesViewController.h"
#import "RMMarker.h"
#import "UserManager.h"
#import "RMMarkerManager.h"

@interface ChildMarkerWrapper : NSObject {
    @private
    Child *child;
    RMMarker *marker;
}
@property (nonatomic, retain) Child *child;
@property (nonatomic, retain) RMMarker *marker;
@end

@interface MyPlacesViewController () {
    NSMutableDictionary *childIdToWrapper;
}
@property (nonatomic, retain) NSMutableDictionary *childIdToWrapper;
-(void)removeChildMarker:(Child*)aChild;
-(void)addChildMarker:(Child*)aChild;
@end

@implementation MyPlacesViewController
@synthesize mapView;
@synthesize childIdToWrapper;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *newChildIdToWrapper = [[NSMutableDictionary alloc] initWithCapacity:10];
    self.childIdToWrapper = newChildIdToWrapper;
    [newChildIdToWrapper release];
    
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
        [child addObserver:self forKeyPath:@"location" options:NSKeyValueObservingOptionNew context:nil];
        [self addChildMarker:child];
    }
    
    mapView.delegate = self;
    
    [mapView setNeedsLayout];
    [mapView setNeedsDisplay];
    
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake((northernMostLat + southernMostLat)/2, (westernMostLong + easternMostLong)/2);
    
    [mapView moveToLatLong:location];
    [mapView zoomByFactor:0.01 near:CGPointMake(mapView.frame.origin.x + (mapView.frame.size.width / 2), mapView.frame.origin.y + (mapView.frame.size.height / 2)) animated:NO];
    
    // All of these need to be after the moveToLatLong call, because that will call the initial setup of the map
    mapView.enableDragging = YES;
    mapView.enableZoom = YES;
    mapView.enableRotate = NO;
    
    
    // TODO: Take out later
    void(^moveChild)(void) = [^{
        sleep(1); // 1 second
        self.childIdToWrapper
    } copy];
    
    
    
    [moveChild release];
}

- (void)viewDidUnload {
    self.mapView = nil;
    // Remove observers from each child before releasing the children
    for (ChildMarkerWrapper *wrapper in [childIdToWrapper allValues]) {
        [wrapper.child removeObserver:self forKeyPath:@"location"];
    }
    self.childIdToWrapper = nil;
    
    [super viewDidUnload];
}

-(void)addChildMarker:(Child *)aChild {
    CLLocationCoordinate2D location = [aChild.location getLocation];
    UIImage *pinImage = [UIImage imageNamed:@"point.png"];
    RMMarker *childMarker = [[RMMarker alloc] initWithUIImage:pinImage];
    [mapView.markerManager addMarker:childMarker AtLatLong:location];
    ChildMarkerWrapper *wrapper = [[ChildMarkerWrapper alloc] init];
    wrapper.child = aChild;
    wrapper.marker = childMarker;
    [childIdToWrapper setObject:wrapper forKey:aChild.childId];
    [childMarker release];
    [wrapper release];
}

-(void)removeChildMarker:(Child *)aChild {
    RMMarker *childMarker = [childIdToWrapper objectForKey:aChild.childId];
    if (childMarker) {
        [mapView.markerManager removeMarker:childMarker];
        [childIdToWrapper removeObjectForKey:aChild.childId];
    }
}

#pragma mark -
#pragma mark NSKeyValueObserving informal protocol
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([@"location" isEqualToString:keyPath]) {
        Child *child = (Child*)object;
        [self removeChildMarker:child];
        [self addChildMarker:child];
    }
}

-(void)dealloc {
    [mapView release];
    // Remove observers from each child before releasing the children
    for (ChildMarkerWrapper *wrapper in [childIdToWrapper allValues]) {
        [wrapper.child removeObserver:self forKeyPath:@"location"];
    }
    self.childIdToWrapper = nil;
    
    [super dealloc];
}

@end


@implementation ChildMarkerWrapper
@synthesize child;
@synthesize marker;

-(void)dealloc {
    [child release];
    [marker release];
    
    [super dealloc];
}
@end
