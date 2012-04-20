//
//  AreaManager.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/20/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "AreaManager.h"
#import "SWPolygonArea.h"
#import "SWPolygonPoint.h"
#import "SwCircleArea.h"
#import "SWAppDelegate.h"

// TODO: Replace most of this when we're actually hitting the server
static NSMutableArray *fakeAreas;

@implementation AreasForChildRequest
@synthesize user;
@synthesize childId;
@synthesize responseBlock;

-(void)performRequest {
    usleep(1000000); // 1 seconds
    responseBlock(YES, fakeAreas, nil);
    [responseBlock release];
}

-(void)dealloc {
    [user release];
    [childId release];
    [responseBlock release];
    
    [super dealloc];
}
@end


@implementation AreaForIdRequest
@synthesize user;
@synthesize areaId;
@synthesize responseBlock;

-(void)performRequest {
    // TODO: Implement this if necessary.  It may never be necessary.
}

-(void)dealloc {
    [user release];
    [areaId release];
    [responseBlock release];
    
    [super dealloc];
}
@end


@implementation AreaManager

-(AreaManager*)init {
    // This is a purely static class
    [self release];
    return nil;
}

+(void)generateFakePolygon:(int)yLength withXLength:(int[])xLength withLats:(float**)lats withLongs:(float**)longs {
    @autoreleasepool {
        NSManagedObjectContext *context = ((SWAppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
        for (int y = 0; y < yLength; y++) {
            SWPolygonArea *polyArea = [[SWPolygonArea alloc] initWithEntity:[NSEntityDescription entityForName:@"SWPolygonArea" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
            
            for (int x = 0; x < xLength[y]; x++) {
                SWPolygonPoint *polyPoint = [[SWPolygonPoint alloc] initWithEntity:[NSEntityDescription entityForName:@"SWPolygonPoint"  inManagedObjectContext:context] insertIntoManagedObjectContext:context];
                polyPoint.latitude = [NSNumber numberWithFloat:lats[y][x]];
                polyPoint.longitude = [NSNumber numberWithFloat:longs[y][x]];
                polyPoint.order = [NSNumber numberWithInt:x];
                [polyArea addPointsObject:polyPoint];
                [polyPoint release];
            }
            
            [fakeAreas addObject:polyArea];
            [polyArea release];
        }
    }
}

+(void)generateFakeCircles:(int)length withLats:(float[])lats withLongs:(float[])longs withRadiuses:(float[])radiuses {
    @autoreleasepool {
        NSManagedObjectContext *context = ((SWAppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
        for (int i = 0; i < length; i++) {
            SWCircleArea *circleArea = [[SWCircleArea alloc] initWithEntity:[NSEntityDescription entityForName:@"SWCircleArea" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
            
            SWPoint *point = [[SWPoint alloc] initWithEntity:[NSEntityDescription entityForName:@"SWPoint" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
            point.latitude = [NSNumber numberWithFloat:lats[i]];
            point.longitude = [NSNumber numberWithFloat:longs[i]];
            circleArea.centerPoint = point;
            circleArea.radius = [NSNumber numberWithFloat:radiuses[i]];
            [point release];
            
            [fakeAreas addObject:circleArea];
            [circleArea release];
        }
    }
}

+(void)initialize {
    fakeAreas = [[NSMutableArray alloc] initWithCapacity:10];
    
    @autoreleasepool {
        
        // Create 3 Polygon areas
        [AreaManager generateFakePolygon:3 withXLength:(int[]){ 4, 4, 5 } 
         withLats:
         (float**)(float[3][5]){ 
            {39.565272030475526, 39.564577275270075, 39.55743081773468, 39.55882046437182},
            {39.5312539399828, 39.52526264678086, 39.525494363862606, 39.531088441588935}, 
            {39.55425437801845, 39.547735603527485, 39.5373109097461, 39.53774116618218, 39.54766941993515} }
                               
         withLongs:
         (float**)(float[3][5]){
            {-104.87977981567383, -104.86926555633545, -104.86767768859863, -104.87943649291992},
            {-104.87432956695557, -104.87299919128418, -104.86557483673096, -104.86330032348633},
            {-104.8978042602539, -104.9035120010376, -104.89995002746582, -104.88952159881592, -104.88651752471924} }
         ];
        
        // Create 3 circe areas
        [AreaManager generateFakeCircles:3 
         withLats:
         (float[3]){39.55210358104467, 39.54275511185004, 39.56704197061533} 
         withLongs:
         (float[3]){-104.91733074188232, -104.85420227050781, -104.90286827087402} 
         withRadiuses:
         (float[3]){0.005, 0.004, 0.006}];
    }
}

-(void)dealloc {
    [super dealloc];
}
@end
