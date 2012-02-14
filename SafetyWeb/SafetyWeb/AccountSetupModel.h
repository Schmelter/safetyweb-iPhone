//
//  AccountSetupModel.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 * Represents all of the data necessary to setup a new account.
 */

#import <Foundation/Foundation.h>

#define kAttMobileServiceProvider       0
#define kVerizonMobileServiceProvider   1
#define kSprintMobileServiceProvider    2
#define kTMobileMobileServiceProvider   3

@interface AccountSetupModel : NSObject {
@private
    NSString *firstName, *lastName, *emailAddress, *password, *childFirstName, *childLastName, *childEmailAddress;
    NSDate *childBirthday;
    BOOL mobileAlerts;
    NSString *childsMobileNumber;
    NSInteger mobileServiceProvider;
    NSString *mobileUserId, *mobilePassword;
}

@property (retain, nonatomic) NSString *firstName;
@property (retain, nonatomic) NSString *lastName;
@property (retain, nonatomic) NSString *emailAddress;
@property (retain, nonatomic) NSString *password;
@property (retain, nonatomic) NSString *childFirstName;
@property (retain, nonatomic) NSString *childLastName;
@property (retain, nonatomic) NSString *childEmailAddress;
@property (retain, nonatomic) NSDate *childBirthday;
@property (nonatomic) BOOL mobileAlerts;
@property (retain, nonatomic) NSString *childsMobileNumber;
@property (nonatomic) NSInteger mobileServiceProvider;
@property (retain, nonatomic) NSString *mobileUserId;
@property (retain, nonatomic) NSString *mobilePassword;

@end
