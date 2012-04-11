//
//  SWAppDelegate.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import <Block.h>
#import <CoreLocation/CoreLocation.h>

@interface SWAppDelegate : UIResponder <UIApplicationDelegate> {
    @private
    UIWindow *window;
    RootViewController *viewController;
    
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *viewController;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

@end
