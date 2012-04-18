//
//  FacebookAlertViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/17/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

/**
 *  This is the view for the Facebook Alert when it's pressed from the AlertsView
 */

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "FacebookAlert.h"
#import "Utilities.h"
#import "ImageCacheManager.h"

@interface FacebookAlertViewController : SubRootViewController <ChildResponse, CachedImage> {
    @private
    FacebookAlert *alert;
    
    UIImageView *childImage;
    UILabel *childName;
    UILabel *friendName;
    UILabel *alertMessage;
    UILabel *timeMessage;
    UIButton *callChildBtn;
    UIButton *messageChildBtn;
}

@property (nonatomic, retain) FacebookAlert *alert;
@property (nonatomic, retain) IBOutlet UIImageView *childImage;
@property (nonatomic, retain) IBOutlet UILabel *childName;
@property (nonatomic, retain) IBOutlet UILabel *friendName;
@property (nonatomic, retain) IBOutlet UILabel *alertMessage;
@property (nonatomic, retain) IBOutlet UILabel *timeMessage;
@property (nonatomic, retain) IBOutlet UIButton *callChildBtn;
@property (nonatomic, retain) IBOutlet UIButton *messageChildBtn;

-(IBAction)ignoreThisAlertPressed:(id)sender;
-(IBAction)messageChildPressed:(id)sender;
-(IBAction)callChildPressed:(id)sender;
-(IBAction)contactPolicePressed:(id)sender;
-(IBAction)backPressed:(id)sender;

@end
