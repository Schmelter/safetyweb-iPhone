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
@protected
    UILabel *tipLabel;
    LoadView *progressView;
}

@property (nonatomic, retain) IBOutlet UILabel *tipLabel;
@property (nonatomic, retain) IBOutlet LoadView *progressView;

@end