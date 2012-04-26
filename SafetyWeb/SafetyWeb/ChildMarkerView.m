//
//  ChildMarkerView.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/24/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import "ChildMarkerView.h"
#import <QuartzCore/QuartzCore.h>

#define markerHeight 50.0
#define markerSmallWidth 50.0
#define markerLargeWidth 240.0
#define markerButtonSize 20.0
#define markerBorderSize 4.0

@implementation ChildMarkerView
@synthesize isExpanded;

-(ChildMarkerView*)initDefaultSize {
    return [self initWithFrame:CGRectMake(0.0,0.0,markerSmallWidth,markerHeight)];
}

-(ChildMarkerView*)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        @autoreleasepool {
            // Initialization code
            childImage = [[UIImageView alloc] initWithFrame:CGRectMake(markerBorderSize,markerBorderSize,markerSmallWidth-(2*markerBorderSize),markerSmallWidth-(2*markerBorderSize))];
            childImage.image = [UIImage imageNamed:@"butterfly.png"];
            [self addSubview:childImage];
            detailsButton = [[UIButton alloc] initWithFrame:CGRectMake(markerLargeWidth-markerBorderSize-markerButtonSize,(markerHeight*.5)-(markerButtonSize*.5),markerButtonSize,markerButtonSize)];
            [detailsButton setImage:[UIImage imageNamed:@"SettingsScreen_Arrow.png"] forState:UIControlStateNormal];
            detailsButton.hidden = YES;
            [self addSubview:detailsButton];
            
            childName = [[UILabel alloc] initWithFrame:CGRectMake(markerBorderSize + childImage.frame.origin.x + childImage.frame.size.width, markerBorderSize, detailsButton.frame.origin.x - (markerBorderSize + childImage.frame.origin.x + childImage.frame.size.width), childImage.frame.size.height/2)];
            childName.adjustsFontSizeToFitWidth = YES;
            childName.font = [UIFont boldSystemFontOfSize:13];
            childName.hidden = YES;
            childName.backgroundColor = [UIColor clearColor];
            childName.textColor = [UIColor whiteColor];
            [self addSubview:childName];
            childLocation = [[UILabel alloc] initWithFrame:CGRectMake(childName.frame.origin.x, childName.frame.origin.y+childName.frame.size.height,childName.frame.size.width,childName.frame.size.height)];
            childLocation.adjustsFontSizeToFitWidth = YES;
            childLocation.font = [UIFont systemFontOfSize:13];
            childLocation.hidden = YES;
            childLocation.backgroundColor = [UIColor clearColor];
            childLocation.textColor = [UIColor grayColor];
            [self addSubview:childLocation];
            
            isExpanded = NO;
            
            /*int insideHeight = (int)(frame.size.height * 0.90);
            int border = (int)((frame.size.height - insideHeight)/2);
            int imageWidth = (int)(insideHeight * 0.75);
            childImage = [[UIImageView alloc] initWithFrame:CGRectMake(border,border,imageWidth,insideHeight)];
            [self addSubview:childImage];
            
            detailsButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-(9+5),(frame.size.height/2)-10,9,21)];
            [detailsButton setBackgroundImage:[UIImage imageNamed:@"SettingsScreen_Arrow.png"] forState:UIControlStateNormal];
            [self addSubview:detailsButton];
            
            int labelLeft = border+imageWidth + 5;
            int labelWidth = detailsButton.frame.origin.x;
            childName = [[UILabel alloc] initWithFrame:CGRectMake(labelLeft, border, labelWidth, ([[UIFont boldSystemFontOfSize:14] pointSize] * (92/76))+1)];
            childLocation = [[UILabel alloc] initWithFrame:CGRectMake(labelLeft, border+childName.frame.size.height+border, labelWidth, ([[UIFont systemFontOfSize:14] pointSize] * (92/76))+1)]; */
            
            self.backgroundColor = [UIColor whiteColor];
            self.layer.masksToBounds = YES;
            
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        @autoreleasepool {
            // Initialization code
            childImage = [[UIImageView alloc] initWithFrame:CGRectMake(markerBorderSize,markerBorderSize,markerSmallWidth-(2*markerBorderSize),markerSmallWidth-(2*markerBorderSize))];
            childImage.image = [UIImage imageNamed:@"butterfly.png"];
            [self addSubview:childImage];
            detailsButton = [[UIButton alloc] initWithFrame:CGRectMake(markerLargeWidth-markerBorderSize-markerButtonSize,(markerHeight*.5)-(markerButtonSize*.5),markerButtonSize,markerButtonSize)];
            [detailsButton setImage:[UIImage imageNamed:@"SettingsScreen_Arrow.png"] forState:UIControlStateNormal];
            detailsButton.hidden = YES;
            [self addSubview:detailsButton];
            
            childName = [[UILabel alloc] initWithFrame:CGRectMake(markerBorderSize + childImage.frame.origin.x + childImage.frame.size.width, markerBorderSize, detailsButton.frame.origin.x - (markerBorderSize + childImage.frame.origin.x + childImage.frame.size.width), childImage.frame.size.height/2)];
            childName.adjustsFontSizeToFitWidth = YES;
            childName.font = [UIFont boldSystemFontOfSize:13];
            childName.hidden = YES;
            childName.backgroundColor = [UIColor clearColor];
            childName.textColor = [UIColor whiteColor];
            [self addSubview:childName];
            childLocation = [[UILabel alloc] initWithFrame:CGRectMake(childName.frame.origin.x, childName.frame.origin.y+childName.frame.size.height,childName.frame.size.width,childName.frame.size.height)];
            childLocation.adjustsFontSizeToFitWidth = YES;
            childLocation.font = [UIFont systemFontOfSize:13];
            childLocation.hidden = YES;
            childLocation.backgroundColor = [UIColor clearColor];
            childLocation.textColor = [UIColor grayColor];
            [self addSubview:childLocation];
            
            isExpanded = NO;
            
            /*CGRect frame = self.frame;
            
            int insideHeight = (int)(frame.size.height * 0.90);
            int border = (int)((frame.size.height - insideHeight)/2);
            int imageWidth = (int)(insideHeight * 0.75);
            childImage = [[UIImageView alloc] initWithFrame:CGRectMake(border,border,imageWidth,insideHeight)];
            [self addSubview:childImage];
            
            detailsButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-(9+5),(frame.size.height/2)-10,9,21)];
            [detailsButton setBackgroundImage:[UIImage imageNamed:@"SettingsScreen_Arrow.png"] forState:UIControlStateNormal];
            [self addSubview:detailsButton];
            
            int labelLeft = border+imageWidth + 5;
            int labelWidth = detailsButton.frame.origin.x;
            childName = [[UILabel alloc] initWithFrame:CGRectMake(labelLeft, border, labelWidth, ([[UIFont boldSystemFontOfSize:14] pointSize] * (92/76))+1)];
            childLocation = [[UILabel alloc] initWithFrame:CGRectMake(labelLeft, border+childName.frame.size.height+border, labelWidth, ([[UIFont systemFontOfSize:14] pointSize] * (92/76))+1)];*/
            
            self.backgroundColor = [UIColor whiteColor];
            self.layer.masksToBounds = YES;
        }
    }
    return self;
}

