//
//  PXYWebImageDownloaderOperation.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/7/2.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXYWebImageOperationProtocol.h"
#import "PXYWebImageDownloader.h"

/**
 重写 Operation，为了更好的定制化，以及控制自身的一些属性
 */
@interface PXYWebImageDownloaderOperation : NSOperation <PXYWebImageOperationProtocol, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

/**
 通过 NSURLSessionTask 来在 NSURLSession 里面执行下载任务
 */
@property (nonatomic, strong, readonly) NSURLSessionTask *dataTask;

/**
 是否需要解压缩下载的图片
 */
@property (nonatomic, assign) BOOL shouldDecompressImages;

/**
 通过 WebImageDownloader 将下载策略设置进来
 */
@property (nonatomic, assign) PXYWebImageDownloaderOptions options;

/**
 预期数据大小
 */
@property (nonatomic, assign) NSInteger expectedSize;

/**
 这里直接使用 ImageURL 来创建一个 NSURLSessionTask 来丢到 Operation 里面
 */
- (instancetype)initWithImageURL:(NSURL *)imageURL
                       inSession:(NSURLSession *)session
                         options:(PXYWebImageDownloaderOptions)options;


/**
 这里在每次进行需要下载的时候都需要调用，这里需要记录这个 Operation 有多少个回调
 一来可以减少 Operation 的创建
 二来可以方便将请求回调到所有调用方
 */
- (void)addHandlesForProgress:(PXYWebImageDownloaderProgressBlock)progressBlock
                     complete:(PXYWebImageDownloaderCompleteBlock)completeBlock;

- (void)cancel:(id)token;


@end
