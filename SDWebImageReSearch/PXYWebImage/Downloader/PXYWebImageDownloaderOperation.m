//
//  PXYWebImageDownloaderOperation.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/7/2.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "PXYWebImageDownloaderOperation.h"

typedef NSMutableDictionary<NSString *, id> PXYCallbacksDictionary;

static NSString *kProgressCallbackKey = @"progress";
static NSString *kCompletedCallbackKey = @"complete";

@interface PXYWebImageDownloaderOperation () <NSURLSessionDelegate>

@property (nonatomic, strong) NSMutableArray <PXYCallbacksDictionary *> *callbackBlocks;

@property (nonatomic, weak) NSURLSession *unownedSession;

@property (nonatomic, strong) NSURL *imageURL;

/**
 通过 NSURLSessionTask 来在 NSURLSession 里面执行下载任务
 */
@property (nonatomic, strong, readwrite) NSURLSessionTask *dataTask;
@property (nonatomic, strong) NSMutableData *imageData;

@property (nonatomic, assign, getter = isExecuting) BOOL executing;
@property (nonatomic, assign, getter = isFinished) BOOL finished;

@end

@implementation PXYWebImageDownloaderOperation
/* !!!: 这里为什么需要这样子写 */
@synthesize executing = _executing;
@synthesize finished = _finished;

#pragma mark - Life Cycle
- (instancetype)init {
    return [self initWithImageURL:nil inSession:nil options:0];
}

/**
 这里直接使用 ImageURL 来创建一个 NSURLSessionTask 来丢到 Operation 里面
 */
- (instancetype)initWithImageURL:(NSURL *)imageURL
                       inSession:(NSURLSession *)session
                         options:(PXYWebImageDownloaderOptions)options {
    self = [super init];
    if (self) {
        _shouldDecompressImages = YES;
        
        _imageURL = imageURL;
        _unownedSession = session;
        _options = options;
        
        _callbackBlocks = [NSMutableArray array];
        
    }
    return self;
}

- (void)start {
    NSLog(@"%s",__func__);
    @synchronized (self) {
        if (self.isCancelled) {
            self.finished = NO;
            [self reset];
            return;
        }
        
        
        NSURLSession *session = self.unownedSession;
        if (session == nil) {
            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            sessionConfig.timeoutIntervalForRequest = 15;
            
            /* !!!: 为什么这里不传 Queue，之后是如何控制这个 Session 的呢 */
            session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
        }
        
        self.dataTask = [session dataTaskWithURL:self.imageURL];
        self.executing = YES;
    }

    
    if (self.dataTask) {
        // 设置 Task 的优先级
        if ([self.dataTask respondsToSelector:@selector(setPriority:)]) {
            if (self.options & PXYWebImageDownloaderHighPriority) {
                self.dataTask.priority = NSURLSessionTaskPriorityHigh;
            } else if (self.options & PXYWebImageDownloaderLowPriority) {
                self.dataTask.priority = NSURLSessionTaskPriorityLow;
            }
        }
        
        // 启动 Task
        [self.dataTask resume];
        
        // 回调一次下载进度 Block
        NSArray *progressBlocks = [self p_fetchCallbackForKey:kProgressCallbackKey];
        for (PXYWebImageDownloaderProgressBlock progressBlock in progressBlocks) {
            progressBlock(0, NSURLResponseUnknownLength);
        }
    } else {
        NSLog(@"dataTask 创建失败");
        [self done];
    }
    
}

- (void)cancel {
    NSLog(@"%s",__func__);
    @synchronized (self) {
        [self cancelInternal];
    }
}

- (BOOL)isConcurrent {
    return YES;
}

#pragma mark - Plublic Methods
/**
 这里在每次进行需要下载的时候都需要调用，这里需要记录这个 Operation 有多少个回调
 一来可以减少 Operation 的创建
 二来可以方便将请求回调到所有调用方
 */
- (void)addHandlesForProgress:(PXYWebImageDownloaderProgressBlock)progressBlock
                     complete:(PXYWebImageDownloaderCompleteBlock)completeBlock {
    
    PXYCallbacksDictionary *callbackDict = [NSMutableDictionary dictionary];
    /* !!!: 为什么这里会需要使用到 Copy 呢 */
    if (progressBlock) callbackDict[kProgressCallbackKey] = progressBlock;
    if (completeBlock) callbackDict[kCompletedCallbackKey] = completeBlock;
    
    [self.callbackBlocks addObject:callbackDict];
}

- (void)cancel:(id)token {
    
}


#pragma mark - Private Methods
/**
 根据 Key 来找出 Array 里面的元素
 DicyArray（key：value）
 retuen ValueArray
 */
- (NSArray <id> *)p_fetchCallbackForKey:(NSString *)key {
    /* !!!: mutableCopy 为什么需要使用 */
    NSMutableArray<id> *callbacks = [[self.callbackBlocks valueForKey:key] mutableCopy];
    [callbacks removeObjectIdenticalTo:[NSNull null]];
    return [callbacks copy];
}

// 取消操作相关
- (void)cancelInternal {
    if (self.isFinished) return;
    
    [super cancel];
    
    if (self.dataTask) {
        [self.dataTask cancel];
        if (self.isExecuting) self.executing = NO;
        if (!self.isFinished) self.finished = YES;
    }
    
    [self reset];
    
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset {
    [self.callbackBlocks removeAllObjects];
    self.dataTask = nil;
    
//    if (self.unownedSession) {
//        [self.unownedSession invalidateAndCancel];
//        self.unownedSession = nil;
//    }
}

- (void)p_callCompletionBlockWithError:(NSError *)error {
    [self p_callCompletionBlockWithImageData:nil image:nil error:error];
}

- (void)p_callCompletionBlockWithImageData:(NSData *)imageData
                                     image:(UIImage *)image
                                     error:(NSError *)error {
    NSArray *completeBlocks = [self p_fetchCallbackForKey:kCompletedCallbackKey];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (PXYWebImageDownloaderCompleteBlock completeBlock in completeBlocks) {
            completeBlock(imageData, image, error);
        }
    });
}

#pragma mark - Setter
// 发出 KVO 通知
- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

#pragma mark - PXYWebImageOperationProtocol
//- (void)cancel {
//
//}

#pragma mark - NSURLSessionDataDelegate
//收到响应
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    NSLog(@"%s",__func__);
    

    NSInteger expected = (NSInteger)response.expectedContentLength;;
    expected = expected > 0 ? expected: 0;
    self.expectedSize = expected;
    
    completionHandler(NSURLSessionResponseAllow);
}

// 接收到数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if (self.imageData == nil) {
        self.imageData = [[NSMutableData alloc] initWithCapacity:self.expectedSize];
    }
    [self.imageData appendData:data];
    
    NSArray *progressBlocks = [self p_fetchCallbackForKey:kProgressCallbackKey];
    for (PXYWebImageDownloaderProgressBlock progressBlock in progressBlocks) {
        progressBlock(0, self.imageData.length);
    }
    
    
    NSLog(@"%s",__func__);
}

#pragma mark - NSURLSessionTaskDelegate
// 收到错误
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    NSLog(@"%s",__func__);
    
    if (error) {
        [self p_callCompletionBlockWithError:error];
        [self done];
    } else {
        NSData *imageData = [self.imageData copy];
        UIImage *image = [UIImage imageWithData:imageData];
        [self p_callCompletionBlockWithImageData:imageData image:image error:error];
        [self done];
    }
    
    
}


@end
