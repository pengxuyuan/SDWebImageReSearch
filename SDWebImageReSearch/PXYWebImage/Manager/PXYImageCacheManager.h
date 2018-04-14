//
//  PXYImageCacheManager.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/6.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PXYImageMemoryCache,PXYImageDiskCache;
//typedef void(^PXYImageCacheCompeleteBlock)();

/**
 缓存管理类
 */
@interface PXYImageCacheManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong, readonly) PXYImageMemoryCache *memoryCache;
@property (nonatomic, strong, readonly) PXYImageDiskCache *diskCache;

/**
 用 key 缓存图片到内存和磁盘
 */
- (void)storeImage:(UIImage *)image forKey:(NSString *)key;

/**
 用 key 缓存图片到内存和磁盘
 @param toDisk 为YES，就加上磁盘缓存，为NO的时候就单纯存内存
 */
- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk;

/**
 用 Key 去内存、磁盘中查找图片
 */
- (UIImage *)fetchImageWithKey:(NSString *)key;

/**
 用 Key 去内存中查找图片
 */
- (UIImage *)fetchImageFromMemoryWithKey:(NSString *)key;

/**
 用 Key 去磁盘中查找图片
 */
- (UIImage *)fetchImageFormDiskWithKey:(NSString *)key;

/**
 清除内存、磁盘中的缓存
 */
- (void)clearAllCacheImage;

/**
 清除内存中的缓存
 */
- (void)clearMemoryCacheImage;

/**
 清除磁盘中的缓存
 */
- (void)clearDiskCacheImage;

@end
