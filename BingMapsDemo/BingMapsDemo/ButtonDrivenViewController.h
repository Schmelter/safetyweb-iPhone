//
//  ButtonDrivenViewController.h
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BingMaps/BingMaps.h>

@interface BMCustomEntity : BMEntity {
@private
    
}
-(void)showDetails:(id)sender;
@end

@interface ButtonDrivenViewController : UIViewController <BMMapViewDelegate> {
    @private
    BMMapView *mapView;
    
    BMEntity *momLoc;
    BMEntity *dadLoc;
    BMEntity *childLoc;
    
    UIButton *zoomToggle;
    UIButton *dragToggle;
}

@property (retain, nonatomic) IBOutlet BMMapView *mapView;
@property (retain, nonatomic) IBOutlet UIButton *zoomToggle;
@property (retain, nonatomic) IBOutlet UIButton *dragToggle;

-(IBAction)momPressed:(id)sender;
-(IBAction)dadPressed:(id)sender;
-(IBAction)childPressed:(id)sender;
-(IBAction)zoomPressed:(id)sender;
-(IBAction)zoomTogglePressed:(id)sender;
-(IBAction)dragTogglePressed:(id)sender;

@end
