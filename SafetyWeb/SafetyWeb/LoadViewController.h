//
//  LoadViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "LoadView.h"

@interface LoadViewController : SubRootViewController {
    @private
    UILabel *tipLabel;
    LoadView *loadProgress;
    NSTimer *timer;
    CGFloat progress;
}

@property (nonatomic, retain) IBOutlet UILabel *tipLabel;
@property (nonatomic, retain) IBOutlet LoadView *loadProgress;

@end
