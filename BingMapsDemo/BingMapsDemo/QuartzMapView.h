//
//  QuartzBMMapView.h
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BingMaps/BingMaps.h>
#import "QuartzMapShape.h"

@class _QuartzMapView;

@interface QuartzMapView : UIView {
    @private
    BMMapView *mapView;
    _QuartzMapView *overlay;
    NSMutableArray *shapes;
    id<BMMapViewDelegate> delegate;
}

-(void)addShape:(id<QuartzMapShape>)shape;
-(void)removeShape:(id<QuartzMapShape>)shape;

@property (readonly, nonatomic) BMMapView *mapView;
@property (readonly, nonatomic) NSArray *shapes;
@property (assign, nonatomic) id<BMMapViewDelegate> delegate;

@end
