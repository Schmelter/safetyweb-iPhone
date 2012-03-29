//
//  ViewProfileViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewProfileViewController.h"

@implementation ViewProfileViewController
@synthesize editButton;
@synthesize childImage;
@synthesize childName;
@synthesize address;
@synthesize mobilePhone;
@synthesize callButton;
@synthesize socialMediaTable;
@synthesize scrollView;
@synthesize contentView;
@synthesize child;

// TODO: There's a lot here.  Basically, once we know what the child json can contain, and have parsed it properly,
// load all of that data on this screen.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isEditing = NO;
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
    
    isEditing = NO;
    contentView.autoresizesSubviews = NO;  // We're going to resize ourselves
    
    // Stretch out the socialMediaTable based on how many accounts this child has
    CGFloat oldTableHeight = socialMediaTable.frame.size.height;
    socialMediaTable.frame = CGRectMake(socialMediaTable.frame.origin.x, socialMediaTable.frame.origin.y, socialMediaTable.frame.size.width, (CGFloat)(kTableRowHeight * [[child getAllAccounts] count]));
    // Stretch out the scroll view just as much as we stretched out the socialMediaTable
    contentView.frame = CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, contentView.frame.size.width, contentView.frame.size.height + ((CGFloat)(kTableRowHeight * [[child getAllAccounts] count]) - oldTableHeight));
    scrollView.contentSize = contentView.frame.size;
    
    // Round some corners, and make everything look nice
    [address layer].cornerRadius = 10;
    [mobilePhone layer].cornerRadius = 10;
    [socialMediaTable layer].cornerRadius = 10;
    
    // Load the simple data into the interface
    if (child.profilePicUrl) {
        ImageCacheManager *cacheManager = [[ImageCacheManager alloc] init];
        [cacheManager requestImage:self ForUrl:[child.profilePicUrl description]];
        [cacheManager release];
    }
    NSString *childNameStr = [[NSString alloc] initWithFormat:@"%@ %@", child.firstName, child.lastName];
    childName.text = childNameStr;
    [childNameStr release];
    address.text = child.address;
    mobilePhone.text = child.mobilePhone;
    
    // Hide the call button if the current iOS device is incapable of phone calls
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
        callButton.hidden = YES;
    }
    
    [pool release];
}

- (void)viewDidUnload
{
    self.editButton = nil;
    self.childImage = nil;
    self.childName = nil;
    self.address = nil;
    self.mobilePhone = nil;
    self.callButton = nil;
    self.socialMediaTable = nil;
    self.scrollView = nil;
    self.contentView = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark IBAction Methods
-(IBAction)backgroundTap:(id)sender {
    [address resignFirstResponder];
    [mobilePhone resignFirstResponder];
}

-(IBAction)backPressed:(id)sender {
    [rootViewController displayMenuViewController];
}

-(IBAction)editPressed:(id)sender {
    // TODO: Figure out what the edit button should really do
    // Change the edit button into a save button, and switch all the text fields to be editable
    isEditing = !isEditing;
    if (isEditing) {
        // Allow edits
        [editButton setTitle:@"Save" forState:UIControlStateNormal];
        address.editable = YES;
        mobilePhone.editable = YES;
    } else {
        // Save edits
        address.editable = NO;
        mobilePhone.editable = NO;
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        
        child.address = address.text;
        child.mobilePhone = mobilePhone.text;
    }
    
}

-(IBAction)callPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://7209826931"]];
}

#pragma mark -
#pragma mark UITableViewDelegate/UITableViewDataSource Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[child getAllAccounts] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Account *account = [[child getAllAccounts] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = account.serviceName;
    // TODO: Determine this based on the serviceName
    cell.imageView.image = [UIImage imageNamed:@"butterfly.png"];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    [pool release];
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    // TODO: Open the account page for the given row
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
    [editButton release];
    [childImage release];
    [childName release];
    [address release];
    [mobilePhone release];
    [callButton release];
    [socialMediaTable release];
    [scrollView release];
    [contentView release];
    [child release];
    
    [super dealloc];
}

@end
