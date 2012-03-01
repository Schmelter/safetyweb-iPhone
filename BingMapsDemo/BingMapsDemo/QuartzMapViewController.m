//
//  QuartzMapViewController.m
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuartzMapViewController.h"

@implementation QuartzMapViewController

@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage *anImage = [UIImage imageNamed:@"radar.png"];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Radar" image:anImage tag:0];
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
    
    QuartzMapLine *blueLine = [[QuartzMapLine alloc] init];
    blueLine.lineColor = [UIColor blueColor];
    blueLine.lineWidth = 2.0;
    blueLine.lineStart = CLLocationCoordinate2DMake(47.68018294648414, -122.4261474609375);
    blueLine.lineEnd = CLLocationCoordinate2DMake(25.78258030688864, -80.2276611328125);
    
    [mapView addShape:blueLine];
    
    [blueLine release];
    
    QuartzMapLine *redLine = [[QuartzMapLine alloc] init];
    redLine.lineColor = [UIColor redColor];
    redLine.lineWidth = 2.0;
    redLine.lineStart = CLLocationCoordinate2DMake(40.71603763556807, -74.00733947753906);
    redLine.lineEnd = CLLocationCoordinate2DMake(34.0631834511178, -118.30284118652344);
    
    [mapView addShape:redLine];
    
    [redLine release];
    
    QuartzMapCircle *blueCircle = [[QuartzMapCircle alloc] init];
    blueCircle.center = CLLocationCoordinate2DMake(39.739154, -104.984703);
    blueCircle.metersRadius = 64373;  // 20 miles
    blueCircle.lineWidth = 3.0;
    UIColor *navyBlue = [[UIColor alloc] initWithRed:0.282352941 green:0.239215686 blue:0.545098039 alpha:1];
    blueCircle.lineColor = navyBlue;
    [navyBlue release];
    UIColor *lightBlue = [[UIColor alloc] initWithRed:0.529411765 green:0.807843137 blue:0.980392157 alpha:0.5];
    blueCircle.fillColor = lightBlue;
    [lightBlue release];

    [mapView addShape:blueCircle];
    
    [blueCircle release];
    
    QuartzMapPolygon *yellowPoly = [[QuartzMapPolygon alloc] init];
    [yellowPoly addPoint:CLLocationCoordinate2DMake(48.857487002645485, 2.230224609375)];
    [yellowPoly addPoint:CLLocationCoordinate2DMake(52.53209625938427, 13.344955444335938)];
    [yellowPoly addPoint:CLLocationCoordinate2DMake(41.916585116228354, 12.315673828125)];
    yellowPoly.lineWidth = 2.0;
    yellowPoly.lineColor = [UIColor yellowColor];
    yellowPoly.fillColor = [UIColor orangeColor];
    
    [mapView addShape:yellowPoly];
    
    [yellowPoly release];
    
    QuartzMapPolygon *purplePoly = [[QuartzMapPolygon alloc] init];
    [purplePoly addPoint:CLLocationCoordinate2DMake(-23.56902214405495, -46.9610595703125)];
    [purplePoly addPoint:CLLocationCoordinate2DMake(-5.10735844762961, -37.760009765625)];
    [purplePoly addPoint:CLLocationCoordinate2DMake(-1.5159363834516735, -79.5849609375)];
    purplePoly.lineWidth = 2.0;
    purplePoly.lineColor = [UIColor purpleColor];
    UIColor *fadedPurple = [[UIColor alloc] initWithRed:0.5 green:0 blue:0.5 alpha:0.5];
    purplePoly.fillColor = fadedPurple;
    [fadedPurple release];
    
    
    [mapView addShape:purplePoly];
    
    [purplePoly release];
}

- (void)viewDidUnload
{
    self.mapView = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc {
    [mapView release];
    
    [super dealloc];
}

@end
