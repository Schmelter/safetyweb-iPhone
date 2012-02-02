//
//  LoginManager.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserManager.h"

static UserManager* instance;

@implementation UserManager

- (UserManager*)init {
    @synchronized([UserManager class]) {
        if (instance == nil) {
            instance = self;
        } else {
            [self release];
        }
    }
    return instance;
}

+ (UserManager*)getInstance {
    if (instance == nil) instance = [[UserManager alloc] init];
    return instance;
}

- (void)dealloc {
    [super dealloc];
}

@end
