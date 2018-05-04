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


/**
 图片缓存的类型
 */
typedef NS_ENUM(NSInteger, PXYImageCacheType) {
    //没有缓存
    PXYImageCacheTypeNone,
    //内存缓存
    PXYImageCacheTypeMemory,
    //磁盘缓存
    PXYImageCacheTypeDisk
};

typedef NS_OPTIONS(NSInteger, PXYImageCacheOptions) {
    //内存缓存命中直接返回
    PXYImageCacheOptionsReturnDataWhenInMemory,
    //同步查询磁盘数据
    PXYImageCacheOptionsQueryDiskSync
};

//不需要任何参数，只是通知任务完成
typedef void (^PXYWebImageNoParamsBlock)(void);
//查询图片是否存在
typedef void (^PXYWebImageCheckImageCompletionBlock)(BOOL isExist);
//获取图片
typedef void (^PXYWebImageFetchImageCompletionBlock)(UIImage *image, NSData *imageData,PXYImageCacheType cacheType);
typedef void (^PXYWebImageCalculateCompletionBlock)(NSUInteger fileCount, NSUInteger fileSize);


/**
 缓存管理类
 */
@interface PXYImageCacheManager : NSObject

/**
 单例
 */
+ (instancetype)shareInstance;

#pragma mark - 内存缓存配置
/**
 设置内存最大消耗
 */
@property (nonatomic, assign) NSUInteger maxMemoryCost;

/**
 设置内存最大缓存数量
 */
@property (nonatomic, assign) NSUInteger maxMemoryCountLimit;

#pragma mark - 存储数据方法
/**
 将数据存在内存 & 磁盘，存储完毕 Block 回调通知
 */
- (void)storeImage:(UIImage *)image
            forKey:(NSString *)key
        completion:(PXYWebImageNoParamsBlock)completionBlock;

/**
 将数据存在内存 & 磁盘，存储完毕 Block 回调通知

 @param toDisk YES：同时存到磁盘； NO：不存到磁盘
 */
- (void)storeImage:(UIImage *)image
            forKey:(NSString *)key
            toDisk:(BOOL)toDisk
        completion:(PXYWebImageNoParamsBlock)completionBlock;

/**
 将数据存在内存 & 磁盘，存储完毕 Block 回调通知
 @param imageData 磁盘直接存储 Data，不需要内部再次转换，优化性能
 */
- (void)storeImage:(UIImage *)image
         imageData:(NSData *)imageData
            forKey:(NSString *)key
            toDisk:(BOOL)toDisk
        completion:(PXYWebImageNoParamsBlock)completionBlock;

#pragma mark - 获取数据方法
/**
 异步查询磁盘中是否有这张图片
 */
- (void)inquireDiskImageExistsWithKey:(NSString *)key completion:(PXYWebImageCheckImageCompletionBlock)completionBlock;

/**
 同步查询磁盘中是否有这张图片
 */
- (BOOL)inquireDiskImageExistsWithKey:(NSString *)key;

/**
 异步获取图片
 */
- (NSOperation *)fetchCacheOperationForKey:(NSString *)key completion:(PXYWebImageFetchImageCompletionBlock)completionBlock;

/**
 获取图片，根据 options 策略进行同步异步操作
 */
- (NSOperation *)fetchCacheOperationForKey:(NSString *)key options:(PXYImageCacheOptions)options completion:(PXYWebImageFetchImageCompletionBlock)completionBlock;

/**
 从内存缓存中获取图片
 */
- (UIImage *)fetchImageFromMemoryCacheForKey:(NSString *)key;

/**
 同步方法：从磁盘缓存中查找图片
 */
- (UIImage *)fetchImageFormDiskCacheForKey:(NSString *)key;

/**
 从缓存中获取图片
 */
- (UIImage *)fectchImageFormCacheForKey:(NSString *)key;

#pragma mark - 清除数据
/**
 清除所有内存缓存
 */
- (void)clearAllMemoryCache;

/**
 异步清除磁盘缓存
 */
- (void)clearAllDiskCacheCompletion:(PXYWebImageNoParamsBlock)completionBlock;

#pragma mark - 磁盘缓存相关信息
/**
 获取磁盘缓存文件大小
 */
- (NSUInteger)fetchDiskCacheSize;

/**
 获取磁盘缓存数量
 */
- (NSUInteger)fetchDiskCacheCount;

/**
 异步计算磁盘缓存文件大小&数量
 */
- (void)calculateDiskCacheSizeWithCompletionBlock:(PXYWebImageCalculateCompletionBlock)completionBlock;





@end
