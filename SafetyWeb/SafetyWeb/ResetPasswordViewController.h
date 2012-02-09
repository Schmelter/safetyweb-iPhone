//
//  ResetPasswordViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SWViewController.h"
#import "Utilities.h"

@interface ResetPasswordViewController : SWViewController {
    @private
    UITextField *emailAddress;
}

@property (retain, nonatomic) IBOutlet UITextField *emailAddress;

-(IBAction)backgroundTap:(id)sender;
-(IBAction)emailGoButton:(id)sender;
-(IBAction)backButton:(id)sender;

@end
