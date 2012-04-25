//
//  MyPlacesMarker.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/24/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "ChildMarker.h"

#define defaultMarkerAnchorPoint CGPointMake(0.5, 0.5)

@implementation ChildMarker
@synthesize isExpanded;

-(ChildMarker*)init {
    self = [super init];
    if (self) {
        childMarkerView = [[ChildMarkerView alloc] initDefaultSize];
        
        self.anchorPoint = defaultMarkerAnchorPoint;
        
        [childMarkerView.layer removeFromSuperlayer];
        NSLog(@"Super Layer: %i", self);
        NSLog(@"Layer: %i", childMarkerView.layer);
        [self insertSublayer:childMarkerView.layer below:self];
        self.masksToBounds = YES;
        
    }
    return self;
}

-(void)setExpanded:(BOOL)expanded animated:(BOOL)animated {
    if (isExpanded == expanded) return;
    isExpanded = expanded;
    
    if (animated) {
        [UIView beginAnimations:@"ChildMarkerAnimation" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    
    if (isExpanded) {
        // Calculate the difference in the frame, to determine the proper anchor point
        float heightCenter = childMarkerView.frame.size.height * 0.5;
        float widthCenter = childMarkerView.frame.size.width * 0.5;
        
        [childMarkerView setExpanded:isExpanded animated:animated];
        
        float heightAnchor = heightCenter / childMarkerView.frame.size.height;
        float widthAnchor = widthCenter / childMarkerView.frame.size.width;
        
        self.anchorPoint = CGPointMake(widthAnchor, heightAnchor);
    } else {
        [childMarkerView setExpanded:isExpanded animated:animated];
        self.anchorPoint = CGPointMake(0.5, 0.5);
    }
    
    [childMarkerView.layer removeFromSuperlayer];
    NSLog(@"Super Layer: %i", self);
    NSLog(@"Layer: %i", childMarkerView.layer);
    [self insertSublayer:childMarkerView.layer below:self];
    self.bounds = childMarkerView.frame;
    
    if (animated) {
        [UIView commitAnimations];
    }
}

-(void)setChildData:(Child*)child {
    [childMarkerView setChildName:[NSString stringWithFormat:@"%@ %@", child.firstName, child.lastName]];
    [childMarkerView setChildLocation:@"Test Child Location"];
    [childMarkerView setBackgroundColor:UIColorFromRGB([child.color intValue])];
    ImageCacheManager *imageCacheManager = [[ImageCacheManager alloc] init];
    [imageCacheManager requestImage:self ForUrl:child.profilePicUrl];
    [ImageCacheManager release];
    
}

#pragma mark -
#pragma CachedImage Methods
-(void)setImage:(UIImage*)imageData {
    [childMarkerView setChildImage:imageData];
    [childMarkerView.layer removeFromSuperlayer];
    [childMarkerView drawRect:childMarkerView.frame];
    NSLog(@"Super Layer: %i", self);
    NSLog(@"Layer: %i", childMarkerView.layer);
    [self insertSublayer:childMarkerView.layer below:self];
    //self.contents = (id)[imageData CGImage];
	self.bounds = childMarkerView.frame;
}

-(BOOL)expires {
    return YES;
}

-(void)dealloc {
    [childMarkerView release];
    
    [super dealloc];
}

@end
