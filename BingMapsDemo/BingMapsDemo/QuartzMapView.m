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
    NSMutableArray *drawLines;
    UIColor *lineColor;
    double lineWidth;
    NSMutableArray *shapes;
    CGPoint lastDrawPoint;
}

@property (assign, nonatomic) QuartzMapView *parent;
@property (retain, nonatomic) NSMutableArray *drawLines;
@property (readonly, nonatomic) NSMutableArray *shapes;

-(void)startDrawing:(UIColor*)aLineColor withWidth:(double)aLineWidth;
-(void)stopDrawing:(UIColor*)aFillColor;

-(void)startEditing;
-(void)stopEditing;

@end

@implementation QuartzMapView

@synthesize mapView;
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
        
        mapView.delegate = overlay;
    }
    return self;
}

-(void)addShape:(id<QuartzMapShape>)shape {
    [overlay.shapes addObject:shape];
}

-(void)removeShape:(id<QuartzMapShape>)shape {
    [overlay.shapes removeObject:shape];
}

-(void)startDrawing:(UIColor *)lineColor withWidth:(double)lineWidth {
    [overlay startDrawing:lineColor withWidth:lineWidth];
}

-(void)stopDrawing:(UIColor *)fillColor {
    [overlay stopDrawing:fillColor];
}

-(void)startEditing {
    [overlay startEditing];
}

-(void)stopEditing {
    [overlay stopEditing];
}

-(void)dealloc {
    [mapView release];
    [overlay release];
    
    [super dealloc];
}

@end


@implementation _QuartzMapView

@synthesize parent;
@synthesize drawLines;
@synthesize shapes;

-(_QuartzMapView*)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        regionIsChanging = NO;
        drawLines = nil;
        shapes = [[NSMutableArray alloc] initWithCapacity:10];
        lastDrawPoint = CGPointMake(-9999, -9999);
    }
    return self;
}

-(_QuartzMapView*)initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        regionIsChanging = NO;
        drawLines = nil;
        shapes = [[NSMutableArray alloc] initWithCapacity:10];
        lastDrawPoint = CGPointMake(-9999, -9999);
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    // Don't draw anything if the region is changing
    if (regionIsChanging) return;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Draw our shapes on top of the map
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSEnumerator *iter = [shapes objectEnumerator];
    id<QuartzMapShape> shape = nil;
    while (shape = [iter nextObject]) {
        // Make sure the shape will display within the current mapView region
        CGRect shapeRect = [parent.mapView convertRegion:shape.region toRectToView:self];
        if ((shapeRect.origin.x < rect.origin.x + rect.size.width) && (shapeRect.origin.y < rect.origin.y + rect.size.height)
            && (shapeRect.origin.x + shapeRect.size.width > rect.origin.x) && (shapeRect.origin.y + shapeRect.size.height > rect.origin.y)) {
            // Make sure the shape is big enough to be worth drawing
            if (shapeRect.size.width > 5 || shapeRect.size.height > 5) {
                // Draw the shape
                [shape drawRect:shapeRect withContext:context];
            }
        }
        
        CLLocationCoordinate2D *pointArr;
        int pointCount = [shape qmPoints:&pointArr];
        for (int i = 0; i < pointCount; i++) {
            NSLog(@"Shape Lat: %f Long: %f", pointArr[i].latitude, pointArr[i].longitude);
        }
        free(pointArr);
    }
    
    // Draw our draw lines on the map
    iter = [drawLines objectEnumerator];
    QuartzMapLine *drawLine = nil;
    while (drawLine = [iter nextObject]) {
        // Make sure the shape will display within the current mapView region
        CGRect lineRect = [parent.mapView convertRegion:drawLine.region toRectToView:self];
        if ((lineRect.origin.x < rect.origin.x + rect.size.width) && (lineRect.origin.y < rect.origin.y + rect.size.height)
            && (lineRect.origin.x + lineRect.size.width > rect.origin.x) && (lineRect.origin.y + lineRect.size.height > rect.origin.y)) {
            // Make sure the shape is big enough to be worth drawing
            if (lineRect.size.width > 5 || lineRect.size.height > 5) {
                // Draw the shape
                [drawLine drawRect:lineRect withContext:context];
            }
        }
        
        CLLocationCoordinate2D *pointArr;
        int pointCount = [shape qmPoints:&pointArr];
        for (int i = 0; i < pointCount; i++) {
            NSLog(@"DrawLine Lat: %f Long: %f", pointArr[i].latitude, pointArr[i].longitude);
        }
        free(pointArr);
    }
    
    [pool release];
}

