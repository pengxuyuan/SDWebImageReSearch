//
//  UIImageView+PXYWebCache.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/18.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "UIImageView+PXYWebCache.h"
#import "PXYWebImageManager.h"

@implementation UIImageView (PXYWebCache)

- (void)setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholderImage:nil progress:nil complete:nil];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder {
    [self setImageWithURL:url placeholderImage:placeholder progress:nil complete:nil];
}

- (void)setImageWithURL:(NSURL *)url
               complete:(PXYWebImageDownloaderCompleteBlock)completeBlock {
    [self setImageWithURL:url placeholderImage:nil progress:nil complete:completeBlock];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
               complete:(PXYWebImageDownloaderCompleteBlock)completeBlock {
    [self setImageWithURL:url placeholderImage:placeholder progress:nil complete:completeBlock];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
               progress:(PXYWebImageDownloaderProgressBlock)progressBlock
               complete:(PXYWebImageDownloaderCompleteBlock)completeBlock {
    if (placeholder) {
        self.image = placeholder;
    }
    
    [[PXYWebImageManager shareInstance] downloadImageWithImageUrl:url options:PXYWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } compeleteBlock:^(NSData *imageData, UIImage *image, NSError *error) {
        if (image) {
            self.image = image;
        }
        
        if (completeBlock) {
            completeBlock(imageData,image,error);
        }
    }];
    
}

@end
