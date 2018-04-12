//
//  UIImage+WCImage.h
//  textApp
//
//  Created by MacBook on 2017/4/11.
//  Copyright © 2017年 王创. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^successBlock)(UIImage *downLoadImage);

@interface UIImage (WCImage)

/**
 本地图片(支持GIF)

 @param name 图片名称
 @return image对象
 */
+(instancetype)wc_imageByLocalName:(NSString *)name;

/**
 本地图片. imageSize 生成的图片对应的大小

 @param name 图片名称
 @param imageSize 想要的图片尺寸
 @return image对象
 */
+(instancetype)wc_imageByLocalName:(NSString *)name imageSize:(CGSize)imageSize;

/**
 本地图片, 拉伸图片.(平铺模式、中间1*1拉伸模式)

 @param name 图片名称
 @param resizeMode 拉伸模式
 @return image对象
 */
+(instancetype)wc_imageByLocalName:(NSString *)name resizeMode:(UIImageResizingMode)resizeMode;

/**
 本地图片, 保护区域,拉伸模式

 @param name 图片名称
 @param protectInsets 保护区域
 @param resizeMode 拉伸模式
 @return image对象
 */
+(instancetype)wc_imageByLocalName:(NSString *)name protectInsets:(UIEdgeInsets)protectInsets resizeMode:(UIImageResizingMode)resizeMode;

/**
 网络图片

 @param name 图片下载链接
 @param block 成功回调block
 */
+(void)wc_imageByNetName:(NSString *)name successBlock:(successBlock)block;

/**
 视频截第n帧图片

 @param name 本地视频名称
 @param index 第几帧
 @return 第几帧图片
 */
+(instancetype)wc_imageByMovieName:(NSString *)name index:(NSInteger)index;

/**
 绘制对应尺寸的图片

 @param imageSize 想要的图片尺寸
 @return image对象
 */
-(UIImage *)wc_imageWithImageSize:(CGSize)imageSize;

@end
