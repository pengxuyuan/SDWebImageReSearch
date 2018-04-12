//
//  UIImageView+PXYWebCache.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/18.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PXYWebImageDownloadCompleteBlock)(NSData *imageData,UIImage *image,NSError *error);
typedef void (^PXYWebImageDownloadProgressBlock)(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL);


/**
 为了外界更好的调用
 */
@interface UIImageView (PXYWebCache)

- (void)setImageWithURL:(NSURL *)url;

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder;

- (void)setImageWithURL:(NSURL *)url
               complete:(PXYWebImageDownloadCompleteBlock)completeBlock;

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
               complete:(PXYWebImageDownloadCompleteBlock)completeBlock;

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
               progress:(PXYWebImageDownloadProgressBlock)progressBlock
               complete:(PXYWebImageDownloadCompleteBlock)completeBlock;


@end
