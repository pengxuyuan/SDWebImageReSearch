//
//  NSData+PXYImageContentType.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/6/26.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PXYImageFormat) {
    PXYImageFormatUndefined = -1,
    PXYImageFormatJPEG = 0,
    PXYImageFormatJPEG2000,
    PXYImageFormatPNG,
    PXYImageFormatGIF,
    PXYImageFormatTIFF,
    PXYImageFormatWebP,
    PXYImageFormatHEIC,
    PXYImageFormatBMP,
    PXYImageFormatPDF,
    PXYImageFormatEXR
};

@interface NSData (PXYImageContentType)

/**
 获取 ImageData 的图片格式
 */
+ (PXYImageFormat)pxy_fecthImageFormatForImageData:(NSData *)imageData;

/**
 将 PXYImageFormat 转换成 UTType String
 */
+ (nonnull CFStringRef)pxy_fectchUTTypeForPXYImageFormat:(PXYImageFormat)imageFormat;

@end
