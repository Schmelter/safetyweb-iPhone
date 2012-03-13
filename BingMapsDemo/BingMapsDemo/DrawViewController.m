//
//  DrawViewController.m
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawViewController.h"

@implementation DrawViewController

@synthesize mapView;
@synthesize drawButton;
@synthesize editButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        drawing = NO;
        editing = NO;
        
        UIImage *anImage = [UIImage imageNamed:@"pencil.png"];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Draw" image:anImage tag:0];
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
    
    [drawButton setBackgroundColor:[UIColor redColor]];
    [editButton setBackgroundColor:[UIColor redColor]];
}

- (void)viewDidUnload
{
    self.mapView = nil;
    self.drawButton = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark IBAction Methods
-(IBAction)drawPressed:(id)sender {
    if (editing) [self editPressed:nil];
    drawing = !drawing;
    if (drawing) {
        [drawButton setBackgroundColor:[UIColor greenColor]];
        [mapView startDrawing:[UIColor blueColor] withWidth:2.0];
    } else {
        [drawButton setBackgroundColor:[UIColor redColor]];
        UIColor *fillColor = [[UIColor alloc] initWithRed:1.0 green:0 blue:0 alpha:0.25];
        [mapView stopDrawing:fillColor];
        [fillColor release];
    }
}

-(IBAction)editPressed:(id)sender {
    if (drawing) [self drawPressed:nil];
    editing = !editing;
    if (editing) {
        [editButton setBackgroundColor:[UIColor greenColor]];
        [mapView startEditing];
    } else {
        [editButton setBackgroundColor:[UIColor redColor]];
        [mapView stopEditing];
    }
}

-(void)dealloc {
    [mapView release];
    [drawButton release];
    
    [super dealloc];
}

@end
