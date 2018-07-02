//
//  UIImageView+PXYWebCache.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/18.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PXYWebImageDownloaderProgressBlock) (NSInteger receivedSize, NSInteger expectedSize);
typedef void (^PXYWebImageDownloaderCompleteBlock) (NSData *imageData, UIImage *image, NSError *error);


/**
 为了外界更好的调用
 */
@interface UIImageView (PXYWebCache)

- (void)setImageWithURL:(NSURL *)url;

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder;

- (void)setImageWithURL:(NSURL *)url
               complete:(PXYWebImageDownloaderCompleteBlock)completeBlock;

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
               complete:(PXYWebImageDownloaderCompleteBlock)completeBlock;

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
               progress:(PXYWebImageDownloaderProgressBlock)progressBlock
               complete:(PXYWebImageDownloaderCompleteBlock)completeBlock;


@end
