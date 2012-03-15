//
//  ImageCacheManager.h
//  SafetyWeb
//
//  Created by Greg Schmelter on 3/15/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+MD5.h"

@protocol CachedImage <NSObject>
-(void)setImage:(UIImage*)imageData;
-(BOOL)expires;
@end

@interface ImageCacheManager : NSObject {
@private
	// The below represents the pending requests for URLs.
	// It's a dictionary between the URL being requested, and a NSMutableSet of
	// the CachedImages
	NSMutableDictionary *urlToCachedImages;
	
	pthread_mutex_t imageMutex;

}

-(void) requestImage:(id<CachedImage>)aCachedImage ForUrl:(NSString*)imageUrl;

+ (UIImage*) getImageFromCache:(NSString*)imageUrl;
+ (void) cacheImage:(NSData*)imageData cacheUrl:(NSString*)imageUrl expires:(bool)can_expire;

@end