-(CGRect)getContractedFrame {
    return CGRectMake(0,0,markerSmallWidth,markerHeight);
}

-(CGRect)getExpandedFrame {
    return CGRectMake(0,0,markerLargeWidth,markerHeight);
}

#pragma mark -
#pragma mark Expand and Contract code
-(void)setExpanded:(BOOL)aExpanded animated:(BOOL)animated {
    if (aExpanded == isExpanded) return;
    isExpanded = aExpanded;
    
    void (^animationBlock)(void) = ^{
        if (animated) {
            [UIView beginAnimations:@"ChildMarkerViewAnimation" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
        }
        
        if (isExpanded) {
            // Show the additional content, and expand the frame
            childName.hidden = NO;
            childLocation.hidden = NO;
            detailsButton.hidden = NO;
            self.frame = CGRectMake(0,0,markerLargeWidth,markerHeight);
        } else {
            // Hide the additional content, and contract the frame
            childName.hidden = YES;
            childLocation.hidden = YES;
            detailsButton.hidden = YES;
            self.frame = CGRectMake(0,0,markerSmallWidth,markerHeight);
        }
    };
    
    if (animated) [UIView animateWithDuration:0.5 animations:animationBlock];
    else animationBlock();
}

#pragma mark -
#pragma mark Property setters and getters
-(void)setChildName:(NSString*)aChildName {
    childName.text = aChildName;
}

-(void)setChildLocation:(NSString*)aChildLocation {
    childLocation.text = aChildLocation;
}

-(void)setChildImage:(UIImage*)aChildImage {
    childImage.image = aChildImage;
}

-(BOOL)isDetailButtonLayer:(CALayer*)aSubLayer {
    CALayer *layer = detailsButton.layer;
    if (layer == aSubLayer) return YES;
    for (CALayer *subLayer in [layer sublayers]) {
        if (subLayer == aSubLayer) return YES;
    }
    return NO;
}

-(void)dealloc {
    [childName release];
    [childLocation release];
    [childImage release];
    [detailsButton release];
    
    [super dealloc];
}

@end
