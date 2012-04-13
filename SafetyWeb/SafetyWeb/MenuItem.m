//
//  MenuItem.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

@synthesize animationDuration;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isSelected = NO;
        
        leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:leftImageView];
        
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        textLabel.textAlignment = UITextAlignmentLeft;
        textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:textLabel];
        
        self.clipsToBounds = YES;  // We need to clip here so that we can setup the sliding in image
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        isSelected = NO;
        
        leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:leftImageView];
        
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        textLabel.textAlignment = UITextAlignmentLeft;
        textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:textLabel];
        
        self.clipsToBounds = YES;  // We need to clip here so that we can setup the sliding in image
    }
    return self;
}

#pragma mark -
#pragma mark Property Getters and Setters

-(UIImage*)leftImage {
    return leftImage;
}

-(void)setLeftImage:(UIImage *)aLeftImage {
    [aLeftImage retain];
    [leftImage release];
    leftImage = aLeftImage;
    
    if (isSelected) {
        leftImageView.frame = CGRectMake(0, (self.frame.size.height/2) - (leftImage.size.height/2), leftImage.size.width, leftImage.size.height);
        textLabel.frame = CGRectMake(leftImageView.frame.size.width, 0, self.frame.size.width - leftImageView.frame.size.width, self.frame.size.height);
    } else {
        leftImageView.frame = CGRectMake(-(leftImage.size.width), (self.frame.size.height/2) - (leftImage.size.height/2), leftImage.size.width, leftImage.size.height);
        textLabel.frame = CGRectMake(0, 0, self.frame.size.width - leftImageView.frame.size.width, self.frame.size.height);
    }
    leftImageView.image = leftImage;
}

-(UIFont*)fontUnselected {
    return fontUnselected;
}

-(void)setFontUnselected:(UIFont *)aFontUnselected {
    [aFontUnselected retain];
    [fontUnselected release];
    fontUnselected = aFontUnselected;
    if (!isSelected) {
        textLabel.font = fontUnselected;
    }
}

-(UIColor*)textColorUnselected {
    return textColorUnselected;
}

-(void)setTextColorUnselected:(UIColor *)aTextColorUnselected {
    [aTextColorUnselected retain];
    [textColorUnselected release];
    textColorUnselected = aTextColorUnselected;
    if (!isSelected) {
        textLabel.textColor = textColorUnselected;
    }
}

-(NSString*)textUnselected {
    return textUnselected;
}

-(void)setTextUnselected:(NSString *)aTextUnselected {
    [aTextUnselected retain];
    [textUnselected release];
    textUnselected = aTextUnselected;
    if (!isSelected) {
        textLabel.text = textUnselected;
    }
}

-(UIFont*)fontSelected {
    return fontSelected;
}

-(void)setFontSelected:(UIFont *)aFontSelected {
    [aFontSelected retain];
    [fontSelected release];
    fontSelected = aFontSelected;
    if (isSelected) {
        textLabel.font = fontSelected;
    }
}

-(UIColor*)textColorSelected {
    return textColorSelected;
}

-(void)setTextColorSelected:(UIColor *)aTextColorSelected {
    [aTextColorSelected retain];
    [textColorSelected release];
    textColorSelected = aTextColorSelected;
    if (isSelected) {
        textLabel.textColor = textColorSelected;
    }
}

-(NSString*)textSelected {
    return textSelected;
}

-(void)setTextSelected:(NSString *)aTextSelected {
    [aTextSelected retain];
    [textSelected release];
    textSelected = aTextSelected;
    if (isSelected) {
        textLabel.text = textSelected;
    }
}

-(void)setSelected:(BOOL)aSelected animated:(BOOL)animated {
    if (aSelected == isSelected) return;
    isSelected = aSelected;
    
    if (animated && animationDuration > 0.0) {
        [UIView beginAnimations:@"MenuItemAnimation" context:nil];
        [UIView setAnimationDuration:animationDuration];
    }
    
    // TODO: http://stackoverflow.com/questions/1420131/iphone-text-glow-effect
    // Consider adding a glow effect to the text when pressed
    // Don't forget to check that the phone has the feature to handle it
    
    if (isSelected) {
        // Size the image and place it flush with the left
        leftImageView.frame = CGRectMake(0, (self.frame.size.height/2) - (leftImage.size.height/2), leftImage.size.width, leftImage.size.height);
        leftImageView.image = leftImage;
        
        textLabel.frame = CGRectMake(leftImageView.frame.size.width, 0, self.frame.size.width - leftImageView.frame.size.width, self.frame.size.height);
        textLabel.font = fontSelected;
        textLabel.textColor = textColorSelected;
        textLabel.text = textSelected;
    } else {
        // Don't need to show the image, so use it all for text
        leftImageView.frame = CGRectMake(-(leftImage.size.width), (self.frame.size.height/2) - (leftImage.size.height/2), leftImage.size.width, leftImage.size.height);
        leftImageView.image = leftImage;
        textLabel.frame = CGRectMake(0, 0, self.frame.size.width - leftImageView.frame.size.width, self.frame.size.height);
        textLabel.font = fontUnselected;
        textLabel.textColor = textColorUnselected;
        textLabel.text = textUnselected;
    }
    
    if (animated && animationDuration > 0.0) {
        [UIView commitAnimations];
    }
}

-(void)dealloc {
    [textLabel release];
    [leftImageView release];
    
    [leftImage release];
    [fontUnselected release];
    [textColorUnselected release];
    [fontSelected release];
    [textColorSelected release];
    
    [super dealloc];
}

@end
