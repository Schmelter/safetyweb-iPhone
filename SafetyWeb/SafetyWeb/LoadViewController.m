//
//  LoadViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadViewController.h"

@implementation LoadViewController

@synthesize tipLabel;
@synthesize progressView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    progressView.borderWidth = 12.0f;
    
    const CGFloat innerColor[] = {0.45312, 0.71093, 0.8398, 1.0};
    const CGFloat outterColor[] = {0.3125, 0.63671, 0.8125, 1.0};
    
    progressView.outterBorderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), outterColor);
    
    
    progressView.innerBorderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), innerColor);
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    self.tipLabel = nil;
    self.progressView = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc {
    [tipLabel release];
    [progressView release];
    
    [super dealloc];
}

@end