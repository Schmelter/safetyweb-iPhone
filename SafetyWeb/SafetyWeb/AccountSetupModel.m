//
//  AccountSetupModel.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountSetupModel.h"

@implementation AccountSetupModel

@synthesize firstName;
@synthesize lastName;
@synthesize emailAddress;
@synthesize password;
@synthesize childFirstName;
@synthesize childLastName;
@synthesize childEmailAddress;
@synthesize childBirthday;
@synthesize mobileAlerts;
@synthesize mobileServiceProvider;
@synthesize childsMobileNumber;
@synthesize mobileUserId;
@synthesize mobilePassword;

-(void)dealloc {
    [firstName release];
    [lastName release];
    [emailAddress release];
    [password release];
    [childFirstName release];
    [childLastName release];
    [childEmailAddress release];
    [childBirthday release];
    [childsMobileNumber release];
    [mobileUserId release];
    [mobilePassword release];
    
    [super dealloc];
}

@end
