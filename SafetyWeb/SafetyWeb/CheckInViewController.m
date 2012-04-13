//
//  CheckInViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckInViewController.h"

@implementation CheckInViewController
@synthesize checkInTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        user = nil;
        cellControllersLen = 0;
        cellControllers = calloc(cellControllersLen, sizeof(CheckInCellController*));
        cellControllersLock = [[NSObject alloc] init];
        
        UserRequest *userRequest = [[UserRequest alloc] init];
        userRequest.token = [UserManager getLastUsedToken];
        [UserManager requestUser:userRequest withResponse:self];
        [userRequest release];
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
    
    // TODO: Remove this later when we have the properly fitting artwork
    self.view.clipsToBounds = YES;
}

- (void)viewDidUnload
{
    self.checkInTable = nil;
    
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
#pragma mark UITableViewDelegate and UITableViewDataSource methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @synchronized (cellControllersLock) {
        return cellControllersLen;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @synchronized (cellControllersLock) {
        Child *child = [[user sortedChildren] objectAtIndex:indexPath.row];
        
        if (!cellControllers[indexPath.row]) {
            cellControllers[indexPath.row] = [[CheckInCellController alloc] initWithNibName:@"CheckInCellController" bundle:nil];
        }
    
        cellControllers[indexPath.row].child = child;
        cellControllers[indexPath.row].row = indexPath.row;
    
        return cellControllers[indexPath.row].tableViewCell;
    }
}

#pragma mark -
#pragma mark IBAction Methods
-(IBAction)announcePressed:(id)sender {
    // TODO: Actually send a check in request, and watch for failure.  Notifying the user of what happened
    // For now, just show a nice alert saying everything went well
    
    UIAlertView *announceLocAlert = [[UIAlertView alloc] 
                                     initWithTitle:@"Announce Location"
                                     message:@"Your Location has been announced"
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
    [announceLocAlert show];
    [announceLocAlert release];
    return;
}

#pragma mark -
#pragma mark AllChildResponse Methods
-(void)userRequestSuccess:(User *)aUser {
    @synchronized (cellControllersLock) {
        [aUser retain];
        [user release];
        user = aUser;
        
        CheckInCellController **newCellControllers = calloc([[user children] count], sizeof(CheckInCellController*));
        for (int i = 0; i < cellControllersLen; i++) {
            if ([user.children count] > i) newCellControllers[i] = cellControllers[i];
            else [cellControllers[i] release];
        }
        free(cellControllers);
        cellControllersLen = [user.children count];
        cellControllers = newCellControllers;
        
        [checkInTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
}

-(void)requestFailure:(NSError*)error {
    
}

-(void)dealloc {
    for (int i = 0; i < cellControllersLen; i++) {
        [cellControllers[i] release];
    }
    free(cellControllers);
    [cellControllersLock release];
    [checkInTable release];
    
    [super dealloc];
}

@end
