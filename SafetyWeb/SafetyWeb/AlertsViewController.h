//
//  AlertsViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "AlertManager.h"

#define kDefaultAlertsShown 10
#define kTableHeight 416

@class AlertCellController;

@interface AlertsViewController : SubMenuViewController <UITableViewDelegate, UITableViewDataSource, AlertRangeResponse> {
    @private
    NSInteger cellControllersLen;
    AlertCellController** cellControllers;
    NSMutableArray *alerts;
    
    UITableView *alertsTable;
    NSObject *alertLoadLock;
    
    NSMutableSet *selectedRowSet;
    NSInteger animatedRow;
    NSMutableSet *animatedOutSet;
}

@property (nonatomic, retain) IBOutlet UITableView *alertsTable;

-(MenuViewController*)getMenuViewController;

@end


@interface AlertCellController : UIViewController {
    @protected
    NSInteger row;
    Alert *alert;
    AlertsViewController *alertsViewController;
}

@property (nonatomic) NSInteger row;
@property (nonatomic, retain) Alert *alert;
@property (nonatomic, assign) AlertsViewController *alertsViewController;

-(void)expand;
-(void)contract;
-(CGFloat)expandedHeight;
-(BOOL)expandable;
-(UITableViewCell*)tableViewCell;

@end
