//
//  NetworkManager.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 4/27/12.
//  Copyright (c) 2012 SafetyWeb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject {
    
}

+(void)setUseCached:(BOOL)aUseCache;
+(BOOL)getUseCached;

@end
