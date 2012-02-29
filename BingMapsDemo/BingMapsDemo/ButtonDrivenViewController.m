//
//  ButtonDrivenViewController.m
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ButtonDrivenViewController.h"

@implementation BMCustomEntity

-(void)showDetails:(id)sender {
    UIAlertView* alertDetails = [[UIAlertView alloc] initWithTitle:@"Details" message:[NSString stringWithFormat:@"You pressed the show details for: %@", [self title]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertDetails show];
    [alertDetails release];
}

@end

@implementation ButtonDrivenViewController

@synthesize mapView;
@synthesize zoomToggle;
@synthesize dragToggle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage *anImage = [UIImage imageNamed:@"second.png"];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Drag" image:anImage tag:0];
        self.tabBarItem = tabBarItem;
        [tabBarItem release];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Setup the map to look nice, with pins for the mom, dad, and child
    [mapView setDelegate:self];
    
    dadLoc = [[BMCustomEntity alloc] initWithCoordinate:CLLocationCoordinate2DMake(39.605985, -105.168533) bingAddressDictionary:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"title", @"subtitle", @"addressLine", @"adminDistrict", @"adminDistrict2", @"locality", @"postalCode", @"countryRegion", @"formattedAddress", nil] forKeys:[NSArray arrayWithObjects:@"title", @"subtitle", @"addressLine", @"adminDistrict", @"adminDistrict2", @"locality", @"postalCode", @"countryRegion", @"formattedAddress", nil]]];
    
    
    momLoc = [[BMCustomEntity alloc] initWithCoordinate:CLLocationCoordinate2DMake(39.750679, -104.99851) bingAddressDictionary:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"title", @"subtitle", @"addressLine", @"adminDistrict", @"adminDistrict2", @"locality", @"postalCode", @"countryRegion", @"formattedAddress", nil] forKeys:[NSArray arrayWithObjects:@"title", @"subtitle", @"addressLine", @"adminDistrict", @"adminDistrict2", @"locality", @"postalCode", @"countryRegion", @"formattedAddress", nil]]];
    
    childLoc = [[BMCustomEntity alloc] initWithCoordinate:CLLocationCoordinate2DMake(39.656391, -105.10968) bingAddressDictionary:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"title", @"subtitle", @"addressLine", @"adminDistrict", @"adminDistrict2", @"locality", @"postalCode", @"countryRegion", @"formattedAddress", nil] forKeys:[NSArray arrayWithObjects:@"title", @"subtitle", @"addressLine", @"adminDistrict", @"adminDistrict2", @"locality", @"postalCode", @"countryRegion", @"formattedAddress", nil]]];
    
    
    [mapView addMarker:dadLoc];
    [mapView addMarker:momLoc];
    [mapView addMarker:childLoc];
    
    CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake(39.6375, -105.064);
    BMCoordinateSpan mapSpan = BMCoordinateSpanMake(0.329567, 0.44034);
    mapView.region = BMCoordinateRegionMake(mapCenter, mapSpan);
    
    [dragToggle setBackgroundColor:[UIColor greenColor]];
    [zoomToggle setBackgroundColor:[UIColor greenColor]];
}

- (void)viewDidUnload
{
    self.mapView = nil;
    self.zoomToggle = nil;
    self.dragToggle = nil;
    [momLoc release];
    momLoc = nil;
    [dadLoc release];
    dadLoc = nil;
    [childLoc release];
    childLoc = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark IBAction Methods
-(IBAction)momPressed:(id)sender {
    BMCoordinateRegion tempRegion = BMCoordinateRegionMake(momLoc.coordinate, mapView.region.span);
    [mapView setRegion:tempRegion animated:YES];
}

-(IBAction)dadPressed:(id)sender {
    BMCoordinateRegion tempRegion = BMCoordinateRegionMake(dadLoc.coordinate, mapView.region.span);
    [mapView setRegion:tempRegion animated:YES];
}

-(IBAction)childPressed:(id)sender {
    BMCoordinateRegion tempRegion = BMCoordinateRegionMake(childLoc.coordinate, mapView.region.span);
    [mapView setRegion:tempRegion animated:YES];
}

-(IBAction)zoomPressed:(id)sender {
    // Zoom in 10% more
    BMCoordinateSpan tempSpan = BMCoordinateSpanMake(mapView.region.span.latitudeDelta * .2, mapView.region.span.longitudeDelta * .2);
    [mapView setRegion:BMCoordinateRegionMake(mapView.region.center, tempSpan) animated:YES];
}

-(IBAction)zoomTogglePressed:(id)sender {
    mapView.zoomEnabled = !mapView.zoomEnabled;
    if (mapView.zoomEnabled) {
        [zoomToggle setBackgroundColor:[UIColor greenColor]];
    } else {
        [zoomToggle setBackgroundColor:[UIColor redColor]];
    }
}

-(IBAction)dragTogglePressed:(id)sender {
    mapView.scrollEnabled = !mapView.scrollEnabled;
    if (mapView.scrollEnabled) {
        [dragToggle setBackgroundColor:[UIColor greenColor]];
    } else {
        [dragToggle setBackgroundColor:[UIColor redColor]];
    }
}

#pragma mark -
#pragma mark BMMapViewDelegate

-(BMMarkerView*)mapView:(BMMapView *)aMapView viewForMarker:(id<BMMarker>)aMarker {
    NSLog(@"Marker Class: %@", [aMarker class]);
    if ([aMarker isKindOfClass:[BMUserLocation class]]) {
        return nil;
    }
    
    // Build a generic view for this marker based on its NSDictionary of properties
    // We'll just use the title as the id.  None of this is going to change
    NSString* titleMarkerId = [aMarker title];
    BMMarkerView* pinView = (BMMarkerView*) [mapView dequeueReusableMarkerViewWithIdentifier:titleMarkerId];
    if (!pinView) {
        BMPushpinView* customPinView = [[[BMPushpinView alloc] initWithMarker:aMarker reuseIdentifier:titleMarkerId] autorelease];
        
        customPinView.pinColor = BMPushpinColorRed;
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        customPinView.enabled = YES;
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:aMarker action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
        customPinView.calloutAccessoryView2 = rightButton;
        customPinView.marker = aMarker;
        
        return customPinView;
    } else {
        pinView.marker = aMarker;
    }
    return pinView;
}

-(void)dealloc {
    [mapView release];
    [zoomToggle release];
    [dragToggle release];
    [momLoc release];
    [dadLoc release];
    [childLoc release];
    
    [super dealloc];
}

@end
