//
//  AlertsViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlertsViewController.h"
#import "FacebookAlert.h"
#import "FacebookAlertCellController.h"
#import "SMSAlert.h"
#import "SMSAlertCellController.h"
#import "CheckInAlert.h"
#import "CheckInAlertCellController.h"

@implementation AlertsViewController
@synthesize alertsTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        cellControllersLen = 0;
        cellControllers = nil;
        alertLoadLock = [[NSObject alloc] init];
    }
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Show the first 10 results to begin with
    AlertRangeRequest *request = [[AlertRangeRequest alloc] init];
    request.range = NSMakeRange(0, kDefaultAlertsShown);
    request.response = self;
    [AlertManager requestAlertsWithinRange:request];
    [request release];
    
    // TODO: Remove this later when we have the properly fitting artwork
    self.view.clipsToBounds = YES;
}

- (void)viewDidUnload {
    self.alertsTable = nil;
    
    [super viewDidUnload];
}

#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDataSource Methods
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @synchronized(alertLoadLock) {        
        id<Alert> alert = (id<Alert>)[alerts objectAtIndex:indexPath.row];
        if (!cellControllers[indexPath.row]) {
            // Need to build the cell controller based on the alert type
            // We could be doing this with a factory, but we just don't have enough alert types to justify that
            if ([alert isKindOfClass:[FacebookAlert class]]) {
                cellControllers[indexPath.row] = [[FacebookAlertCellController alloc] initWithNibName:@"FacebookAlertCellController" bundle:nil];
            } else if ([alert isKindOfClass:[SMSAlert class]]) {
                cellControllers[indexPath.row] = [[SMSAlertCellController alloc] initWithNibName:@"SMSAlertCellController" bundle:nil];
            } else if ([alert isKindOfClass:[CheckInAlert class]]) {
                cellControllers[indexPath.row] = [[CheckInAlertCellController alloc] initWithNibName:@"CheckInAlertCellController" bundle:nil];
            }
        }
        
        cellControllers[indexPath.row].row = indexPath.row;
        cellControllers[indexPath.row].alert = alert;
        cellControllers[indexPath.row].parentController = self;
        
        return cellControllers[indexPath.row].tableViewCell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @synchronized(alertLoadLock) {
        return cellControllersLen;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    @synchronized(alertLoadLock) {
        if (!cellControllers[indexPath.row]) return 70;
        else return [cellControllers[indexPath.row] heightForRow];
    }
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [cellControllers[indexPath.row] willSelect];
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //index = indexPath.row;
    [tableView beginUpdates];
    [tableView endUpdates];      
}

-(NSIndexPath*)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [cellControllers[indexPath.row] willDeselect];
    return indexPath;
}

#pragma mark -
#pragma mark AlertRangeResponse Methods
-(void)receiveResponse:(NSArray*)aAlerts forRange:(NSRange)range {
    // We just got all new alerts, so add them to our array
    @synchronized(alertLoadLock) {
        AlertCellController** newCellControllers = calloc(range.length + cellControllersLen, sizeof(AlertCellController*));
        for (int i = 0; i < cellControllersLen; i++) {
            newCellControllers[i] = cellControllers[i];
        }  
        free(cellControllers);
        cellControllersLen = range.length + cellControllersLen;
        cellControllers = newCellControllers;
        
        [aAlerts retain];
        [alerts release];
        alerts = aAlerts;
        // It's one or the other of the following
//        [alertsTable reloadData];
        [alertsTable layoutSubviews];
    }
}

-(void)dealloc {
    if (cellControllers) {
        for (int i = 0; i < cellControllersLen; i++) {
            [cellControllers[i] release];
        }
        free(cellControllers);
    }
    [alertsTable release];
    [alerts release];
    [alertLoadLock release];
    
    [super dealloc];
}

@end


@implementation AlertCellController
@synthesize row;
@synthesize alert;
@synthesize parentController;

-(AlertCellController*)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)willSelect { }

-(void)willDeselect { }

-(CGFloat)heightForRow {
    return 70;
}

-(UITableViewCell*)tableViewCell {
    return (UITableViewCell*) self.view;
}

-(void)dealloc {
    [alert release];
    
    [super dealloc];
}

@end
