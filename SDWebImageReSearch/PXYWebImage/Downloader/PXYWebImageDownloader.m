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
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    [[session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            compelete(nil,nil,error);
            NSLog(@"downloadImageWithURLSeesion error:%@",error);
            return ;
        }
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:response.suggestedFilename];
        NSURL *fileUrl = [NSURL fileURLWithPath:fullPath];
        
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:fileUrl error:nil];
        
        NSData *fileData = [NSData dataWithContentsOfURL:fileUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:fileData];
            compelete(fileData,image,error);
            NSLog(@"下载成功图片：%@",url);
        });
    }] resume];
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
