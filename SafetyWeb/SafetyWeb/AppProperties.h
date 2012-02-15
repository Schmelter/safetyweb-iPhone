//
//  AppProperties.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 * Represents the properties packed with the application.  These can easily be swapped in and
 * out to go against different servers such as Dev, QA, and Prod.  Loads the AppProperties.plist.
 */

#import <Foundation/Foundation.h>

@interface AppProperties : NSObject {
    
}

+(id)getProperty:(NSString*)propName withDefault:(id)aDefault;

@end
