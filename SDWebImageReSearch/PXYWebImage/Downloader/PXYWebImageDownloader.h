//
//  PXYWebImageDownloader.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/6.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PXYWebImageOperationProtocol.h"

/**
 设置下载的策略
 */
typedef NS_OPTIONS(NSInteger, PXYWebImageDownloaderOptions) {
    //设置下载任务的优先级
    PXYWebImageDownloaderLowPriority = 1 << 0,
    PXYWebImageDownloaderHighPriority = 1 << 1,
    
    // 设置渐进式下载图片，展示的时候也可以渐进式展示
    PXYWebImageDownloaderProgressiveDownload = 1 << 2,
    
    // 设置后台继续下载任务
    PXYWebImageDownloaderContinueInBackground = 1 << 3,
    
    // 设置压缩下载的图片
    PXYWebImageDownloaderScaleDownLargeImage = 1 << 4
};

/**
 设置下载任务执行的顺序
 */
typedef NS_ENUM(NSInteger, PXYWebImageDownloaderExecutionOrder) {
    //FIFO
    PXYWebImageDownloaderFIFOExecutionOrder,
    
    //LIFO
    PXYWebImageDownloaderLIFOExecutionOrder
};

typedef void (^PXYWebImageDownloaderProgressBlock) (NSInteger receivedSize, NSInteger expectedSize);
typedef void (^PXYWebImageDownloaderCompleteBlock) (NSData *imageData, UIImage *image, NSError *error);

/**
 声明一个与 NSOperation 相关联的 Token，以便可以取消 NSOperation
 */
@interface PXYWebImageDownloaderToken : NSObject <PXYWebImageOperationProtocol>

@property (nonatomic, strong, nullable) NSURL *url;

@property (nonatomic, strong, nullable) id downloadOperationCacelToken;

@end

/**
 图片下载类 负责下载图片
 */
@interface PXYWebImageDownloader : NSObject

/**
 是否解压缩图片，这样子会提升性能，但是会占用大量的内存
 */
@property (nonatomic, assign) BOOL shouldDecompressImage;

/**
 OperationQueue 最大并发下载数量
 */
@property (nonatomic, assign) NSInteger maxConcurrentDownloads;

/**
 OperationQueue 队列中的下载数量
 */
@property (nonatomic, assign, readonly) NSInteger currentDownloadCount;

/**
 设置请求超时时间
 */
@property (nonatomic, assign) NSTimeInterval downloadTimeout;

/**
 设置队列的任务的执行顺序，默认是 FIFO
 */
@property (nonatomic, assign) PXYWebImageDownloaderExecutionOrder executingOrder;

/**
 单例
 */
+ (instancetype)shareInstance;

- (nullable PXYWebImageDownloaderToken *)downloadImageWithImageUrl:(NSURL *)url
                                                           options:(PXYWebImageDownloaderOptions)options
                                                          progress:(PXYWebImageDownloaderProgressBlock)prpgressBlock
                                                    compeleteBlock:(PXYWebImageDownloaderCompleteBlock)compeleteBlock;

/**
 通过 Token 取消下载任务
 */
- (void)cancel:(PXYWebImageDownloaderToken *)token;

/**
 暂停或者启动队列下载任务
 */
- (void)setSuspended:(BOOL)suspended;

/**
 取消队列中所有的下载任务
 */
- (void)cancelAllDownloads;

@end
