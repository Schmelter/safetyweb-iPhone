//
//  SettingsViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

#define kRowAlertSettings 0
#define kRowMapSettings 1

@implementation SettingsViewController
@synthesize settingsTable;
@synthesize accountLoginBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarnin {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [accountLoginBtn setTitle:[UserManager getLastUsedLogin] forState:UIControlStateNormal];
    //[accountLoginBtn setTitle:@"Batman" forState:UIControlStateNormal];
    
    // Round some corners
    [settingsTable layer].cornerRadius = 10;
    
    // TODO: Remove this later when we have the properly fitting artwork
    self.view.clipsToBounds = YES;
}

- (void)viewDidUnload {
    self.settingsTable = nil;
    self.accountLoginBtn = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UITableViewDelegate/UITableViewDataSource Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == kRowAlertSettings) {
        cell.textLabel.text = @"Alert Settings";
        cell.imageView.image = nil;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    } else if (indexPath.row == kRowMapSettings) {
        cell.textLabel.text = @"Map Settings";
        cell.imageView.image = nil;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    [pool release];
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    // TODO: Open the settings page for the given row
}

#pragma mark -
#pragma mark IBAction Methods
-(IBAction)accountLoginPressed:(id)sender {
    [[menuViewController getRootViewController] displayLoginViewController];
}

-(IBAction)inviteOthersPressed:(id)sender {
    // TODO: Implement
}

-(void)dealloc {
    [settingsTable release];
    [accountLoginBtn release];
    
    [super dealloc];
}

@end
