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



@interface PXYImageCacheManager ()

@property (nonatomic, strong, readwrite) PXYImageMemoryCache *memoryCache;
@property (nonatomic, strong, readwrite) PXYImageDiskCache *diskCache;
@property (nonatomic, strong) dispatch_queue_t ioQueue;

@end

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

- (instancetype)init {
    self = [super init];
    if (self) {
        self.memoryCache = [PXYImageMemoryCache shareInstance];
        self.diskCache = [PXYImageDiskCache shareInstance];
        
        //创建 IO 串行队列
        self.ioQueue = dispatch_queue_create("com.pengxuyuan.PXYWebImageCache", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - Plublic Methods

#pragma mark - 内存缓存配置
//获取内存缓存最大消耗
- (NSUInteger)maxMemoryCost {
    return self.memoryCache.totalCostLimit;
}

//设置内存缓存最大消耗
- (void)setMaxMemoryCost:(NSUInteger)maxMemoryCost {
    self.memoryCache.totalCostLimit = maxMemoryCost;
}

//获取内存缓存最大缓存数量
- (NSUInteger)maxMemoryCountLimit {
    return self.memoryCache.countLimit;
}

//设置内存缓存最大缓存数量
- (void)setMaxMemoryCountLimit:(NSUInteger)maxMemoryCountLimit {
    self.memoryCache.countLimit = maxMemoryCountLimit;
}

#pragma mark - 存储数据方法
/**
 将数据存在内存 & 磁盘，存储完毕 Block 回调通知
 */
- (void)storeImage:(UIImage *)image
            forKey:(NSString *)key
        completion:(PXYWebImageNoParamsBlock)completionBlock {
    [self storeImage:image imageData:nil forKey:key toDisk:YES completion:completionBlock];
}

/**
 将数据存在内存 & 磁盘，存储完毕 Block 回调通知
 
 @param toDisk YES：同时存到磁盘； NO：不存到磁盘
 */
- (void)storeImage:(UIImage *)image
            forKey:(NSString *)key
            toDisk:(BOOL)toDisk
        completion:(PXYWebImageNoParamsBlock)completionBlock {
    [self storeImage:image imageData:nil forKey:key toDisk:toDisk completion:completionBlock];
}

/**
 将数据存在内存 & 磁盘，存储完毕 Block 回调通知
 @param imageData 磁盘直接存储 Data，不需要内部再次转换，优化性能
 */
- (void)storeImage:(UIImage *)image
         imageData:(NSData *)imageData
            forKey:(NSString *)key
            toDisk:(BOOL)toDisk
        completion:(PXYWebImageNoParamsBlock)completionBlock {
    if (image == nil || key == nil) {
        if (completionBlock) {
            completionBlock();
        }
        return;
    }
    
    [self.memoryCache setObject:image forKey:key];
    
    if (toDisk) {
        dispatch_async(self.ioQueue, ^{
            //存磁盘
            NSData *data = imageData;
            if (!data) {
                data = UIImagePNGRepresentation(image);
            }
            [self.diskCache storeImageDataToDisk:data key:key];
            
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock();
                });
            }
        });

    } else {
        if (completionBlock) {
            completionBlock();
        }
    }
}

#pragma mark - 获取数据方法
/**
 异步查询磁盘中是否有这张图片
 */
- (void)inquireDiskImageExistsWithKey:(NSString *)key completion:(PXYWebImageCheckImageCompletionBlock)completionBlock {
    dispatch_async(self.ioQueue, ^{
        BOOL exists = [self.diskCache inquireDiskImageExistsWithKey:key];
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(exists);
            });
        }
    });
}

/**
 同步查询磁盘中是否有这张图片
 */
- (BOOL)inquireDiskImageExistsWithKey:(NSString *)key {
    if (!key) {
        return NO;
    }
    
    __block BOOL exists = NO;
    dispatch_sync(self.ioQueue, ^{
        exists = [self.diskCache inquireDiskImageExistsWithKey:key];
    });
    return exists;
}

/**
 异步获取图片
 */
- (NSOperation *)fetchCacheOperationForKey:(NSString *)key completion:(PXYWebImageFetchImageCompletionBlock)completionBlock {
    return [self fetchCacheOperationForKey:key options:PXYImageCacheOptionsReturnDataWhenInMemory completion:completionBlock];
}

/**
 获取图片，根据 options 策略进行同步异步操作
 */
