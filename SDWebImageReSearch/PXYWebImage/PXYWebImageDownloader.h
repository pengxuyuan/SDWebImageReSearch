//
//  PXYWebImageDownloader.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/6.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^PXYWebImageDownloadCompleteBlock)(NSData *imageData,UIImage *image,NSError *error);

/**
 图片下载类 负责下载图片
 */
@interface PXYWebImageDownloader : NSObject

+ (instancetype)shareInstance;

- (void)downloadImageWithImageUrl:(NSURL *)url compeleteBlock:(PXYWebImageDownloadCompleteBlock)compelete;

@end
