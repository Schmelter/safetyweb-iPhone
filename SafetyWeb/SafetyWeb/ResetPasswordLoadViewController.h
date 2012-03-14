//
//  ResetPasswordLoadViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadViewController.h"
#import "SafetyWebRequest.h"

@interface ResetPasswordLoadViewController : LoadViewController {
    @private
    NSString *emailAddress;
}

@property (nonatomic, retain) NSString* emailAddress;

@end
