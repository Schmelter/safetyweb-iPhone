//
//  MyPlacesViewControllerViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/23/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMMapView.h"
#import "MenuViewController.h"

@interface MyPlacesViewController : SubMenuViewController <RMMapViewDelegate> {
    RMMapView *mapView;
    dispatch_queue_t mySpacesQ;
}

@property (nonatomic, retain) IBOutlet RMMapView *mapView;

@end
