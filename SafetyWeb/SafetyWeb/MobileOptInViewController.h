//
//  MobileOptInViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountSetupViewController.h"

@interface MobileOptInViewController : SubAccountSetupViewController {
    
}

-(IBAction)yesMobileAlerts:(id)sender;
-(IBAction)noMobileAlerts:(id)sender;
-(IBAction)backButton:(id)sender;

@end
