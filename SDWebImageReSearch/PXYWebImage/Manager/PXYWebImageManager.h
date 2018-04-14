//
//  PXYWebImageManager.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/6.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXYWebImageDownloader.h"

/**
 WebImage 管理类，封装下载和缓存逻辑
 */
@interface PXYWebImageManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong, readonly) PXYWebImageDownloader *imageDownloader;

- (void)downloadImageWithImageUrl:(NSURL *)url compeleteBlock:(PXYWebImageDownloadCompleteBlock)compelete;

@end
