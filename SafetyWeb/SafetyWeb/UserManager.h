//
//  LoginManager.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 * The UserManager exists to persist and track the most recent credentials used to login,
 * login to the SafetyWeb service, and store the data we know about the user.
 */

#import <Foundation/Foundation.h>
#import "AppProperties.h"
#import "User.h"
#import "SafetyWebRequest.h"

#define kTwoHourTimeInterval    7200

typedef void (^TokenResponseBlock)(BOOL, NSString*, NSError*);
typedef void (^UserResponseBlock)(BOOL, User*, NSError*);

@interface TokenRequest : NSObject <SafetyWebRequestCallback> {
@private
    NSString *login;
    NSString *password;
    TokenResponseBlock responseBlock;
}
@property (nonatomic, retain) NSString *login;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, copy) TokenResponseBlock responseBlock;

-(void)performRequest;
@end

@interface UserRequest : NSObject <SafetyWebRequestCallback> {
@private
    NSString *token;
    UserResponseBlock responseBlock;
}
@property (nonatomic, retain) NSString *token;
@property (nonatomic, copy) UserResponseBlock responseBlock;

-(void)performRequest;
@end

@interface UserManager : NSObject {
}

+ (User*)getCurrentUser;
+ (void)setCurrentUser:(User*)aUser;

// May return nil if there were no last used credentials.  No guarantee that the credentials will work.
+ (NSString*)getLastUsedLogin;
+ (void)setLastUsedLogin:(NSString*)aLogin;
+ (NSString*)getLastUsedPassword;
+ (void)setLastUsedPassword:(NSString*)aPassword;
+ (NSString*)getLastUsedToken;
+ (void)setLastUsedToken:(NSString*)aToken;

@end
