//
//  SettingsViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MenuViewController.h"
#import "UserManager.h"

@interface SettingsViewController : SubMenuViewController <UITableViewDelegate, UITableViewDataSource> {
    @private
    UITableView *settingsTable;
    UIButton *accountLoginBtn;
}

@property (nonatomic, retain) IBOutlet UITableView *settingsTable;
@property (nonatomic, retain) IBOutlet UIButton *accountLoginBtn;

-(IBAction)accountLoginPressed:(id)sender;
-(IBAction)inviteOthersPressed:(id)sender;

@end
