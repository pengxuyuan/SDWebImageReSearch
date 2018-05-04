//
//  PXYImageDiskCache.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/6.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PXYImageDiskCache : NSObject

/**
 单例
 */
+ (nonnull instancetype)shareInstance;

/**
 获取磁盘缓存 Cache 目录,在后面拼接上 nameSpace
 */
- (nonnull NSString *)fetchDiskCachePathWithNameSpace:(nullable NSString *)nameSpace;

/**
 将 NSData 存入到缓存文件夹中
 */
- (void)storeImageDataToDisk:(nullable NSData *)imageData key:(nullable NSString *)key;

/**
 查询磁盘是否存在这个图片
 */
- (BOOL)inquireDiskImageExistsWithKey:(nullable NSString *)key;

/**
 磁盘查找图片
 */
- (NSData *_Nullable)fetchDiskImageDataWithKey:(nullable NSString *)key;

/**
 清除磁盘中的图片缓存
 */
- (void)clearImageOnDiskCache;

/**
 获取磁盘图片大小
 */
- (NSUInteger)fetchDiskImageSize;

/**
 获取磁盘图片数量
 */
- (NSUInteger)fetchDiskImageCount;



@end
