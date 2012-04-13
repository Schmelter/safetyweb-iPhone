//
//  LoginManager.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserManager.h"
#import "SWAppDelegate.h"

static User* currentUser;
static NSString *lastUsedLogin;
static NSString *lastUsedPassword;
static NSString *lastUsedToken;

@interface TokenRequest () {
    @private
    id<TokenResponse> response;
}
@property (nonatomic, retain) id<TokenResponse> response;
@end

@interface UserRequest () {
    @private
    id<UserResponse> response;
}
@property (nonatomic, retain) id<UserResponse> response;
@end

@interface UserManager (PrivateMethods)
+(User*)initUserFromJson:(NSDictionary*)userJson withToken:(NSString*)token;
@end

@implementation UserManager

- (UserManager*)init {
    // This is a purely static class
    [self release];
    return nil;
}

+(void)initialize {
    SWAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // Build an NSFetchRequest that will get us the one User we should have stored from last time.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [self setCurrentUser:nil];
    [self setLastUsedLogin:nil];
    [self setLastUsedPassword:nil];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (error != nil) {
#ifdef DEBUG
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#endif
    } else if (fetchedObjects != nil) {
        if ([fetchedObjects count] > 0) {
            User *user = [fetchedObjects objectAtIndex:0];
            [self setCurrentUser:user];
            
            [self setLastUsedLogin:user.login];
            [self setLastUsedPassword:user.password];
        }
    }
    [fetchRequest release];
}

+(void)requestToken:(TokenRequest*)request withResponse:(id<TokenResponse>)response {
    request.response = response;
    [request performSelectorInBackground:@selector(performRequest) withObject:nil];
}

+(void)requestUser:(UserRequest*)request withResponse:(id<UserResponse>)response{
    request.response = response;
    [request performSelectorInBackground:@selector(performRequest) withObject:nil];
}

+ (void)setCurrentUser:(User *)aUser {
    [aUser retain];
    
    SWAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    if (currentUser != nil) [context deleteObject:currentUser];
    
    [currentUser release];
    currentUser = aUser;
    
    if (currentUser != nil) [context insertObject:currentUser];
}

+ (User*)getCurrentUser {
    return currentUser;
}

+ (void)setLastUsedLogin:(NSString *)aLogin {
    [aLogin retain];
    [lastUsedLogin release];
    lastUsedLogin = aLogin;
}

+ (NSString*)getLastUsedLogin {
    return lastUsedLogin;
}

+ (void)setLastUsedPassword:(NSString *)aPassword {
    [aPassword retain];
    [lastUsedPassword release];
    lastUsedPassword = aPassword;
}

+ (NSString*)getLastUsedPassword {
    return lastUsedPassword;
}

+ (NSString*)getLastUsedToken {
    return lastUsedToken;
}

+ (void)setLastUsedToken:(NSString*)aToken {
    [aToken retain];
    [lastUsedToken release];
    lastUsedToken = aToken;
}

+(User*)initUserFromJson:(NSDictionary*)userJson withToken:(NSString*)token {
    if (userJson == nil) {
        return nil;
    }
    
    @autoreleasepool {
        NSManagedObjectContext *context = ((SWAppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
        
        User *newUser = [[User alloc] initWithEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
        newUser.token = token;
        newUser.userLastRequested = [NSDate date];
        
        NSDictionary *childrenDict = [userJson objectForKey:@"children"];
        if (childrenDict == nil) return newUser;
        NSObject *childObj = [childrenDict objectForKey:@"child"];
        if ([childObj isKindOfClass:[NSArray class]]) {
            // Multiple children
            for (NSDictionary *jsonChildDict in (NSArray*)childObj) {
                Child *child = [ChildManager initChildFromJson:jsonChildDict];
                
                [newUser addChildrenObject:child];
                [child release];
            }
        } else if ([childObj isKindOfClass:[NSDictionary class]]) {
            // Only one child
            NSDictionary *jsonChildDict = (NSDictionary*)childObj;
            Child *child = [ChildManager initChildFromJson:jsonChildDict];
            
            [newUser addChildrenObject:child];
        }
        
        return newUser;
    }
}

- (void)dealloc {
    [super dealloc];
}

@end

@implementation TokenRequest
@synthesize login;
@synthesize password;
@synthesize response;

-(void)performRequest {
    @autoreleasepool {
        SafetyWebRequest *tokenRequest = [[SafetyWebRequest alloc] init];
        [tokenRequest request:@"GET" andURL:[NSURL URLWithString:[AppProperties getProperty:@"Endpoint_Login" withDefault:@"No API Endpoint"]] andParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:login, password, @"json", nil] forKeys:[NSArray arrayWithObjects:@"username", @"password", @"type", nil]] withCallback:self];
        
        [tokenRequest release];
    }
}

-(void)gotResponse:(id)aResponse {
    NSDictionary *responseDict = (NSDictionary*)aResponse;
    NSString* result = [responseDict objectForKey:@"result"];
    if ([result isEqualToString:@"OK"]) {
        [response tokenRequestSuccess:[responseDict objectForKey:@"token"]];
    } else {
        [response requestFailure:nil];
    }
    self.response = nil;
}
-(void)notGotResponse:(NSError *)aError {
    [response requestFailure:aError];
    self.response = nil;
}

-(void)dealloc {
    [login release];
    [password release];
    [response release];
    
    [super dealloc];
}

@end

@implementation UserRequest
@synthesize token;
@synthesize response;

-(void)performRequest {
    @autoreleasepool {
        @synchronized([UserManager class]) {
            if (currentUser != nil) {
                NSLog(@"Time Interval Since Now: %f", [[currentUser userLastRequested]  timeIntervalSinceNow]);
                if ([currentUser.token isEqualToString:token] && [currentUser userLastRequested] != nil && [[currentUser userLastRequested] timeIntervalSinceNow] > -kTwoHourTimeInterval) {
                    [response userRequestSuccess:currentUser];
                    self.response = nil;
                    return;
                }
            }
        }
        
        SafetyWebRequest *request = [[SafetyWebRequest alloc] init];
        [request request:@"GET" andURL:[NSURL URLWithString:[AppProperties getProperty:@"Endpoint_Children" withDefault:@"No API Endpoint"]] andParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:token, @"json", nil] forKeys:[NSArray arrayWithObjects:@"token", @"type", nil]] withCallback:self];
        [request release];
    }
}

-(void)gotResponse:(id)aResponse {
    NSDictionary *responseDict = (NSDictionary*)aResponse;
    NSString *result = [responseDict objectForKey:@"result"];
    if ([result isEqualToString:@"OK"]) {
        // Parse the response Dictionary
        @synchronized ([UserManager class]) {
            User *user = [UserManager initUserFromJson:responseDict withToken:token];
            [response userRequestSuccess:user];
            [user release];
        }
    } else {
        [response requestFailure:nil];
    }
    self.response = nil;
}
-(void)notGotResponse:(NSError *)aError {
    [response requestFailure:aError];
    self.response = nil;
}

-(void)dealloc {
    [token release];
    [response release];
    
    [super dealloc];
}

@end
