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
#import "QuartzMapLine.h"
#import "QuartzMapPolygon.h"

@class _QuartzMapView;

@interface QuartzMapView : UIView {
    @private
    BMMapView *mapView;
    _QuartzMapView *overlay;
    id<BMMapViewDelegate> delegate;
}

-(void)addShape:(id<QuartzMapShape>)shape;
-(void)removeShape:(id<QuartzMapShape>)shape;

-(void)startDrawing:(UIColor*)lineColor withWidth:(double)lineWidth;
-(void)stopDrawing:(UIColor*)fillColor;

@property (readonly, nonatomic) BMMapView *mapView;
@property (assign, nonatomic) id<BMMapViewDelegate> delegate;

@end
