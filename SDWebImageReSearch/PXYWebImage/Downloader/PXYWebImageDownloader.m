//
//  PXYWebImageDownloader.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/6.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "PXYWebImageDownloader.h"
#import "NSOperation+PXYWebImageExtension.h"

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

/**
 保存当前队列里面存在的操作，可以确保相同的 URL 不会再次创建操作放入队列中
 防止多次请求
 */
@property (nonatomic, strong) NSMutableDictionary <NSString *,NSBlockOperation *>*operationDict;


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

#pragma mark - Public Methods
- (void)downloadImageWithImageUrl:(NSURL *)url compeleteBlock:(PXYWebImageDownloadCompleteBlock)compelete {
    NSString *urlStr = [url absoluteString];
    NSBlockOperation *operation = self.operationDict[urlStr];
    if (operation == nil) {
        __weak typeof(self) weakSelf = self;
        operation = [NSBlockOperation blockOperationWithBlock:^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf realDownloadImageWithImageUrl:url compeleteBlock:^(NSData *imageData, UIImage *image, NSError *error) {
                NSBlockOperation *tempOperation = self.operationDict[urlStr];
                
                if (tempOperation.operationCallbackArray.count > 0) {
                    for (NSMutableDictionary *callbackDict in tempOperation.operationCallbackArray) {
                        PXYWebImageDownloadCompleteBlock completeBlock = callbackDict[@"compeleteBlock"];
                        completeBlock(imageData, image, error);
                    }
                }
                
                [strongSelf.operationDict removeObjectForKey:urlStr];
            }];
            
        }];
        
        if (operation.operationCallbackArray == nil) operation.operationCallbackArray = [NSMutableArray array];
        NSMutableDictionary *callbackDict = [NSMutableDictionary dictionary];
        if (compelete) callbackDict[@"compeleteBlock"] = compelete;
        [operation.operationCallbackArray addObject:callbackDict];
        
        [self.downloadQueue addOperation:operation];
        self.operationDict[urlStr] = operation;
    } else {
        NSLog(@"下载队列已经存在该 URL 请求：%@",url);
        
        NSMutableDictionary *callbackDict = [NSMutableDictionary dictionary];
        if (compelete) callbackDict[@"compeleteBlock"] = compelete;
        [operation.operationCallbackArray addObject:callbackDict];
    }
}

#pragma mark - Private Methods
- (void)realDownloadImageWithImageUrl:(NSURL *)url compeleteBlock:(PXYWebImageDownloadCompleteBlock)compelete {
    NSLog(@"开始下载图片：%@",url);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:self.downloadQueue];
    
    // 方式一下载
//    [[session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error) {
//            compelete(nil,nil,error);
//            NSLog(@"downloadImageWithURLSeesion error:%@",error);
//            return ;
//        }
//
//        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:response.suggestedFilename];
//        NSURL *fileUrl = [NSURL fileURLWithPath:fullPath];
//
//        [[NSFileManager defaultManager] moveItemAtURL:location toURL:fileUrl error:nil];
//
//        NSData *fileData = [NSData dataWithContentsOfURL:fileUrl];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"下载成功图片：%@",url);
//            UIImage *image = [UIImage imageWithData:fileData];
//            compelete(fileData,image,error);
//        });
//    }] resume];
    
    // 方式二下载
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url];
    [downloadTask resume];
}

#pragma mark - NSURLSessionDelegate
/* The last message a session receives.  A session will only become
 * invalid because of a systemic error or when it has been
 * explicitly invalidated, in which case the error parameter will be nil.
 */
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    NSLog(@"%s",__func__);
}

/* If implemented, when a connection level authentication challenge
 * has occurred, this delegate will be given the opportunity to
 * provide authentication credentials to the underlying
 * connection. Some types of authentication will apply to more than
 * one request on a given connection to a server (SSL Server Trust
 * challenges).  If this delegate message is not implemented, the
 * behavior will be to use the default handling, which may involve user
 * interaction.
 */
//- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
// completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
//    NSLog(@"%s",__func__);
//}

/* If an application has received an
 * -application:handleEventsForBackgroundURLSession:completionHandler:
 * message, the session delegate will receive this message to indicate
 * that all messages previously enqueued for this session have been
 * delivered.  At this time it is safe to invoke the previously stored
 * completion handler, or to begin any internal updates that will
 * result in invoking the completion handler.
 */
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    NSLog(@"%s",__func__);
}

