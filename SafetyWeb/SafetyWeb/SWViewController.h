//
//  SWViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SWViewController : UIViewController {
    @protected
    UIViewController *rootViewController;
}

-(void)setRootViewController:(UIViewController*)rootViewController;

@end
