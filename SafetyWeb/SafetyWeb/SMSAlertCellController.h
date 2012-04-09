//
//  SMSAlertCellController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/29/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertManager.h"
#import "AlertsViewController.h"
#import "SMSAlert.h"
#import "ChildManager.h"
#import "Utilities.h"

@interface SMSAlertCellController : AlertCellController <ChildResponse> {
    @private
    UILabel *childName;
    UILabel *messagePhoneNumber;
    UILabel *timeMessage;
    
    UIImageView *backgroundImage;
}

@property (nonatomic, retain) IBOutlet UILabel *childName;
@property (nonatomic, retain) IBOutlet UILabel *messagePhoneNumber;
@property (nonatomic, retain) IBOutlet UILabel *timeMessage;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;

@end
