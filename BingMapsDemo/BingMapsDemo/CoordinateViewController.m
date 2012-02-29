//
//  CoordinateViewController.m
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoordinateViewController.h"

@implementation CoordinateViewController

@synthesize mapView;
@synthesize latitude;
@synthesize longitude;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage *anImage = [UIImage imageNamed:@"first.png"];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Coord" image:anImage tag:0];
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
    
    [mapView setDelegate:self];
    [mapView setShowsUserLocation:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.mapView = nil;
    self.latitude = nil;
    self.longitude = nil;
    
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
#pragma mark UITextFieldDelegate Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string length] == 0) return YES;
    if ([textField.text length] == 0 && [string characterAtIndex:0] == '-') return YES;
    NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.-"] invertedSet];
    BOOL result = ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0);
    
    if (!result) return result;
    
    NSMutableString *mutableStr = [[NSMutableString alloc] initWithCapacity:[textField.text length] + [string length]];
    [mutableStr appendString:textField.text];
    [mutableStr appendString:string];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    result = [numberFormatter numberFromString:mutableStr] != nil;
    
    [numberFormatter release];
    [mutableStr release];
    return result;
}

#pragma mark -
#pragma mark IBAction Methods
-(IBAction)viewButtonPressed:(id)sender {
    // Validate the lat/long, and pull them out
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *latNum = [numberFormatter numberFromString:latitude.text];
    NSNumber *longNum = [numberFormatter numberFromString:longitude.text];
    
    if (latNum == nil || [latNum doubleValue] > 180.0 || [latNum doubleValue] < -180.0) {
        UIAlertView *badLatAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Bad Lat Alert"
                                     message:@"Please provide a Latitude between -180 and +180 degrees"
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        [badLatAlert show];
        [badLatAlert release];
        [latitude becomeFirstResponder];
    } else if (longNum == nil || [longNum doubleValue] > 180.0 || [longNum doubleValue] < -180.0) {
        UIAlertView *badLongAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Bad Long Alert"
                                     message:@"Please provide a Longitude between -180 and +180 degrees"
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        [badLongAlert show];
        [badLongAlert release];
        [longitude becomeFirstResponder];
    } else {
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([latNum doubleValue], [longNum doubleValue]);
        
        BMCoordinateSpan span;
        span.latitudeDelta = .01;
        span.longitudeDelta = .01;
        
        BMCoordinateRegion region = BMCoordinateRegionMake(coords, span);
        region = [mapView regionThatFits:region];
        [mapView setRegion:region animated:YES];
        
        //[mapView setCenterCoordinate:location animated:YES];
    }
    
    [numberFormatter release];
}

-(IBAction)backgroundTap:(id)sender {
    [latitude resignFirstResponder];
    [longitude resignFirstResponder];
}

-(void)dealloc {
    [mapView release];
    [latitude release];
    [longitude release];
    
    [super dealloc];
}

@end
