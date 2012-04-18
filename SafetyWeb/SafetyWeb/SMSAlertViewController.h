//
//  SMSAlertViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/17/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSAlert.h"
#import "RootViewController.h"
#import "ImageCacheManager.h"

@interface SMSAlertViewController : SubRootViewController <ChildResponse, CachedImage> {
    @private
    SMSAlert *alert;
    
    UIImageView *childImage;
    UILabel *childName;
    UILabel *messagePhoneNumber;
    UILabel *timeMessage;
    UIButton *callChildBtn;
    UIButton *messageChildBtn;
}

@property (nonatomic, retain) SMSAlert *alert;
@property (nonatomic, retain) IBOutlet UIImageView *childImage;
@property (nonatomic, retain) IBOutlet UILabel *childName;
@property (nonatomic, retain) IBOutlet UILabel *messagePhoneNumber;
@property (nonatomic, retain) IBOutlet UILabel *timeMessage;
@property (nonatomic, retain) IBOutlet UIButton *callChildBtn;
@property (nonatomic, retain) IBOutlet UIButton *messageChildBtn;

-(IBAction)ignoreThisAlertPressed:(id)sender;
-(IBAction)messageChildPressed:(id)sender;
-(IBAction)callChildPressed:(id)sender;
-(IBAction)contactPolicePressed:(id)sender;
-(IBAction)backPressed:(id)sender;

@end
