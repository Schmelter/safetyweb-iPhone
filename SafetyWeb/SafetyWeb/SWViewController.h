//
//  SWViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface SWViewController : UIViewController {
    @protected
    RootViewController *rootViewController;
}

-(void)setRootViewController:(RootViewController*)rootViewController;

@end
