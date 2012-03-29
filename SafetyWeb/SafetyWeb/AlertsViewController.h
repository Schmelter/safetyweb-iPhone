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

@class AlertCellController;

@interface AlertsViewController : SubMenuViewController <UITableViewDelegate, UITableViewDataSource, AlertRangeResponse> {
    @private
    NSInteger cellControllersLen;
    AlertCellController** cellControllers;
    NSArray *alerts;
    
    UITableView *alertsTable;
    NSObject *alertLoadLock;
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

-(void)willSelect;
-(void)willDeselect;
-(CGFloat)heightForRow;
-(UITableViewCell*)tableViewCell;

@end