#pragma mark -
#pragma mark Draw Functions
-(void)startDrawing:(UIColor*)aLineColor withWidth:(double)aLineWidth {
    if (drawLines != nil) {
        // Clear out the old drawlines
        NSEnumerator *iter = [drawLines objectEnumerator];
        QuartzMapLine *line = nil;
        while (line = [iter nextObject]) {
            [shapes removeObject:line];
        }
    }
    
    NSMutableArray *newDrawLines = [[NSMutableArray alloc] initWithCapacity:10];
    self.drawLines = newDrawLines;
    [newDrawLines release];
    
    [aLineColor retain];
    [lineColor release];
    lineColor = aLineColor;
    
    lineWidth = aLineWidth;
    lastDrawPoint = CGPointMake(-9999, -9999);
    
    parent.mapView.zoomEnabled = NO;
    parent.mapView.scrollEnabled = NO;
}

-(void)stopDrawing:(UIColor*)aFillColor {
    // Connect the lines to make a polygon, and use the fill color, then add it to shapes
    if (drawLines == nil) return;
    if ([drawLines count] <= 1) {
        self.drawLines = nil;
        return;
    }
    
    QuartzMapPolygon *polygon = [[QuartzMapPolygon alloc] init];
    polygon.lineWidth = lineWidth;
    polygon.lineColor = lineColor;
    polygon.fillColor = aFillColor;
    
    NSEnumerator *iter = [drawLines objectEnumerator];
    QuartzMapLine *drawLine = nil;
    QuartzMapLine *lastLine = nil;
    while (drawLine = [iter nextObject]) {
        [polygon addPoint:drawLine.lineStart];
        lastLine = drawLine;
    }
    // Need to add the endpoint of the last line
    [polygon addPoint:lastLine.lineEnd];
    
    [shapes addObject:polygon];
    [polygon release];
    
    
    self.drawLines = nil;
    parent.mapView.zoomEnabled = YES;
    parent.mapView.scrollEnabled = YES;
    [self setNeedsDisplay];
}

-(void)addDrawPoint:(CGPoint)cgPoint {
    if (lastDrawPoint.x == -9999 && lastDrawPoint.y == -9999) {
        lastDrawPoint = cgPoint;
        return;
    }
    
    // This is not the first point, create a line for the point
    QuartzMapLine *drawLine = [[QuartzMapLine alloc] init];
    drawLine.lineWidth = lineWidth;
    drawLine.lineColor = lineColor;
    drawLine.lineStart = [parent.mapView convertPoint:lastDrawPoint toCoordinateFromView:self];
    drawLine.lineEnd = [parent.mapView convertPoint:cgPoint toCoordinateFromView:self];
    
    [drawLines addObject:drawLine];
    [drawLine release];
    
    lastDrawPoint = cgPoint;
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Editing Functions
-(void)startEditing {
    
}

-(void)stopEditing {
    
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
    [parent.delegate mapViewWillStartLoadingMap:mapView];
    [self setNeedsDisplay];
}
- (void)mapViewDidFinishLoadingMap:(BMMapView *)mapView {
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
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [parent.mapView touchesEnded:touches withEvent:event];
    if (drawLines != nil) {
        // They're done touching, add a point
        UITouch *end = [[event allTouches] anyObject];
        CGPoint cgPoint = [end locationInView:self];
        [self addDrawPoint:cgPoint];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [parent.mapView touchesCancelled:touches withEvent:event];
}

-(void)dealloc {
    [lineColor release];
    [drawLines release];
    [shapes release];
    
    [super dealloc];
}

@end
