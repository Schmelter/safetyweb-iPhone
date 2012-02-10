//
//  ChildsActivityViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RootViewController.h"
#import "Utilities.h"

#define kYourEmailRow   0
#define kChildsEmailRow 1

@interface ChildsActivityViewController : SubRootViewController <UITableViewDelegate, UITableViewDataSource> {
    @private
    UITextField *yourEmailAddress;
    UITextField *childsEmailAddress;
    UITableView *childInfoTable;
}

@property (retain, nonatomic) IBOutlet UITextField *yourEmailAddress;
@property (retain, nonatomic) IBOutlet UITextField *childsEmailAddress;
@property (retain, nonatomic) IBOutlet UITableView *childInfoTable;

-(IBAction)seeChildsActivity:(id)sender;
-(IBAction)backgroundTap:(id)sender;
-(IBAction)backButton:(id)sender;

@end
