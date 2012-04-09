//
//  CheckInViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "ChildManager.h"
#import "CheckInCellController.h"

@interface CheckInViewController : SubMenuViewController <UITableViewDelegate, UITableViewDataSource, AllChildResponse> {
    @private
    CheckInCellController** cellControllers;
    NSInteger cellControllersLen;
    
    NSArray *children;
    NSObject *cellControllersLock;
    
    UITableView *checkInTable;
}

@property (nonatomic, retain) IBOutlet UITableView *checkInTable;

-(IBAction)announcePressed:(id)sender;

@end
