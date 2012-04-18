//
//  ImageCacheManager.m
//  SafetyWeb
//
//  Created by Greg Schmelter on 3/15/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImageCacheManager.h"

#import <CommonCrypto/CommonDigest.h>

#define MAX_CACHE_AGE 86400

static ImageCacheManager* manager = nil;

@implementation ImageCacheManager

-(ImageCacheManager*) init {
	@synchronized([ImageCacheManager class]) {
		if (manager) {
			[self dealloc];
		} else {
			[super init];
			@synchronized(self) {
				urlToCachedImages = [[NSMutableDictionary alloc] init];
				pthread_mutex_init(&imageMutex,NULL);
			}
			manager = self;
		}
	}
    [manager retain];
	return manager;
}

-(void) cacheFromURL:(NSString*) imageUrl {
    @autoreleasepool {  
        pthread_mutex_lock(&imageMutex);  // Serialize loading so this doesnt go nuts
        
        NSError *err = nil;
        NSURL *newurl = [NSURL URLWithString:imageUrl];
        NSData *imageData = [NSData dataWithContentsOfURL:newurl options:0 error:&err];
        UIImage *newImage = nil;
        if ( imageData )
        {
            newImage = [UIImage imageWithData:imageData];
        }
        pthread_mutex_unlock(&imageMutex);
        
        // We have an image, so send it to off
        @synchronized(self) {
            NSMutableSet* cachedImages = [urlToCachedImages objectForKey:imageUrl];
            if (cachedImages && newImage) {
                BOOL expires = YES;
                for (id<CachedImage> cachedImage in cachedImages) {
                    if (![cachedImage expires]) expires = NO;
                    
                    [cachedImage setImage:newImage];
                }
                [ImageCacheManager cacheImage:imageData cacheUrl:imageUrl expires:expires];
            }
            [urlToCachedImages removeObjectForKey:imageUrl];
        }
        
    }
}

-(void) requestImage:(id<CachedImage>)aCachedImage ForUrl:(NSString*)imageUrl {
	@synchronized(self) {
		// Check if we already have the image
		UIImage* imageData = [ImageCacheManager getImageFromCache:imageUrl];
		if (imageData) {
			[aCachedImage setImage:imageData];
			return;
		}
		
		NSMutableSet* cachedImages = [urlToCachedImages objectForKey:imageUrl];
		if (cachedImages) {
			[cachedImages addObject:aCachedImage];
			return;
		} else {
			cachedImages = [[NSMutableSet alloc] init];
			[cachedImages addObject:aCachedImage];
			[urlToCachedImages setObject:cachedImages forKey:imageUrl];
			// Not in the cache, and not previously requested, form a new request
			[self performSelectorInBackground:@selector(cacheFromURL:) withObject:imageUrl];
			
			[cachedImages release];
		}
	}
}

+ (NSMutableDictionary*) loadCachedImagesFromDisk
{
    NSMutableDictionary *internal_cache = [[NSMutableDictionary alloc] init];
    @autoreleasepool {
        
        NSFileManager *_manager = [NSFileManager defaultManager];
        NSArray *_cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *_cacheDirectory = [_cachePaths objectAtIndex:0]; 
        NSArray *_cacheFileList;
        NSEnumerator *_cacheEnumerator;
        NSString *_cacheFilePath;
        NSMutableDictionary *stored_cache = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DiskCacheImages"] mutableCopy];
        
        if ( stored_cache )
        {
            _cacheFileList = [_manager subpathsAtPath:_cacheDirectory];
            _cacheEnumerator = [_cacheFileList objectEnumerator];
            while (_cacheFilePath = [_cacheEnumerator nextObject]) 
            {
                NSMutableArray *image_info = [stored_cache objectForKey:_cacheFilePath];
                if ( image_info )
                {
                    // lets see if it's expired
                    NSString *age_string = [image_info objectAtIndex:0];
                    time_t age = [age_string longLongValue];
                    time_t now = time(NULL);
                    if ( age && now - age >  MAX_CACHE_AGE )
                    {
                        [_manager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",_cacheDirectory,_cacheFilePath] error:NULL];
                        [stored_cache removeObjectForKey:_cacheFilePath];
                        [[NSUserDefaults standardUserDefaults] setObject:stored_cache forKey:@"DiskCacheImages"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    else 
                    {
                        
                        NSData *worker = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",_cacheDirectory,_cacheFilePath]];
                        UIImage* newImage = [UIImage imageWithData:worker];
                        [internal_cache setValue:newImage forKey:[image_info objectAtIndex:1]];
                        
                    }
                    
                    
                }
                else {
                    // This doesnt belong in the cache
                    //[_manager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",_cacheDirectory,_cacheFilePath] error:NULL];
                    
                }
                
            }
        }
        else
        {
            _cacheFileList = [_manager subpathsAtPath:_cacheDirectory];
            _cacheEnumerator = [_cacheFileList objectEnumerator];
            while (_cacheFilePath = [_cacheEnumerator nextObject]) 
            {
                // This doesnt belong in the cache
                //[_manager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",_cacheDirectory,_cacheFilePath] error:NULL];
            }
			
        }
        
        
	}
	[internal_cache autorelease];
	return internal_cache;
}

+ (UIImage*) getImageFromCache:(NSString*)imageUrl {
	return [[ImageCacheManager loadCachedImagesFromDisk] objectForKey:imageUrl];
}

+ (void) cacheImage:(NSData*)imageData cacheUrl:(NSString*)imageUrl expires:(bool)can_expire
{
    @autoreleasepool {
        
        NSArray *_cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *_cacheDirectory = [_cachePaths objectAtIndex:0]; 
        
        [imageData writeToFile:[NSString stringWithFormat:@"%@/%@",_cacheDirectory,[imageUrl MD5]] atomically:TRUE];
        
        NSMutableDictionary *stored_cache = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DiskCacheImages"] mutableCopy];
        if (!stored_cache) {
            stored_cache = [[[NSMutableDictionary alloc] init] autorelease];
        }
        NSMutableArray *image_info = [[NSMutableArray alloc] init];
        if ( can_expire )	
        {
            [image_info insertObject:[NSString stringWithFormat:@"%llu",time(NULL)] atIndex:0];
        }
        else 
        {
            [image_info insertObject:@"0" atIndex:0];
        }
        
        [image_info insertObject:imageUrl atIndex:1];
        [stored_cache setObject:image_info forKey:[imageUrl MD5]];
		
        [[NSUserDefaults standardUserDefaults] setObject:stored_cache forKey:@"DiskCacheImages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
 
}

-(void) dealloc {
	[urlToCachedImages release];
    pthread_mutex_destroy(&imageMutex);
	
	[super dealloc];
}

@end
