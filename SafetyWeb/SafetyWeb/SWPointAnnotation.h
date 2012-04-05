//
//  SWPointAnnotation.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/5/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

// Because iOS 3.0 doesn't have the very simple MKPointAnnotation class, we need
// to re-create it here...

@interface SWPointAnnotation : NSObject <MKAnnotation> {
    @private
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
