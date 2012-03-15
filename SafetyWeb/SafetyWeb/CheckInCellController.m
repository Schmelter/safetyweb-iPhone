//
//  CheckInCellController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckInCellController.h"

@implementation CheckInCellController
@synthesize child;
@synthesize row;
@synthesize backgroundImage;
@synthesize childImage;
@synthesize firstName;
@synthesize lastName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        row = 0;
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
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if (row % 2 == 0) {
        UIImage *backgroundImg = [UIImage imageNamed:@"dark_zebra_BG.png"];
        backgroundImage.image = backgroundImg;
    } else {
        
    }
    
    firstName.text = child.firstName;
    lastName.text = child.lastName;
    
    if (child.profilePicUrl) {
        ImageCacheManager *cacheManager = [[ImageCacheManager alloc] init];
        [cacheManager requestImage:self ForUrl:[child.profilePicUrl description]];
        [cacheManager release];
    }
    [pool release];
}

- (void)viewDidUnload
{
    self.backgroundImage = nil;
    self.childImage = nil;
    self.firstName = nil;
    self.lastName = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark IBAction Methods
-(IBAction)requestCheckInPressed:(id)sender {
    
}

#pragma mark -
#pragma mark CachedImage Methods
-(void)setImage:(UIImage*)imageData {
    childImage.image = imageData;
}

-(BOOL)expires {
    return YES;
}

-(void)dealloc {
    [child release];
    [backgroundImage release];
    [childImage release];
    [firstName release];
    [lastName release];
    
    [super dealloc];
}

@end
