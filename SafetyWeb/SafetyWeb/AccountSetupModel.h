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

@interface AccountSetupModel : NSObject {
@private
    NSString *firstName, *lastName, *emailAddress, *password, *childFirstName, *childLastName, *childEmailAddress;
    NSDate *childBirthday;
}

@property (retain, nonatomic) NSString *firstName;
@property (retain, nonatomic) NSString *lastName;
@property (retain, nonatomic) NSString *emailAddress;
@property (retain, nonatomic) NSString *password;
@property (retain, nonatomic) NSString *childFirstName;
@property (retain, nonatomic) NSString *childLastName;
@property (retain, nonatomic) NSString *childEmailAddress;
@property (retain, nonatomic) NSDate *childBirthday;

@end
