//
//  PXYWebImageManager.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/6.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "PXYWebImageManager.h"
#import "PXYImageCacheManager.h"

@interface PXYWebImageManager()

@property (nonatomic, strong, readwrite) PXYWebImageDownloader *imageDownloader;

@end

@implementation PXYWebImageManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static PXYWebImageManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [PXYWebImageManager new];
    });
    
    return instance;
}

#pragma mark - Plublic Methods
- (void)downloadImageWithImageUrl:(NSURL *)url
                                                           options:(PXYWebImageDownloaderOptions)options
                                                          progress:(PXYWebImageDownloaderProgressBlock)prpgressBlock
                                                    compeleteBlock:(PXYWebImageDownloaderCompleteBlock)compeleteBlock {
    /*
     1.根据 URL 去内存查找
     2.然后去磁盘查找
     3.都没有就去网络请求
     4.请求完之后写磁盘&内存
     */
    NSString *urlKey = [url absoluteString];
    
    [[PXYImageCacheManager shareInstance] fetchCacheOperationForKey:urlKey completion:^(UIImage *image, NSData *imageData, PXYImageCacheType cacheType) {
        if (image) {
            compeleteBlock(imageData, image, nil);
            return;
        }
        
        
        [self.imageDownloader downloadImageWithImageUrl:url options:PXYWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            prpgressBlock(receivedSize, expectedSize);
        } compeleteBlock:^(NSData *imageData, UIImage *image, NSError *error) {
            compeleteBlock(imageData, image, error);
            if (!error) {
                NSData *imageData1 = imageData;
                UIImage *image1 = image;
                [[PXYImageCacheManager shareInstance] fetchCacheOperationForKey:urlKey completion:^(UIImage *image, NSData *imageData, PXYImageCacheType cacheType) {
                    if (image == nil) {
                        [[PXYImageCacheManager shareInstance] storeImage:image1 imageData:imageData1 forKey:urlKey toDisk:YES completion:nil];
                    }
                }];
            }
        }];
    }];
}

#pragma mark - Lazzy load
- (PXYWebImageDownloader *)imageDownloader {
    if (_imageDownloader == nil) {
        _imageDownloader = [PXYWebImageDownloader shareInstance];
    }
    return _imageDownloader;
}


@end
