//
//  ImageProcessHelper.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/4/13.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "ImageProcessHelper.h"

//苹果官方代码
//利用一个图片路径来创建一张 CGImage
UIImage* PXYCreateUIImageFromFileName (NSString *fileName) {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@""];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    CGImageSourceRef imageSourceRef;
    CFDictionaryRef myOptions = NULL;
    CFStringRef myKey[2];
    CFTypeRef myValues[2];
    
    myKey[0] = kCGImageSourceShouldCache;
    myValues[0] = (CFTypeRef)kCFBooleanTrue;
    
    myKey[1] = kCGImageSourceShouldAllowFloat;
    myValues[1] = (CFTypeRef)kCFBooleanTrue;
    
    myOptions = CFDictionaryCreate(NULL,
                                   (const void **)myKey,
                                   (const void **)myValues,
                                   2,
                                   &kCFTypeDictionaryKeyCallBacks,
                                   &kCFTypeDictionaryValueCallBacks);
    
    imageSourceRef = CGImageSourceCreateWithURL((__bridge CFURLRef)url, myOptions);
    CFRelease(myOptions);
    
    if (imageSourceRef == NULL) {
        fprintf(stderr, "图片资源没找到");
        return nil;
    }
    
    NSUInteger frameCount = CGImageSourceGetCount(imageSourceRef);
    NSString *imageType = (__bridge NSString *)CGImageSourceGetType(imageSourceRef);
//    NSLog(@"imageType: %@",imageType);
//    NSLog(@"图片帧数：%lu",(unsigned long)frameCount);
    NSMutableArray <UIImage *> *images = [NSMutableArray array];
    double totalDuration = 0;
    for (size_t i = 0; i < frameCount; i++) {
        @autoreleasepool {
            NSDictionary *frameProperties = (__bridge NSDictionary *) CGImageSourceCopyPropertiesAtIndex(imageSourceRef, i, NULL);
            NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary]; // GIF属性字典
            double duration = [gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime] doubleValue]; // GIF原始的帧持续时长，秒数
            NSLog(@"duration: %f",duration);
            CGImagePropertyOrientation exifOrientation = (CGImagePropertyOrientation)[frameProperties[(__bridge NSString *)kCGImagePropertyOrientation] integerValue]; // 方向
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSourceRef, i, NULL); // CGImage
            UIImageOrientation imageOrientation = PXYImageOrientationFromExifOrientation(exifOrientation);
            UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:imageOrientation];
//            UIImage *image = [UIImage imageWithCGImage:imageRef];
            totalDuration += duration;
            
            image = PXYFetchRenderImageWithOriginImage(image);
            [images addObject:image];
            CGImageRelease(imageRef);
        };
    }
    
    UIImage *image = [UIImage animatedImageWithImages:images duration:totalDuration];
    CFRelease(imageSourceRef);
    return image;
}

//创建一张缩略图
UIImage* PXYFetchThumbnailImageFromFileName (NSString *fileName, int imageSize) {
    CGImageSourceRef imageSourceRef;
    CGImageRef myThumbnailImage = NULL;
    
    CFDictionaryRef myOptions = NULL;
    CFStringRef myKeys[3];
    CFTypeRef myValues[3];
    CFNumberRef thumbnailSize;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@""];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    imageSourceRef = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
    if (imageSourceRef == NULL) {
        fprintf(stderr, "转换失败");
        return NULL;
    }
    
    thumbnailSize = CFNumberCreate(NULL, kCFNumberIntType, &imageSize);
    
    myKeys[0] = kCGImageSourceCreateThumbnailWithTransform;
    myValues[0] = (CFTypeRef)kCFBooleanTrue;
    
    myKeys[1] = kCGImageSourceCreateThumbnailFromImageIfAbsent;
    myValues[1] = (CFTypeRef)kCFBooleanTrue;
    
    myKeys[2] = kCGImageSourceThumbnailMaxPixelSize;
    myValues[2] = (CFTypeRef)thumbnailSize;
    
    myOptions = CFDictionaryCreate(NULL,
                                   (const void **)myKeys,
                                   (const void **)myValues,
                                   2,
                                   &kCFTypeDictionaryKeyCallBacks,
                                   &kCFTypeDictionaryValueCallBacks);
    
    myThumbnailImage = CGImageSourceCreateThumbnailAtIndex(imageSourceRef, 0, myOptions);
    CFRelease(thumbnailSize);
    CFRelease(myOptions);
    CFRelease(imageSourceRef);
    
    if (myThumbnailImage == NULL) {
        fprintf(stderr, "Thumbnail 图片转换失败");
        return NULL;
    }
    
    return [UIImage imageWithCGImage:myThumbnailImage];
}

//渐进式图片
UIImage * PXYIncrementallyImageWithImageData (NSData *imageData, BOOL finalized) {
    CFDataRef dataRef = (__bridge CFDataRef)imageData;
    CGImageSourceRef imageSource = CGImageSourceCreateIncremental(NULL);
    
    bool finished = finalized;
    CGImageSourceUpdateData(imageSource, dataRef, finished);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    image = PXYFetchRenderImageWithOriginImage(image);
    CGImageRelease(imageRef);
    CFRelease(imageSource);
    return image;
}


UIImage* PXYFetchRenderImageWithOriginImage (UIImage *image){
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:image];
    //1. 开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO,0.0);
    
    //2. 获取当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //3. 把控制器的view的内容 渲染 到上下文当中.
    //注意: layer是不能直接画到上下文当中(不能用draw),必须得要渲染的方法才到绘制到上下文(必须用render)
    [tempImageView.layer renderInContext:ctx];
    
    //4. 从上下文当中生成一张图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //5. 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

UIImageOrientation PXYImageOrientationFromExifOrientation (CGImagePropertyOrientation exifOrientation){
    switch (exifOrientation) {
        case kCGImagePropertyOrientationUp:
            return UIImageOrientationUp;
            break;
        case kCGImagePropertyOrientationUpMirrored:
            return UIImageOrientationUpMirrored;
            break;
        case kCGImagePropertyOrientationDown:
            return UIImageOrientationDown;
            break;
        case kCGImagePropertyOrientationDownMirrored:
            return UIImageOrientationDownMirrored;
            break;
        case kCGImagePropertyOrientationLeftMirrored:
            return UIImageOrientationLeftMirrored;
            break;
        case kCGImagePropertyOrientationRight:
            return UIImageOrientationRight;
            break;
        case kCGImagePropertyOrientationRightMirrored:
            return UIImageOrientationRightMirrored;
            break;
        case kCGImagePropertyOrientationLeft:
            return UIImageOrientationLeft;
            break;
        default:
            return UIImageOrientationUp;
            break;
    }
    
    return UIImageOrientationUp;
}

