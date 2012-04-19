//
//  CheckInAlertViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/17/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "CheckInAlert.h"
#import "RMMapView.h"
#import "ImageCacheManager.h"

@interface CheckInAlertViewController : SubRootViewController <RMMapViewDelegate, CachedImage> {
    @private
    CheckInAlert *alert;
    
    UIImageView *childImage;
    UILabel *childName;
    UILabel *locationStr;
    UILabel *locationApproved;
    UILabel *timeMessage;
    
    RMMapView *mapView;
}

@property (nonatomic, retain) CheckInAlert *alert;
@property (nonatomic, retain) IBOutlet UIImageView *childImage;
@property (nonatomic, retain) IBOutlet UILabel *childName;
@property (nonatomic, retain) IBOutlet UILabel *locationStr;
@property (nonatomic, retain) IBOutlet UILabel *locationApproved;
@property (nonatomic, retain) IBOutlet UILabel *timeMessage;
@property (nonatomic, retain) IBOutlet RMMapView *mapView;

-(IBAction)backPressed:(id)sender;

@end
