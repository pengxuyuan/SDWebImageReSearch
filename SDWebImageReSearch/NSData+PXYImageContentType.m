//
//  NSData+PXYImageContentType.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/6/26.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "NSData+PXYImageContentType.h"
#import <MobileCoreServices/MobileCoreServices.h>

/*
 图片数据第一个字节
 
 实验结果
 ...
 
 查表：
 ...
 
 这里应该列举常用的图片格式，然后查表：
 
 iOS 系统支持的图片格式：
 ...
 
 最终确定常用的图片格式：
 JPEG
 JPEG-2000
 PNG
 GIF
 TIFF
 WebP
 BMP
 HEIC
 PDF
 */

#define kPXYUTTypeUndefined ((__bridge CFStringRef)@"public.undefined")
#define kPXYUTTypeWebP ((__bridge CFStringRef)@"public.webP")
#define kPXYUTTypeHEIC ((__bridge CFStringRef)@"public.heic")
#define kPXYUTTypeEXR ((__bridge CFStringRef)@"public.exr")


@implementation NSData (PXYImageContentType)

#pragma mark - Public Methods
/**
 获取 ImageData 的图片格式
 */
+ (PXYImageFormat)pxy_fecthImageFormatForImageData:(NSData *)imageData {
    if (imageData == nil) {
        return PXYImageFormatUndefined;
    }
    
    uint8_t c;
    [imageData getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:  return PXYImageFormatJPEG;
        case 0x89:  return PXYImageFormatPNG;
        case 0x47:  return PXYImageFormatGIF;
        case 0x49:
        case 0x4D:  return PXYImageFormatTIFF;
        case 0x42:  return PXYImageFormatBMP;
        case 0x25:  return PXYImageFormatPDF;
        case 0x76:  return PXYImageFormatEXR;
        case 0x52:  {
            if (imageData.length >= 12) {
                NSString *webPStr = [[NSString alloc] initWithData:[imageData subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
                if ([webPStr hasPrefix:@"RIFF"] &&
                    [webPStr hasSuffix:@"WEBP"]) {
                    return PXYImageFormatWebP;
                }
            }
            break;
        }
        case 0x00: {
            if (imageData.length >= 6) {
                NSString *jp2Str = [[NSString alloc] initWithData:[imageData subdataWithRange:NSMakeRange(4, 2)] encoding:NSASCIIStringEncoding];
                if ([jp2Str isEqualToString:@"jP"]) {
                    return  PXYImageFormatJPEG2000;
                }
            }
            
            if (imageData.length >= 12) {
                //....ftypheic ....ftypheix ....ftyphevc ....ftyphevx
                NSString *testString = [[NSString alloc] initWithData:[imageData subdataWithRange:NSMakeRange(4, 8)] encoding:NSASCIIStringEncoding];
                if ([testString isEqualToString:@"ftypheic"]
                    || [testString isEqualToString:@"ftypheix"]
                    || [testString isEqualToString:@"ftyphevc"]
                    || [testString isEqualToString:@"ftyphevx"]) {
                    return PXYImageFormatHEIC;
                }
            }
            break;
        }
            
        default:
            break;
    }
    
    return PXYImageFormatUndefined;
}

/**
 将 PXYImageFormat 转换成 UTType String
 */
+ (nonnull CFStringRef)pxy_fectchUTTypeForPXYImageFormat:(PXYImageFormat)imageFormat {
    CFStringRef UTType;
    
    switch (imageFormat) {
        case PXYImageFormatUndefined:
            UTType = kPXYUTTypeUndefined;
            break;
        case PXYImageFormatJPEG:
            UTType = kUTTypeJPEG;
            break;
        case PXYImageFormatJPEG2000:
            UTType = kUTTypeJPEG2000;
            break;
        case PXYImageFormatPNG:
            UTType = kUTTypePNG;
            break;
        case PXYImageFormatGIF:
            UTType = kUTTypeGIF;
            break;
        case PXYImageFormatTIFF:
            UTType = kUTTypeTIFF;
            break;
        case PXYImageFormatWebP:
            UTType = kPXYUTTypeWebP;
            break;
        case PXYImageFormatHEIC:
            UTType = kPXYUTTypeHEIC;
            break;
        case PXYImageFormatBMP:
            UTType = kUTTypeBMP;
            break;
        case PXYImageFormatPDF:
            UTType = kUTTypePDF;
            break;
        case PXYImageFormatEXR:
            UTType = kPXYUTTypeEXR;
            break;
            
        default:
            UTType = kUTTypePNG;
            break;
    }
    
    return UTType;
}


@end
