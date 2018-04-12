//
//  PXYWebImageDownloader.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/6.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "PXYWebImageDownloaderTest.h"

@interface PXYWebImageDownloaderTest ()

@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@end

@implementation PXYWebImageDownloaderTest
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static PXYWebImageDownloaderTest *instance;
    dispatch_once(&onceToken, ^{
        instance = [PXYWebImageDownloaderTest new];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _downloadQueue = [NSOperationQueue new];
    }
    return self;
}

- (void)downloadImageWithUrl:(NSURL *)url compelete:(PXYWebImageDownloadCompleteBlock)completeBlock {
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [self downloadWitUrl:url compelete:completeBlock];
    }];
    [self.downloadQueue addOperation:operation];
}

- (void)downloadWitUrl:(NSURL *)url compelete:(PXYWebImageDownloadCompleteBlock)completeBlock {
    NSLog(@"开始下载图片：%@",url);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    [[session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completeBlock(nil,error);
            NSLog(@"downloadImageWithURLSeesion error:%@",error);
            return ;
        }
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:response.suggestedFilename];
        NSURL *fileUrl = [NSURL fileURLWithPath:fullPath];
        
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:fileUrl error:nil];
        
        NSData *fileNata = [NSData dataWithContentsOfURL:fileUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:fileNata];
            completeBlock(image,error);
            NSLog(@"下载成功图片：%@",url);
        });
    }] resume];
}

@end