#pragma mark - NSURLSessionDataDelegate
/* The task has received a response and no further messages will be
 * received until the completion block is called. The disposition
 * allows you to cancel a request or to turn a data task into a
 * download task. This delegate message is optional - if you do not
 * implement it, you can get the response as a property of the task.
 *
 * This method will not be called for background upload tasks (which cannot be converted to download tasks).
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    NSLog(@"%s",__func__);
}

/* Notification that a data task has become a download task.  No
 * future messages will be sent to the data task.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    NSLog(@"%s",__func__);
}

/*
 * Notification that a data task has become a bidirectional stream
 * task.  No future messages will be sent to the data task.  The newly
 * created streamTask will carry the original request and response as
 * properties.
 *
 * For requests that were pipelined, the stream object will only allow
 * reading, and the object will immediately issue a
 * -URLSession:writeClosedForStream:.  Pipelining can be disabled for
 * all requests in a session, or by the NSURLRequest
 * HTTPShouldUsePipelining property.
 *
 * The underlying connection is no longer considered part of the HTTP
 * connection cache and won't count against the total number of
 * connections per host.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask {
    NSLog(@"%s",__func__);
}

/* Sent when data is available for the delegate to consume.  It is
 * assumed that the delegate will retain and not copy the data.  As
 * the data may be discontiguous, you should use
 * [NSData enumerateByteRangesUsingBlock:] to access it.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    NSLog(@"%s",__func__);
}

/* Invoke the completion routine with a valid NSCachedURLResponse to
 * allow the resulting data to be cached, or pass nil to prevent
 * caching. Note that there is no guarantee that caching will be
 * attempted for a given resource, and you should not rely on this
 * message to receive the resource data.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler {
    NSLog(@"%s",__func__);
}

#pragma mark - NSURLSessionTaskDelegate
/*
 * Sent when the system is ready to begin work for a task with a delayed start
 * time set (using the earliestBeginDate property). The completionHandler must
 * be invoked in order for loading to proceed. The disposition provided to the
 * completion handler continues the load with the original request provided to
 * the task, replaces the request with the specified task, or cancels the task.
 * If this delegate is not implemented, loading will proceed with the original
 * request.
 *
 * Recommendation: only implement this delegate if tasks that have the
 * earliestBeginDate property set may become stale and require alteration prior
 * to starting the network load.
 *
 * If a new request is specified, the allowsCellularAccess property from the
 * new request will not be used; the allowsCellularAccess property from the
 * original request will continue to be used.
 *
 * Canceling the task is equivalent to calling the task's cancel method; the
 * URLSession:task:didCompleteWithError: task delegate will be called with error
 * NSURLErrorCancelled.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willBeginDelayedRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLSessionDelayedRequestDisposition disposition, NSURLRequest * _Nullable newRequest))completionHandler {
    NSLog(@"%s",__func__);
}

/*
 * Sent when a task cannot start the network loading process because the current
 * network connectivity is not available or sufficient for the task's request.
 *
 * This delegate will be called at most one time per task, and is only called if
 * the waitsForConnectivity property in the NSURLSessionConfiguration has been
 * set to YES.
 *
 * This delegate callback will never be called for background sessions, because
 * the waitForConnectivity property is ignored by those sessions.
 */
- (void)URLSession:(NSURLSession *)session taskIsWaitingForConnectivity:(NSURLSessionTask *)task {
    NSLog(@"%s",__func__);
}

/* An HTTP request is attempting to perform a redirection to a different
 * URL. You must invoke the completion routine to allow the
 * redirection, allow the redirection with a modified request, or
 * pass nil to the completionHandler to cause the body of the redirection
 * response to be delivered as the payload of this request. The default
 * is to follow redirections.
 *
 * For tasks in background sessions, redirections will always be followed and this method will not be called.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    NSLog(@"%s",__func__);
}

/* The task has received a request specific authentication challenge.
 * If this delegate is not implemented, the session specific authentication challenge
 * will *NOT* be called and the behavior will be the same as using the default handling
 * disposition.
 */
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
//didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
// completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
//    NSLog(@"%s",__func__);
//}

/* Sent if a task requires a new, unopened body stream.  This may be
 * necessary when authentication has failed for any request that
 * involves a body stream.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * _Nullable bodyStream))completionHandler {
    NSLog(@"%s",__func__);
}

/* Sent periodically to notify the delegate of upload progress.  This
 * information is also available as properties of the task.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    NSLog(@"%s",__func__);
}

/*
 * Sent when complete statistics information has been collected for the task.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {
    NSLog(@"%s",__func__);
}

/* Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    NSLog(@"%s",__func__);
}

#pragma mark - NSURLSessionStreamDelegate
/* Indiciates that the read side of a connection has been closed.  Any
 * outstanding reads complete, but future reads will immediately fail.
 * This may be sent even when no reads are in progress. However, when
 * this delegate message is received, there may still be bytes
 * available.  You only know that no more bytes are available when you
 * are able to read until EOF. */
- (void)URLSession:(NSURLSession *)session readClosedForStreamTask:(NSURLSessionStreamTask *)streamTask {
    NSLog(@"%s",__func__);
}

/* Indiciates that the write side of a connection has been closed.
 * Any outstanding writes complete, but future writes will immediately
 * fail.
 */
- (void)URLSession:(NSURLSession *)session writeClosedForStreamTask:(NSURLSessionStreamTask *)streamTask {
    NSLog(@"%s",__func__);
}

/* A notification that the system has determined that a better route
 * to the host has been detected (eg, a wi-fi interface becoming
 * available.)  This is a hint to the delegate that it may be
 * desirable to create a new task for subsequent work.  Note that
 * there is no guarantee that the future task will be able to connect
 * to the host, so callers should should be prepared for failure of
 * reads and writes over any new interface. */
- (void)URLSession:(NSURLSession *)session betterRouteDiscoveredForStreamTask:(NSURLSessionStreamTask *)streamTask {
    NSLog(@"%s",__func__);
}

/* The given task has been completed, and unopened NSInputStream and
 * NSOutputStream objects are created from the underlying network
 * connection.  This will only be invoked after all enqueued IO has
 * completed (including any necessary handshakes.)  The streamTask
 * will not receive any further delegate messages.
 */
- (void)URLSession:(NSURLSession *)session streamTask:(NSURLSessionStreamTask *)streamTask
didBecomeInputStream:(NSInputStream *)inputStream
      outputStream:(NSOutputStream *)outputStream {
    NSLog(@"%s",__func__);
}

#pragma mark - NSURLSessionDownloadDelegate
/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"%s",__func__);
}


/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"%s",__func__);
}

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"%s",__func__);
}


#pragma mark - Lazzy load
- (NSOperationQueue *)downloadQueue {
    if (_downloadQueue == nil) {
        _downloadQueue = [NSOperationQueue new];
    }
    return _downloadQueue;
}

- (NSMutableDictionary<NSString *,NSBlockOperation *> *)operationDict {
    if (_operationDict == nil) {
        _operationDict = [NSMutableDictionary dictionary];
    }
    return _operationDict;
}


@end
