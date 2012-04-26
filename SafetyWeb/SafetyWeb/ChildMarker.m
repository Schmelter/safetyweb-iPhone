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
@synthesize delegate;

-(ChildMarker*)init {
    self = [super init];
    if (self) {
        childMarkerView = [[ChildMarkerView alloc] initDefaultSize];
        
        self.anchorPoint = defaultMarkerAnchorPoint;
        
        [childMarkerView.layer removeFromSuperlayer];
        [self insertSublayer:childMarkerView.layer below:self];
        self.masksToBounds = YES;
        
    }
    return self;
}

-(void)setExpanded:(BOOL)expanded animated:(BOOL)animated {
    if (isExpanded == expanded) return;
    isExpanded = expanded;
    
    /*float anchorX;
    float anchorY;
    if (isExpanded) {
        CGRect expandedFrame = [childMarkerView getExpandedFrame];
        CGRect contractedFrame = [childMarkerView getContractedFrame];
        
        float slideX = (expandedFrame.size.width - contractedFrame.size.width) / 2;
        anchorX = (slideX / contractedFrame.size.width);
        float slideY = (expandedFrame.size.height - contractedFrame.size.height) / 2;
        anchorY = (slideY / contractedFrame.size.height);
    } else {
        CGRect expandedFrame = [childMarkerView getExpandedFrame];
        CGRect contractedFrame = [childMarkerView getContractedFrame];
        
        float slideX = -(expandedFrame.size.width - contractedFrame.size.width) / 2;
        anchorX = (slideX / contractedFrame.size.width);
        float slideY = -(expandedFrame.size.height - contractedFrame.size.height) / 2;
        anchorY = (slideY / contractedFrame.size.height);
    }
    
    void(^slide)(void) = ^{
        self.anchorPoint = CGPointMake(self.anchorPoint.x + anchorX, self.anchorPoint.y + anchorY);
    };*/
    
    void(^resize)(void) = ^{
        [childMarkerView setExpanded:isExpanded animated:NO];
        //self.anchorPoint = CGPointMake(0.5 + anchorX,0.5 + anchorY);
        self.bounds = childMarkerView.frame;
    };
    
    resize();
    
    
   /* void(^slideLeft)(void) = ^{
        NSLog(@"Slide Left");
        CGRect expandedFrame = [childMarkerView getExpandedFrame];
        CGRect contractedFrame = [childMarkerView getContractedFrame];
        
        float slideX = (expandedFrame.size.width - contractedFrame.size.width) / 2;
        float anchorX = (slideX / contractedFrame.size.width) + 0.5;
        float slideY = (expandedFrame.size.height - contractedFrame.size.height) / 2;
        float anchorY = (slideY / contractedFrame.size.height) + 0.5;
        self.anchorPoint = CGPointMake(anchorX, anchorY);
    };
    
    void(^slideRight)(void) = ^{
        NSLog(@"Slide Right");
        CGRect expandedFrame = [childMarkerView getExpandedFrame];
        CGRect contractedFrame = [childMarkerView getContractedFrame];
        
        float slideX = (contractedFrame.size.width - expandedFrame.size.width) / 2;
        float anchorX = (slideX / expandedFrame.size.width) + 0.5;
        float slideY = (contractedFrame.size.height - expandedFrame.size.height) / 2;
        float anchorY = (slideY / expandedFrame.size.height) + 0.5;
        self.anchorPoint = CGPointMake(anchorX, anchorY);
    };
    
    
    void(^resize)(void) = ^{
        [childMarkerView setExpanded:isExpanded animated:NO];
        self.anchorPoint = CGPointMake(0.5,0.5);
        self.bounds = childMarkerView.frame;
    };
    
    
    if (isExpanded) {
        if (animated) {
            [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionOverrideInheritedDuration|UIViewAnimationOptionCurveEaseInOut animations:slideLeft completion:^(BOOL finished){
                NSLog(@"Animation complete 1!");
                [UIView animateWithDuration:2.0 delay:2.0 options:0 animations:resize completion:^(BOOL finished){
                    NSLog(@"Animation complete 2!");
                }];
            }];
        } else {
            slideLeft();
            resize();
        }
    } else {
        if (animated) {
            [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionOverrideInheritedDuration|UIViewAnimationOptionCurveEaseInOut animations:resize completion:^(BOOL finished){
                NSLog(@"Animation complete 1!");
                [UIView animateWithDuration:2.0 delay:2.0 options:0 animations:slideRight completion:^(BOOL finished){
                    NSLog(@"Animation complete 2!");
                }];
            }];
        } else {
            slideRight();
            resize();
        }
    } */
    
    /*if (animated) {
        [UIView beginAnimations:@"ChildMarkerAnimation" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    
    CGRect previousFrame = childMarkerView.frame;
    
    [childMarkerView setExpanded:isExpanded animated:animated];
    
    [childMarkerView.layer removeFromSuperlayer];
    [self insertSublayer:childMarkerView.layer below:self];
    self.bounds = childMarkerView.frame;
    
    if (isExpanded) {
        // Calculate the difference in the frame, to determine the proper anchor point
        float heightCenter = previousFrame.size.height * 0.5;
        float widthCenter = previousFrame.size.width * 0.5;
        
        float heightAnchor = heightCenter / childMarkerView.frame.size.height;
        float widthAnchor = widthCenter / childMarkerView.frame.size.width;
        
        self.anchorPoint = CGPointMake(widthAnchor, heightAnchor);
    } else {
        self.anchorPoint = CGPointMake(0.5, 0.5);
    }
    
    if (animated) {
        [UIView commitAnimations];
    }*/
}

-(void)setChildData:(Child*)child {
    [childMarkerView setChildName:[NSString stringWithFormat:@"%@ %@", child.firstName, child.lastName]];
    [childMarkerView setChildLocation:child.address];
    [childMarkerView setBackgroundColor:UIColorFromRGB([child.color intValue])];
    ImageCacheManager *imageCacheManager = [[ImageCacheManager alloc] init];
    [imageCacheManager requestImage:self ForUrl:child.profilePicUrl];
    [ImageCacheManager release];
    
}

-(void)markerPressed:(CALayer*)subLayer {
    if ([childMarkerView isDetailButtonLayer:subLayer]) [delegate childDetailsPressed:self ForData:self.data];
    else [self setExpanded:!isExpanded animated:YES];
}

#pragma mark -
#pragma CachedImage Methods
-(void)setImage:(UIImage*)imageData {
    [childMarkerView setChildImage:imageData];
    [childMarkerView.layer removeFromSuperlayer];
    [childMarkerView drawRect:childMarkerView.frame];
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
