//
//  MyPlacesMarker.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/24/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "RMMarker.h"
#import "ImageCacheManager.h"
#import "ChildMarkerView.h"
#import "Child.h"

@class ChildMarker;

@protocol ChildMarkerDelegate <NSObject>
-(void)childDetailsPressed:(ChildMarker*)aMarker ForData:(id)aData;
@end

// We need to extend the RMMarker in order to have our own child marker floating around
// on the map.

@interface ChildMarker : RMMarker <RMMovingMapLayer, CachedImage> {
    @private
    ChildMarkerView *childMarkerView;
    BOOL isExpanded;
    id<ChildMarkerDelegate> delegate;
}

@property (nonatomic, readonly) BOOL isExpanded;
@property (nonatomic, assign) id<ChildMarkerDelegate> delegate;

-(void)setExpanded:(BOOL)expanded animated:(BOOL)animated;
-(void)markerPressed:(CALayer*)subLayer;
-(void)setChildData:(Child*)child;

@end
