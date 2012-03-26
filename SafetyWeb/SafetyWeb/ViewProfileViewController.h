//
//  ViewProfileViewController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RootViewController.h"
#import "ChildManager.h"
#import "ImageCacheManager.h"

#define kTableRowHeight 44

@interface ViewProfileViewController : SubRootViewController <UITableViewDelegate, UITableViewDataSource, CachedImage> {
    @private
    UIButton *editButton;
    UIImageView *childImage;
    UILabel *childName;
    UITextView *address;
    UITextView *mobilePhone;
    UIButton *callButton;
    UITableView *socialMediaTable;
    UIScrollView *scrollView;
    UIView *contentView;
    
    Child *child;
    BOOL isEditing;
}

@property (nonatomic, retain) IBOutlet UIButton *editButton;
@property (nonatomic, retain) IBOutlet UIImageView *childImage;
@property (nonatomic, retain) IBOutlet UILabel *childName;
@property (nonatomic, retain) IBOutlet UITextView *address;
@property (nonatomic, retain) IBOutlet UITextView *mobilePhone;
@property (nonatomic, retain) IBOutlet UIButton *callButton;
@property (nonatomic, retain) IBOutlet UITableView *socialMediaTable;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) Child *child;

-(IBAction)backgroundTap:(id)sender;
-(IBAction)backPressed:(id)sender;
-(IBAction)editPressed:(id)sender;
-(IBAction)callPressed:(id)sender;

@end
