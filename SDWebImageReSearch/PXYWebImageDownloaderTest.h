//
//  PXYWebImageDownloader.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/6.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^PXYWebImageDownloadCompleteBlock)(UIImage *image, NSError *error);

//图片下载
@interface PXYWebImageDownloaderTest : NSObject

+ (instancetype)shareInstance;

- (void)downloadImageWithUrl:(NSURL *)url compelete:(PXYWebImageDownloadCompleteBlock)completeBlock;

@end
