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

@end


@interface AlertCellController : UIViewController {
    @protected
    NSInteger row;
    id<Alert> alert;
    AlertsViewController *parentController;
}

@property (nonatomic) NSInteger row;
@property (nonatomic, retain) id<Alert> alert;
@property (nonatomic, assign) AlertsViewController *parentController;

-(void)expand;
-(void)contract;
-(CGFloat)expandedHeight;
-(BOOL)expandable;
-(UITableViewCell*)tableViewCell;

@end
