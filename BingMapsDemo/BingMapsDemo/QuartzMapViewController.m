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
