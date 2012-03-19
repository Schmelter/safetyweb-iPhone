//
//  MyPeopleViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "MyPeopleCellController.h"

@interface MyPeopleViewController : SubMenuViewController <UITableViewDelegate, UITableViewDataSource> {
    @private
    MyPeopleCellController** cellControllers;
    NSInteger cellControllersLen;   
}

@end
