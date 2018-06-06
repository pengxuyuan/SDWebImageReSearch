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


UIImageOrientation PXYImageOrientationFromExifOrientation (CGImagePropertyOrientation exifOrientation);
UIImage* PXYFetchRenderImageWithOriginImage (UIImage *image);
UIImage* PXYFetchThumbnailImageFromFileName (NSString *fileName, int imageSize);
UIImage* PXYCreateUIImageFromFileName (NSString *fileName);
UIImage * PXYIncrementallyImageWithImageData (NSData *imageData, BOOL finalized);
NSDictionary* PXYFetchImagePropertiesWithImageName (NSString *fileName);
NSArray* PropTree (NSDictionary *dict);




