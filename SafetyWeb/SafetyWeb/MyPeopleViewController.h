//
//  MyPeopleViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "MenuViewController.h"
#import "MyPeopleCellController.h"

@interface MyPeopleViewController : SubMenuViewController <UITableViewDelegate, UITableViewDataSource, UserResponse> {
    @private
    MyPeopleCellController** cellControllers;
    NSInteger cellControllersLen;
    
    User *user;
    NSObject *cellControllersLock;
    
    UITableView *myPeopleTable;
}

@property (nonatomic, retain) IBOutlet UITableView *myPeopleTable;

@end
