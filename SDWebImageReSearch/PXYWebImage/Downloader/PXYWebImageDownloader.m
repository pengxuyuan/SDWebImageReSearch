//
//  PXYWebImageDownloader.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/6.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "PXYWebImageDownloader.h"
#import "PXYWebImageDownloaderOperation.h"

@interface PXYWebImageDownloaderToken ()

// 弱引用，下载操作，以便取消下载任务
@property (nonatomic, weak) NSOperation *downloadOperation;

@end

@implementation PXYWebImageDownloaderToken

- (void)cancel {
    if (self.downloadOperation) {
        PXYWebImageDownloaderToken *cancelToken = self.downloadOperationCacelToken;
        if (cancelToken) {
            [self.downloadOperation cancel];
        }
    }
}

@end


@interface PXYWebImageDownloader()
<NSURLSessionDelegate,
NSURLSessionDataDelegate,
NSURLSessionTaskDelegate,
NSURLSessionStreamDelegate,
NSURLSessionDownloadDelegate>

/**
 存放下载操作的队列
 */
@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@property (nonatomic, strong) NSURLSession *session;

/**
 保存当前队列里面存在的操作，可以确保相同的 URL 不会再次创建操作放入队列中
 防止多次请求
 */
@property (nonatomic, strong) NSMutableDictionary <NSString *,PXYWebImageDownloaderOperation *>*operationDict;


@end

@implementation PXYWebImageDownloader
#pragma mark - Life Cycle
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static PXYWebImageDownloader *shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [PXYWebImageDownloader new];
    });
    return shareInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _shouldDecompressImage = YES;
        _downloadQueue.maxConcurrentOperationCount = 5;
        _downloadTimeout = 10;
        _executingOrder = PXYWebImageDownloaderFIFOExecutionOrder;
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = self.downloadTimeout;
        
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:self.downloadQueue];
        
    }
    return self;
}

- (void)dealloc {
    [self.session invalidateAndCancel];
    self.session = nil;
    
    [self.downloadQueue cancelAllOperations];
}

#pragma mark - Public Methods
/**
 通过 Token 取消下载任务
 */
- (void)cancel:(PXYWebImageDownloaderToken *)token {
    
}

/**
 暂停或者启动队列下载任务
 */
- (void)setSuspended:(BOOL)suspended {
    
}

/**
 取消队列中所有的下载任务
 */
- (void)cancelAllDownloads {
    
}


#pragma mark - Setter
/**
 OperationQueue 最大并发下载数量
 */
- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrentDownloads {
    self.downloadQueue.maxConcurrentOperationCount = maxConcurrentDownloads;
}

/**
 OperationQueue 最大并发下载数量
 */
- (NSInteger)maxConcurrentDownloads {
    return self.downloadQueue.maxConcurrentOperationCount;
}

/**
 OperationQueue 队列中的下载数量
 */
- (NSInteger)currentDownloadCount {
    return self.downloadQueue.operationCount;
}


// 创建一个真正的请求
- (nullable PXYWebImageDownloaderToken *)downloadImageWithImageUrl:(NSURL *)url
                                                           options:(PXYWebImageDownloaderOptions)options
                                                          progress:(PXYWebImageDownloaderProgressBlock)progressBlock
                                                    compeleteBlock:(PXYWebImageDownloaderCompleteBlock)compeleteBlock {
    
    NSString *urlStr = [url absoluteString];
    
    PXYWebImageDownloaderOperation *operation = self.operationDict[urlStr];
    if (operation == nil) {
        __weak typeof(self) weakSelf = self;
        
        operation = [[PXYWebImageDownloaderOperation alloc] initWithImageURL:url inSession:self.session options:options];
        operation.completionBlock = ^{
            [weakSelf.operationDict removeObjectForKey:urlStr];
        };

        [self.downloadQueue addOperation:operation];
        self.operationDict[urlStr] = operation;
    }
    
    [operation addHandlesForProgress:progressBlock complete:compeleteBlock];
    PXYWebImageDownloaderToken *token = [PXYWebImageDownloaderToken new];
    token.url = url;
    token.downloadOperation = operation;
    
    return token;
}


#pragma mark - Private Methods
- (void)realDownloadImageWithImageUrl:(NSURL *)url compeleteBlock:(PXYWebImageDownloaderCompleteBlock)compeleteBlock {
    NSLog(@"开始下载图片：%@",url);
    
//    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:url];
//    [downloadTask resume];
}

