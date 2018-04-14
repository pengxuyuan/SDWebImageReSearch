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
               complete:(PXYWebImageDownloadCompleteBlock)completeBlock {
    [self setImageWithURL:url placeholderImage:nil progress:nil complete:completeBlock];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
               complete:(PXYWebImageDownloadCompleteBlock)completeBlock {
    [self setImageWithURL:url placeholderImage:placeholder progress:nil complete:completeBlock];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
               progress:(PXYWebImageDownloadProgressBlock)progressBlock
               complete:(PXYWebImageDownloadCompleteBlock)completeBlock {
    if (placeholder) {
        self.image = placeholder;
    }
    
    [[PXYWebImageManager shareInstance] downloadImageWithImageUrl:url compeleteBlock:^(NSData *imageData, UIImage *image, NSError *error) {
        if (image) {
            self.image = image;
        }
        
        if (completeBlock) {
            completeBlock(imageData,image,error);
        }
        
    }];
}

@end
