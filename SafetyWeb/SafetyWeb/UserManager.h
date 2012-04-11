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

@interface TokenRequest : NSObject <SafetyWebRequestCallback> {
@private
    NSString *login;
    NSString *password;
}
@property (nonatomic, retain) NSString *login;
@property (nonatomic, retain) NSString *password;
@end

@protocol TokenResponse <NSObject>
-(void)tokenRequestSuccess:(NSString*)token;
-(void)requestFailure:(NSError*)error;
@end

@interface UserManager : NSObject {
}

+(void)requestToken:(TokenRequest*)request withResponse:(id<TokenResponse>)response;

// May return nil if there were no last used credentials.  No guarantee that the credentials will work.
+ (User*)getLastUsedCredentials;
+ (void)setLastUsedCredentials:(User*)aCredentials;

@end
