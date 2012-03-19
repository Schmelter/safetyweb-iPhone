//
//  MyPeopleViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyPeopleViewController.h"

@implementation MyPeopleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        cellControllersLen = [[ChildManager getAllChildren] count];
        cellControllers = calloc(cellControllersLen, sizeof(MyPeopleCellController*));
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
    return [[ChildManager getAllChildren] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Child *child = [[ChildManager getAllChildren] objectAtIndex:indexPath.row];
    
    if (!cellControllers[indexPath.row]) {
        cellControllers[indexPath.row] = [[MyPeopleCellController alloc] initWithNibName:@"MyPeopleCellController" bundle:nil];
    }
    
    cellControllers[indexPath.row].child = child;
    cellControllers[indexPath.row].row = indexPath.row;
    [cell addSubview:cellControllers[indexPath.row].view];
    
    return cell;
}

-(void)dealloc {
    for (int i = 0; i < cellControllersLen; i++) {
        [cellControllers[i] release];
    }
    free(cellControllers);
    
    [super dealloc];
}

@end
