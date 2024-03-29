//
//  CheckInCellController.h
//  SafetyWeb
//
//  Created by Gregory Schmelter on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildManager.h"
#import "ImageCacheManager.h"

@interface CheckInCellController : UIViewController <CachedImage> {
    @private
    Child *child;
    NSInteger row;
    
    UIImageView *backgroundImage;
    UIImageView *childImage;
    UILabel *firstName;
    UILabel *lastName;
}

@property (nonatomic, retain) Child* child;
@property (nonatomic) NSInteger row;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) IBOutlet UIImageView *childImage;
@property (nonatomic, retain) IBOutlet UILabel *firstName;
@property (nonatomic, retain) IBOutlet UILabel *lastName;

-(IBAction)requestCheckInPressed:(id)sender;
-(UITableViewCell*)tableViewCell;

@end
