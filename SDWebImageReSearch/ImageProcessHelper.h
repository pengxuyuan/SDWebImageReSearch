//
//  ImageProcessHelper.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/4/13.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

//FOUNDATION_EXPORT UIImageOrientation PXYImageOrientationFromExifOrientation (CGImagePropertyOrientation exifOrientation);
//FOUNDATION_EXPORT UIImage* PXYFetchRenderImageWithOriginImage (UIImage *image);
//FOUNDATION_EXPORT UIImage* PXYFetchThumbnailImageFromFileName (NSString *fileName, int imageSize);
//FOUNDATION_EXPORT UIImage* PXYCreateUIImageFromFileName (NSString *fileName);
//FOUNDATION_EXPORT UIImage * PXYIncrementallyImageWithImageData (NSData *imageData, BOOL finalized);
//FOUNDATION_EXPORT NSDictionary* PXYFetchImagePropertiesWithImageName (NSString *fileName);
//FOUNDATION_EXPORT NSArray* PropTree (NSDictionary *dict);


/**
 将 CGImagePropertyOrientation 转换成 UIImageOrientation
 */
UIImageOrientation PXYImageOrientationFromExifOrientation (CGImagePropertyOrientation exifOrientation);

/**
 利用 Core Foundation 框架绘制图片
 */
UIImage* PXYFetchRenderImageWithOriginImage (UIImage *image);

/**
 生成一张缩略图
 */
UIImage* PXYFetchThumbnailImageFromFileName (NSString *fileName, int imageSize);

/**
 解压本地图片
 */
UIImage* PXYCreateUIImageFromFileName (NSString *fileName);

/**
 利用 ImageData 创建渐进式图片
 */
UIImage * PXYIncrementallyImageWithImageData (NSData *imageData, BOOL finalized);

/**
 返回图片的属性
 */
NSDictionary* PXYFetchImagePropertiesWithImageName (NSString *fileName);

/**
 属性树
 */
NSArray* PropTree (NSDictionary *dict);

/**
 获取一张图片的 UTType
 */
NSString* PXYFecthImageUTType (UIImage *image);

/**
 根据 ImageUrl 是否存在 @2x、@3x 来缩放图片
 */
UIImage* PXYFetchScaleImage (NSString *imageUrl, UIImage *image);




