//
//  DrawViewController.h
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BingMaps/BingMaps.h>
#import "QuartzMapView.h"

@interface DrawViewController : UIViewController {
    @private
    QuartzMapView *mapView;
    UIButton *drawButton;
    UIButton *editButton;
    BOOL drawing;
    BOOL editing;
}

@property (retain, nonatomic) IBOutlet QuartzMapView *mapView;
@property (retain, nonatomic) IBOutlet UIButton *drawButton;
@property (retain, nonatomic) IBOutlet UIButton *editButton;

-(IBAction)drawPressed:(id)sender;
-(IBAction)editPressed:(id)sender;

@end
