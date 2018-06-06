//
//  ImageResearchController.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/6/5.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "ImageResearchController.h"

@interface ImageResearchController ()

@end

@implementation ImageResearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //mew_baseline.png
    //843字节 30*30   30*30*4 = 3600
    //颜色空间 RGB
    //Alpha 通道：否
    
    UIImage *image = [UIImage imageNamed:@"check_green.png"];
    CGSize imageSize = image.size; //30 * 30
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSInteger imageDataL = [imageData length]; //789
    double dataLength = imageDataL * 1.0;
    NSArray *typeArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB",@"ZB",@"YB"];
    NSInteger index = 0;
    while (dataLength > 1024) {
        dataLength /= 1024.0;
        index ++;
    }
    NSLog(@"image = %.3f %@",dataLength,typeArray[index]);//947.33203125 KB
    
    CGImageRef imageRef = image.CGImage;
    size_t w = CGImageGetWidth(imageRef); //30
    size_t h = CGImageGetHeight(imageRef); //30
    size_t bpc = CGImageGetBitsPerComponent(imageRef); //8
    size_t bpp = CGImageGetBitsPerPixel(imageRef); //32
    size_t bpr = CGImageGetBytesPerRow(imageRef); //120
    CGColorSpaceRef spaceRef = CGImageGetColorSpace(imageRef);
    CGImageAlphaInfo alphaInfoRef = CGImageGetAlphaInfo(imageRef);
    CGDataProviderRef dataProviderRef = CGImageGetDataProvider(imageRef);
    const CGFloat *decode = CGImageGetDecode(imageRef);
    bool s = CGImageGetShouldInterpolate(imageRef); //true
    CGColorRenderingIntent renderingI = CGImageGetRenderingIntent(imageRef);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef); //1
    CFStringRef UTType = CGImageGetUTType(imageRef); //public.png
    
    CFDataRef dataRef = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    CFIndex l = CFDataGetLength(dataRef); //3600
    const UInt8 *bp = CFDataGetBytePtr(dataRef);
    UInt8 *mbp = CFDataGetMutableBytePtr(dataRef);
   
}


@end
