//
//  ChildsActivityViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWViewController.h"
#import "Utilities.h"

#define kYourEmailRow   0
#define kChildsEmailRow 1

@interface ChildsActivityViewController : SWViewController <UITableViewDelegate, UITableViewDataSource> {
    @private
    UITextField *yourEmailAddress;
    UITextField *childsEmailAddress;
}

@property (retain, nonatomic) IBOutlet UITextField *yourEmailAddress;
@property (retain, nonatomic) IBOutlet UITextField *childsEmailAddress;

-(IBAction)seeChildsActivity:(id)sender;
-(IBAction)backgroundTap:(id)sender;

@end
