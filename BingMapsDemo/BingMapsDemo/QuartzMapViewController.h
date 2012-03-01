//
//  QuartzMapViewController.h
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzMapView.h"
#import "QuartzMapLine.h"
#import "QuartzMapCircle.h"
#import "QuartzMapPolygon.h"

@interface QuartzMapViewController : UIViewController {
    @private
    QuartzMapView *mapView;
    
}

@property (retain, nonatomic) IBOutlet QuartzMapView *mapView;

@end
