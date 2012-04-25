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

// We need to extend the RMMarker in order to have our own child marker floating around
// on the map.

@interface ChildMarker : RMMarker <RMMovingMapLayer, CachedImage> {
    @private
    ChildMarkerView *childMarkerView;
    BOOL isExpanded;
}

@property (nonatomic, readonly) BOOL isExpanded;

-(void)setExpanded:(BOOL)expanded animated:(BOOL)animated;
-(void)setChildData:(Child*)child;

@end
