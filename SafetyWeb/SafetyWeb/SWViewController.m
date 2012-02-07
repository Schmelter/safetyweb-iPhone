//
//  SWViewController.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWViewController.h"

@implementation SWViewController

-(void)setRootViewController:(RootViewController*)aRootViewController {
    // Do not retain, this is our parent
    rootViewController = aRootViewController;
}

-(void)dealloc {
    // DO NOT release the rootViewController, it's our parent, and we never retained it
    
    [super dealloc];
}

@end
