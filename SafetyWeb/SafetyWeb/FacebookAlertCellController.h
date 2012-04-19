//
//  FacebookAlertCellController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/28/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertsViewController.h"
#import "FacebookAlert.h"
#import "ChildManager.h"
#import "Utilities.h"

@interface FacebookAlertCellController : AlertCellController {
    @private
    UILabel *childName;
    UILabel *friendName;
    UILabel *alertMessage;
    UILabel *timeMessage;
    
    UIImageView *backgroundImage;
}

@property (nonatomic, retain) IBOutlet UILabel *childName;
@property (nonatomic, retain) IBOutlet UILabel *friendName;
@property (nonatomic, retain) IBOutlet UILabel *alertMessage;
@property (nonatomic, retain) IBOutlet UILabel *timeMessage;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;

-(IBAction)detailPressed:(id)sender;

@end
