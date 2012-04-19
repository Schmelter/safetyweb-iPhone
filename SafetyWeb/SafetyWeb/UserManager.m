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
static  NSString *lastUsedLogin;
static NSString *lastUsedPassword;
static NSString *lastUsedToken;

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
    
    currentUser = nil;
    lastUsedLogin = nil;
    lastUsedPassword = nil;
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (error != nil) {
#ifdef DEBUG
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#endif
    } else if (fetchedObjects != nil) {
        if ([fetchedObjects count] > 0) {
            User *user = [fetchedObjects objectAtIndex:0];
            
            // DO NOT use [self setCurrentUser:user] here as it will delete the user we just got out of the DB, which will
            // invalidate what we're trying to do here
            //[self setCurrentUser:user];
            currentUser = user;
            [currentUser retain];
            
            [self setLastUsedLogin:user.login];
            [self setLastUsedPassword:user.password];
        }
    }
    [fetchRequest release];
}

+ (void)setCurrentUser:(User *)aUser {
    [aUser retain];
    
    SWAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    if (currentUser != nil && [currentUser isInserted]) {
        [context deleteObject:currentUser];
    }
    
    [currentUser release];
    currentUser = aUser;
    
    if (currentUser != nil && ![currentUser isInserted]) {
        [context insertObject:currentUser];
    }
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
@synthesize responseBlock;

-(void)performRequest {
    void (^block)(void) = [^{
        @autoreleasepool {
            SafetyWebRequest *tokenRequest = [[SafetyWebRequest alloc] init];
            [tokenRequest request:@"GET" andURL:[NSURL URLWithString:[AppProperties getProperty:@"Endpoint_Login" withDefault:@"No API Endpoint"]] andParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.login, self.password, @"json", nil] forKeys:[NSArray arrayWithObjects:@"username", @"password", @"type", nil]] withCallback:self];
        
            [tokenRequest release];
        }
    } copy];
    dispatch_async([SWAppDelegate dataModelQ], block);
    
    [block release];
}

-(void)gotResponse:(id)aResponse {
    NSDictionary *responseDict = (NSDictionary*)aResponse;
    NSString* result = [responseDict objectForKey:@"result"];
    if ([result isEqualToString:@"OK"]) {
        responseBlock(YES, [responseDict objectForKey:@"token"], nil);
    } else {
        responseBlock(NO, nil, nil);
    }
    self.responseBlock = nil;
}
-(void)notGotResponse:(NSError *)aError {
    responseBlock(NO, nil, aError);
    self.responseBlock = nil;
}

-(void)dealloc {
    [login release];
    [password release];
    [responseBlock release];
    
    [super dealloc];
}

@end

@implementation UserRequest
@synthesize token;
@synthesize responseBlock;

-(void)performRequest {
    @synchronized([UserManager class]) {
        if (currentUser != nil) {
            NSLog(@"Time Interval Since Now: %f", [[currentUser userLastRequested]  timeIntervalSinceNow]);
            if ([currentUser.token isEqualToString:token] && [currentUser userLastRequested] != nil && [[currentUser userLastRequested] timeIntervalSinceNow] > -kTwoHourTimeInterval) {
                responseBlock(YES, currentUser, nil);
                self.responseBlock = nil;
                return;
            }
        }
    }
    void(^block)(void) = [^{
        @autoreleasepool {
            SafetyWebRequest *request = [[SafetyWebRequest alloc] init];
            [request request:@"GET" andURL:[NSURL URLWithString:[AppProperties getProperty:@"Endpoint_Children" withDefault:@"No API Endpoint"]] andParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:token, @"json", nil] forKeys:[NSArray arrayWithObjects:@"token", @"type", nil]] withCallback:self];
            [request release];
        }
    } copy];
    dispatch_async([SWAppDelegate dataModelQ], block);
    
    
    [block release];
}

-(void)gotResponse:(id)aResponse {
    NSDictionary *responseDict = (NSDictionary*)aResponse;
    NSString *result = [responseDict objectForKey:@"result"];
    if ([result isEqualToString:@"OK"]) {
        // Parse the response Dictionary
        @synchronized ([UserManager class]) {
            User *user = [UserManager initUserFromJson:responseDict withToken:token];
            responseBlock(YES, user, nil);
            [user release];
        }
    } else {
        responseBlock(NO, nil, nil);
    }
    self.responseBlock = nil;
}
-(void)notGotResponse:(NSError *)aError {
    responseBlock(NO, nil, aError);
    self.responseBlock = nil;
}

-(void)dealloc {
    [token release];
    [responseBlock release];
    
    [super dealloc];
}

@end