- (NSOperation *)fetchCacheOperationForKey:(NSString *)key options:(PXYImageCacheOptions)options completion:(PXYWebImageFetchImageCompletionBlock)completionBlock {
    if (!key) {
        if (completionBlock) {
            completionBlock(nil, nil, PXYImageCacheTypeNone);
        }
        return nil;
    }
    
    UIImage *image = [self.memoryCache objectForKey:key];
    BOOL queryMemoryCacheOnly = (image && options == PXYImageCacheOptionsReturnDataWhenInMemory);
    if (queryMemoryCacheOnly) {
        if (completionBlock) {
            completionBlock(image, nil, PXYImageCacheTypeMemory);
        }
        return nil;
    }
    
    //内存没有图片 or 需要同步查磁盘
    NSOperation *operation = [NSOperation new];
    void(^queryDiskBlock)(void) = ^{
        if (operation.isCancelled) {
            return;
        }
        
        NSData *diskImageData = [self.diskCache fetchDiskImageDataWithKey:key];
        UIImage *diskImage;
        PXYImageCacheType cacheType = PXYImageCacheTypeNone;
        if (image) {
            diskImage = image;
            cacheType = PXYImageCacheTypeMemory;
        } else if (diskImageData){
            cacheType = PXYImageCacheTypeDisk;
            diskImage = [self p_transformImageDataToImageWithImageData:diskImageData];
            if (diskImageData) {
                [self.memoryCache setObject:diskImage forKey:key];
            }
        }
        
        if (completionBlock) {
            if (options == PXYImageCacheOptionsQueryDiskSync) {
                completionBlock(diskImage, diskImageData, cacheType);
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(diskImage, diskImageData, cacheType);
                });
            }
        }
    };
    
    if (options & PXYImageCacheOptionsQueryDiskSync) {
        queryDiskBlock();
    } else {
        dispatch_async(self.ioQueue, queryDiskBlock);
    }
    
    
    return operation;
}

/**
 从内存缓存中获取图片
 */
- (UIImage *)fetchImageFromMemoryCacheForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    return [self.memoryCache objectForKey:key];
}

/**
 同步方法：从磁盘缓存中查找图片
 */
- (UIImage *)fetchImageFormDiskCacheForKey:(NSString *)key {
    UIImage *image = [self p_fetchImageFormDiskCacheWithKey:key];
    if (image) {
        [self.memoryCache setObject:image forKey:key];
    }
    return image;
}

/**
 从缓存中获取图片
 */
- (UIImage *)fectchImageFormCacheForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    
    UIImage *image = [self fetchImageFromMemoryCacheForKey:key];
    if (image) {
        return image;
    }
    
    image = [self fetchImageFormDiskCacheForKey:key];
    return image;
}

#pragma mark - 清除数据
/**
 清除所有内存缓存
 */
- (void)clearAllMemoryCache {
    [self.memoryCache removeAllObjects];
}

/**
 异步清除磁盘缓存
 */
- (void)clearAllDiskCacheCompletion:(PXYWebImageNoParamsBlock)completionBlock {
    dispatch_async(self.ioQueue, ^{
        [self.diskCache clearImageOnDiskCache];
        
        if (completionBlock) {
            completionBlock();
        }
    });
}

#pragma mark - 磁盘缓存相关信息
/**
 获取磁盘缓存文件大小
 */
- (NSUInteger)fetchDiskCacheSize {
    __block NSUInteger size = 0;
    dispatch_sync(self.ioQueue, ^{
        size = [self.diskCache fetchDiskImageSize];
    });
    return size;
}

/**
 获取磁盘缓存数量
 */
- (NSUInteger)fetchDiskCacheCount {
    __block NSUInteger count = 0;
    dispatch_sync(self.ioQueue, ^{
        count =  [self.diskCache fetchDiskImageCount];
    });
    return count;
}

/**
 异步计算磁盘缓存文件大小&数量
 */
- (void)calculateDiskCacheSizeWithCompletionBlock:(PXYWebImageCalculateCompletionBlock)completionBlock {
    
}

#pragma mark - Private Methods
/**
 将 ImageData 转换成 Image
 */
- (UIImage *)p_transformImageDataToImageWithImageData:(NSData *)imageData {
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

- (UIImage *)p_fetchImageFormDiskCacheWithKey:(NSString *)key {
    NSData *imageData = [self.diskCache fetchDiskImageDataWithKey:key];
    UIImage *image = [self p_transformImageDataToImageWithImageData:imageData];
    return image;
}


@end
