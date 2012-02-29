//
//  QuartzBMMapView.m
//  BingMapsDemo
//
//  Created by Gregory Schmelter on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuartzMapView.h"

@interface _QuartzMapView : UIView <BMMapViewDelegate> {
    @private
    QuartzMapView *parent;
    BOOL regionIsChanging;
}

@property (assign, nonatomic) QuartzMapView *parent;

@end

@implementation QuartzMapView

@synthesize mapView;
@synthesize shapes;
@synthesize  delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        mapView = [[BMMapView alloc] initWithFrame:frame];
        mapView.userInteractionEnabled = YES;
        mapView.multipleTouchEnabled = YES;
        [self insertSubview:mapView atIndex:1];
        
        overlay = [[_QuartzMapView alloc] initWithFrame:frame];
        overlay.userInteractionEnabled = YES;
        overlay.multipleTouchEnabled = YES;
        overlay.parent = self;
        [self insertSubview:overlay atIndex:2];
        
        shapes = [[NSMutableArray alloc] init];
        
        mapView.delegate = overlay;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        mapView = [[BMMapView alloc] initWithCoder:aDecoder];
        mapView.userInteractionEnabled = YES;
        mapView.multipleTouchEnabled = YES;
        [self insertSubview:mapView atIndex:1];
        
        overlay = [[_QuartzMapView alloc] initWithCoder:aDecoder];
        overlay.userInteractionEnabled = YES;
        overlay.multipleTouchEnabled = YES;
        overlay.parent = self;
        [self insertSubview:overlay atIndex:2];
        
        shapes = [[NSMutableArray alloc] init];
        
        mapView.delegate = overlay;
    }
    return self;
}

-(void)addShape:(id<QuartzMapShape>)shape {
    [shapes addObject:shape];
}

-(void)removeShape:(id<QuartzMapShape>)shape {
    [shapes removeObject:shape];
}

-(void)dealloc {
    [mapView release];
    [overlay release];
    [shapes release];
    
    [super dealloc];
}

@end


@implementation _QuartzMapView

@synthesize parent;

-(_QuartzMapView*)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        regionIsChanging = NO;
    }
    return self;
}

-(_QuartzMapView*)initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        regionIsChanging = NO;
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    // Don't draw anything if the region is changing
    if (regionIsChanging) return;
    
    // Draw our shapes on top of the map
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSEnumerator *iter = [parent.shapes objectEnumerator];
    id<QuartzMapShape> shape = nil;
    while (shape = [iter nextObject]) {
        // Make sure the shape will display within the current mapView region
        CGRect shapeRect = [parent.mapView convertRegion:shape.region toRectToView:self];
        if ((shapeRect.origin.x < rect.origin.x + rect.size.width) && (shapeRect.origin.y < rect.origin.y + rect.size.height)
            && (shapeRect.origin.x + shapeRect.size.width > rect.origin.x) && (shapeRect.origin.y + shapeRect.size.height > rect.origin.y)) {
            // Make sure the shape is big enough to be worth drawing
            if (shapeRect.size.width > 5 && shapeRect.size.height > 5) {
                // Draw the shape
                [shape drawRect:shapeRect withContext:context];
            }
        }
    }
}

#pragma mark -
#pragma mark BMMapViewDelegate Methods
- (void)mapView:(BMMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    [parent.delegate mapView:mapView regionWillChangeAnimated:animated];
    regionIsChanging = YES;
    [self setNeedsDisplay];
}
- (void)mapView:(BMMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    regionIsChanging = NO;
    [self setNeedsDisplay];
    [parent.delegate mapView:mapView regionWillChangeAnimated:animated];
}
- (void)mapViewWillStartLoadingMap:(BMMapView *)mapView {
    //[parent.delegate mapViewWillStartLoadingMap:mapView];
    //regionIsChanging = YES;
    [self setNeedsDisplay];
}
- (void)mapViewDidFinishLoadingMap:(BMMapView *)mapView {
    //regionIsChanging = NO;
    //[self setNeedsDisplay];
    [parent.delegate mapViewDidFinishLoadingMap:mapView];
}
- (void)mapViewDidFailLoadingMap:(BMMapView *)mapView withError:(NSError *)error {
    [parent.delegate mapViewDidFailLoadingMap:mapView withError:error];
}
- (BMMarkerView *)mapView:(BMMapView *)mapView viewForMarker:(id <BMMarker>)marker {
    return [parent.delegate mapView:mapView viewForMarker:marker];
}
- (void)mapView:(BMMapView *)mapView didAddMarkerViews:(NSArray *)views {
    [parent.delegate mapView:mapView didAddMarkerViews:views];
}
- (void)mapView:(BMMapView *)mapView markerView:(BMMarkerView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [parent.delegate mapView:mapView markerView:view calloutAccessoryControlTapped:control];
}

#pragma mark -
#pragma mark UIResponder touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [parent.mapView touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [parent.mapView touchesMoved:touches withEvent:event];
    //[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [parent.mapView touchesEnded:touches withEvent:event];
    //[self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [parent.mapView touchesCancelled:touches withEvent:event];
}

@end
