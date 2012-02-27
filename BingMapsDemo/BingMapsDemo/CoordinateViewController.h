//
//  CoordinateViewController.h
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BingMaps.h"

@interface CoordinateViewController : UIViewController <BMMapViewDelegate, UITextFieldDelegate> {
    @private
    BMMapView *mapView;
    UITextField *latitude;
    UITextField *longitude;
}

@property (nonatomic, retain) IBOutlet BMMapView *mapView;
@property (nonatomic, retain) IBOutlet UITextField *latitude;
@property (nonatomic, retain) IBOutlet UITextField *longitude;

-(IBAction)viewButtonPressed:(id)sender;
-(IBAction)backgroundTap:(id)sender;

@end
