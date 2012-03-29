//
//  Utilities.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

-(Utilities*)init {
    // This class is purely static
    [self release];
    
    return nil;
}

+(BOOL) NSStringIsValidEmail:(NSString *)checkString {
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+(NSString*)timeIntervalToHumanString:(NSTimeInterval)timeInterval {
    NSDate *now = [[NSDate alloc] init];
    NSTimeInterval nowTI = [now timeIntervalSince1970];
    [now release];
    
    if (nowTI < timeInterval) timeInterval = nowTI;
    NSTimeInterval difference = nowTI - timeInterval;
    
    int weeksAgo = difference / (60*60*24*7);
    if (weeksAgo > 0) return [NSString stringWithFormat:@"%i Weeks Ago", weeksAgo];
    
    int daysAgo = difference / (60*60*24);
    if (daysAgo > 0) return [NSString stringWithFormat:@"%i Days Ago", daysAgo];
    
    int hoursAgo = difference / (60*60);
    if (hoursAgo > 0) return [NSString stringWithFormat:@"%i Hours Ago", hoursAgo];
    
    int minutesAgo = difference / 60;
    return [NSString stringWithFormat:@"%i Minutes Ago", minutesAgo];
}

@end
