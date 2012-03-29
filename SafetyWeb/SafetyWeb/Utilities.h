//
//  Utilities.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 * Purely static class that exists to give utility functions to the rest of the system.
 */

#import <Foundation/Foundation.h>

@interface Utilities : NSObject{
    
}

+(BOOL) NSStringIsValidEmail:(NSString *)checkString;

+(NSString*)timeIntervalToHumanString:(NSTimeInterval)timeInterval;

@end
