//
//  MyPeopleViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyPeopleViewController.h"

@implementation MyPeopleViewController
@synthesize myPeopleTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        children = nil;
        cellControllersLen = 0;
        cellControllers = calloc(cellControllersLen, sizeof(MyPeopleCellController*));
        cellControllersLock = [[NSObject alloc] init];
        
        AllChildRequest *allChildRequest = [[AllChildRequest alloc] init];
        allChildRequest.response = self;
        [ChildManager requestAllChildren:allChildRequest];
        [allChildRequest release];
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
    // Do any additional setup after loading the view from its nib.
    
    // TODO: Remove this later when we have the properly fitting artwork
    self.view.clipsToBounds = YES;
}

- (void)viewDidUnload
{
    self.myPeopleTable = nil;
    
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
        Child *child = [children objectAtIndex:indexPath.row];
    
        if (!cellControllers[indexPath.row]) {
            cellControllers[indexPath.row] = [[MyPeopleCellController alloc] initWithNibName:@"MyPeopleCellController" bundle:nil];
            [cellControllers[indexPath.row] setMenuViewController:menuViewController];
        }
    
        cellControllers[indexPath.row].child = child;
        cellControllers[indexPath.row].row = indexPath.row;
    
        return cellControllers[indexPath.row].tableViewCell;
    }
}

#pragma mark -
#pragma mark AllChildResponse Methods
-(void)childrenRequestSuccess:(NSArray*)aChildren {
    @synchronized (cellControllersLock) {
        [aChildren retain];
        [children release];
        children = aChildren;
        
        MyPeopleCellController **newCellControllers = calloc([children count], sizeof(MyPeopleCellController*));
        for (int i = 0; i < cellControllersLen; i++) {
            if ([children count] > i) newCellControllers[i] = cellControllers[i];
            else [cellControllers[i] release];
        }
        free(cellControllers);
        cellControllersLen = [children count];
        cellControllers = newCellControllers;
        
        [myPeopleTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
}

-(void)requestFailure:(NSError*)error {
    
}

-(void)dealloc {
    for (int i = 0; i < cellControllersLen; i++) {
        [cellControllers[i] release];
    }
    free(cellControllers);
    [myPeopleTable release];
    [cellControllersLock release];
    
    [super dealloc];
}

@end