#pragma mark - NSURLSessionDelegate

#pragma mark - NSURLSessionDataDelegate
//收到响应
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    NSLog(@"%s",__func__);
    
    PXYWebImageDownloaderOperation *operation = [self p_fetchOperationWithTask:dataTask];
    if ([operation respondsToSelector:@selector(URLSession:dataTask:didReceiveResponse:completionHandler:)]) {
        [operation URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
    } else {
        completionHandler(NSURLSessionResponseAllow);
    }
}

// 接收到数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"%s",__func__);
    
    PXYWebImageDownloaderOperation *operation = [self p_fetchOperationWithTask:dataTask];
    if ([operation respondsToSelector:@selector(URLSession:dataTask:didReceiveData:)]) {
        [operation URLSession:session dataTask:dataTask didReceiveData:data];
    }
    
}

#pragma mark - NSURLSessionTaskDelegate
// 收到错误
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    NSLog(@"%s",__func__);
    
    PXYWebImageDownloaderOperation *operation = [self p_fetchOperationWithTask:task];
    if ([operation respondsToSelector:@selector(URLSession:task:didCompleteWithError:)]) {
        [operation URLSession:session task:task didCompleteWithError:error];
    }
    
}

#pragma mark - NSURLSessionStreamDelegate

#pragma mark - NSURLSessionDownloadDelegate
//// downloadTask 完成
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
//didFinishDownloadingToURL:(NSURL *)location {
//    NSLog(@"%s",__func__);
//    
//    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:downloadTask.response.suggestedFilename];
//    NSURL *fileUrl = [NSURL fileURLWithPath:fullPath];
//
//    [[NSFileManager defaultManager] moveItemAtURL:location toURL:fileUrl error:nil];
//
//    NSData *fileData = [NSData dataWithContentsOfURL:fileUrl];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *tempImageUrl = [downloadTask.originalRequest.URL absoluteString];
//        UIImage *image = [UIImage imageWithData:fileData];
//        [self p_callCompletionBlockWithImageData:fileData image:image error:downloadTask.error tempImageUrl:tempImageUrl];
//    });
//}
//
//
//// downloadTask 下载进度
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
//      didWriteData:(int64_t)bytesWritten
// totalBytesWritten:(int64_t)totalBytesWritten
//totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
//    NSLog(@"%s",__func__);
//}
//
//// 下载恢复
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
// didResumeAtOffset:(int64_t)fileOffset
//expectedTotalBytes:(int64_t)expectedTotalBytes {
//    NSLog(@"%s",__func__);
//}


#pragma mark - Private Methods
- (void)p_callCompletionBlockWithImageData:(NSData *)imageData image:(UIImage *)image error:(NSError *)error tempImageUrl:(NSString *)tempImageUrl {
    NSLog(@"下载成功图片：%@",tempImageUrl);
    
//    PXYWebImageDownloaderOperation *tempOperation = self.operationDict[tempImageUrl];
//
//    if (tempOperation.operationCallbackArray.count > 0) {
//        for (NSMutableDictionary *callbackDict in tempOperation.operationCallbackArray) {
//            PXYWebImageDownloaderCompleteBlock completeBlock = callbackDict[@"compeleteBlock"];
//            completeBlock(imageData, image, error);
//        }
//    }
    
}

- (PXYWebImageDownloaderOperation *)p_fetchOperationWithTask:(NSURLSessionTask *)task {
    PXYWebImageDownloaderOperation *operation = nil;
    for (PXYWebImageDownloaderOperation *operationItem in self.downloadQueue.operations) {
        /* !!!: 这里为什么只加了一次 Queue 却有两个 */
        if ([operationItem isKindOfClass:[PXYWebImageDownloaderOperation class]]) {
            if (operationItem.dataTask.taskIdentifier == task.taskIdentifier) {
                operation = operationItem;
            }
        }
    }
    return operation;
}


#pragma mark - Lazzy load
- (NSOperationQueue *)downloadQueue {
    if (_downloadQueue == nil) {
        _downloadQueue = [NSOperationQueue new];
    }
    return _downloadQueue;
}

- (NSMutableDictionary<NSString *,PXYWebImageDownloaderOperation *> *)operationDict {
    if (_operationDict == nil) {
        _operationDict = [NSMutableDictionary dictionary];
    }
    return _operationDict;
}


@end
