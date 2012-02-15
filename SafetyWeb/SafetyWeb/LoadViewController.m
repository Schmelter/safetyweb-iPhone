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
@synthesize loadProgress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateLoading:) userInfo:nil repeats:YES];
        [timer retain];
        progress = 0.0f;
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
    loadProgress.borderWidth = 12.0f;
    
    const CGFloat innerColor[] = {0.45312, 0.71093, 0.8398, 1.0};
    const CGFloat outterColor[] = {0.3125, 0.63671, 0.8125, 1.0};
    
    loadProgress.outterBorderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), outterColor);
    
    
    loadProgress.innerBorderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), innerColor);
    
    [timer fire];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    self.tipLabel = nil;
    self.loadProgress = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)updateLoading:(id)sender {
    progress += 5.0f;
    if (progress > 100.0f) progress = 100.0f;
    loadProgress.progressCurrent = progress;
    if (progress >= 100.0f) [timer invalidate];
}

-(void)dealloc {
    [tipLabel release];
    [loadProgress release];
    [timer invalidate];
    [timer release];
    
    [super dealloc];
}

@end
