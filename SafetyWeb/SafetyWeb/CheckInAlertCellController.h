//
//  CheckInAlertCellController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/29/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AlertsViewController.h"
#import "ChildManager.h"
#import "Utilities.h"
#import "CheckInAlert.h"

@interface CheckInAlertCellController : AlertCellController <MKMapViewDelegate> {
    @private
    UILabel *childName;
    UILabel *locationStr;
    UILabel *locationApproved;
    UILabel *timeMessage;
    
    UIImageView *backgroundImage;
    
    MKMapView *mapView;
}

@property (nonatomic, retain) IBOutlet UILabel *childName;
@property (nonatomic, retain) IBOutlet UILabel *locationStr;
@property (nonatomic, retain) IBOutlet UILabel *locationApproved;
@property (nonatomic, retain) IBOutlet UILabel *timeMessage;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@end
