//
//  PXYImageCacheManager.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/6.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "PXYImageCacheManager.h"
#import "PXYImageMemoryCache.h"
#import "PXYImageDiskCache.h"
#import "PXYMD5DigestHelper.h"

#define MD5(URL) [PXYMD5DigestHelper convertToUpper32BitsMD5With:URL]

@implementation PXYImageCacheManager
#pragma mark - Life Cycle
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static PXYImageCacheManager *shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [PXYImageCacheManager new];
    });
    return shareInstance;
}

#pragma mark - Plublic Methods
/**
 用 key 缓存图片到内存和磁盘
 */
- (void)storeImage:(UIImage *)image forKey:(NSString *)key {
    [self storeImage:image forKey:key toDisk:YES];

}

/**
 用 key 缓存图片到内存和磁盘
 @param toDisk 为YES，就加上磁盘缓存，为NO的时候就单纯存内存
 */
- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk {
    NSString *imageKeyMD5 = MD5(key);
    
    [[PXYImageMemoryCache shareInstance] setObject:image forKey:imageKeyMD5];
    
    if (toDisk) {
        [[PXYImageDiskCache shareInstance] storeImage:image forKey:imageKeyMD5];
    }
}

/**
 用 Key 去内存、磁盘中查找图片
 */
- (UIImage *)fetchImageWithKey:(NSString *)key {
    UIImage *image = [self fetchImageFromMemoryWithKey:key];
    if (!image) {
        image = [self fetchImageFormDiskWithKey:key];
        if (image) {
            [self storeImage:image forKey:key toDisk:NO];
        }
        
    }
    return image;
}

/**
 用 Key 去内存中查找图片
 */
- (UIImage *)fetchImageFromMemoryWithKey:(NSString *)key {
    NSString *imageKeyMD5 = MD5(key);
    UIImage *image = [[PXYImageMemoryCache shareInstance] objectForKey:imageKeyMD5];
    return image;
}

/**
 用 Key 去磁盘中查找图片
 */
- (UIImage *)fetchImageFormDiskWithKey:(NSString *)key {
    NSString *imageKeyMD5 = MD5(key);
    NSData *imageData = [[PXYImageDiskCache shareInstance] fetchImageWithKey:imageKeyMD5];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

/**
 清除内存、磁盘中的缓存
 */
- (void)clearAllCacheImage {
    [self clearMemoryCacheImage];
    [self clearDiskCacheImage];
}

/**
 清除内存中的缓存
 */
- (void)clearMemoryCacheImage {
    [[PXYImageMemoryCache shareInstance] removeAllObjects];;
}

/**
 清除磁盘中的缓存
 */
- (void)clearDiskCacheImage {
    [[PXYImageDiskCache shareInstance] removeDiskAllObjects];
}

@end
