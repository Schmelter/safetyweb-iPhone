//
//  MyPlacesViewControllerViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/23/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMMapView.h"
#import "ChildMarker.h"
#import "MenuViewController.h"

@interface MyPlacesViewController : SubMenuViewController <RMMapViewDelegate, ChildMarkerDelegate> {
    @private
    RMMapView *mapView;
    dispatch_queue_t mySpacesQ;
    
    UITextField *locationSearch;
}

@property (nonatomic, retain) IBOutlet RMMapView *mapView;
@property (nonatomic, retain) IBOutlet UITextField *locationSearch;

-(IBAction)locationSearchButtonPressed:(id)sender;

@end
