//
//  ViewController.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/2/26.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "ViewController.h"
#import "ListViewController.h"
#import "PXYImageCacheManager.h"
#import "NSMutableArray+PXYExtension.h" 
#import "NSMutableDictionary+PXYExtension.h"
#import "ListTableViewModel.h"
#import "UIImage+WCImage.h"
#import "GenericsModel.h"

/*
 1.NSData 几种换取方式有差别，有些把图片的信息删除了
 NSString *filePath = [[NSBundle mainBundle] pathForResource:@"HomeActivity1@2x.png" ofType:@""];
 UIImage *image1 = [UIImage imageNamed:@"HomeActivity1@2x.png"];
 UIImage *image2 = [UIImage imageWithContentsOfFile:filePath];
 NSData *imageData1 = UIImagePNGRepresentation(image1);
 NSData *imageData2 = UIImagePNGRepresentation(image2);
 NSData *imageData3 = [NSData dataWithContentsOfFile:filePath];
 
 //点：414 * 736  像素：1242 * 2208 5.5 英寸
 //250*150 55KB  37500个像素 (1个像素有4个通道 1个通道占8位 共4个字节 32位)
 //37500 * 4 = 150000
 
 
 
 
 */



@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;


@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"HomeActivity1@2x.png" ofType:@""];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    self.imageView.image = [self decodeImageWithImageData:imageData];
    
    NSString *filePath22 = [[NSBundle mainBundle] pathForResource:@"timg5.gif" ofType:@""];
    NSData *imageData22 = [NSData dataWithContentsOfFile:filePath22];

    UIImage *image = [self decodeImageWithImageData:imageData22];
    self.imageView2.image = image;
//    self.imageView2.image = [UIImage wc_imageByLocalName:@"timg5.gif"];
    
    //编码
    NSData *imageData1 = [self encodeImageWithImage:self.imageView.image];
    NSLog(@"imageData:%@",imageData1);
    
    GenericsModel *model = [GenericsModel new];
}

- (NSData *)encodeImageWithImage:(UIImage *)image {
//    NSData *imageData1 = UIImagePNGRepresentation(image);
    NSData *imageData;
    
    //目标格式 比如kUTTypeJPEG
    CFStringRef imageUTType;
    //创建一个 CGImageDestinationRef
    CGImageDestinationRef imageDestinationRef = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)imageData, imageUTType, 1, NULL);
    if (!imageDestinationRef) {
        NSLog(@"无法编码，基本上是因为目标格式不支持");
        return nil;
    }
    
    CGImageRef imageRef = image.CGImage;
    
    CGImagePropertyOrientation exifOrientation = kCGImagePropertyOrientationDown;
    NSMutableDictionary *frameProperties = [NSMutableDictionary dictionary];
    frameProperties[(__bridge NSString *) kCGImagePropertyExifDictionary] = @(exifOrientation);
    // 添加图像和元信息
    CGImageDestinationAddImage(imageDestinationRef, imageRef, (__bridge CFDictionaryRef)frameProperties);
    if (CGImageDestinationFinalize(imageDestinationRef) == NO) {
        //编码失败
        NSLog(@"编码失败");
    }
    
    CFRelease(imageDestinationRef);
    return imageData;
}

- (nullable UIImage *)decodeImageWithImageData:(nonnull NSData *)imageData {
    if (!imageData) {
        return nil;
    }
    
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    if (!imageSourceRef) {
        NSLog(@"CGImageSourceRef 转换失败");
        return nil;
    }
    
    NSUInteger frameCount = CGImageSourceGetCount(imageSourceRef);
    NSString *imageType = (__bridge NSString *)CGImageSourceGetType(imageSourceRef);
    NSLog(@"imageType: %@",imageType);
    NSLog(@"图片帧数：%lu",(unsigned long)frameCount);
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
            UIImageOrientation imageOrientation = [self imageOrientationFromExifOrientation:exifOrientation];
            UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:imageOrientation];
            totalDuration += duration;
            
            image = [self fectchRenderImageWithOriginImage:image];
            [images addObject:image];
            CGImageRelease(imageRef);
        };
    }
    UIImage *image = [UIImage animatedImageWithImages:images duration:totalDuration];
    CFRelease(imageSourceRef);
    return image;
}

- (UIImage *)fectchRenderImageWithOriginImage:(UIImage *)image {
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

- (UIImageOrientation)imageOrientationFromExifOrientation:(CGImagePropertyOrientation)exifOrientation {
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

- (IBAction)jumpTableViewPage:(id)sender {
    ListViewController *list = [ListViewController new];
    [self.navigationController pushViewController:list animated:YES];
}

- (IBAction)clearMemoryCache:(id)sender {
    [[PXYImageCacheManager shareInstance] clearMemoryCacheImage];
}

- (IBAction)clearDiskCache:(id)sender {
    [[PXYImageCacheManager shareInstance] clearDiskCacheImage];
}
- (IBAction)clearAllCache:(id)sender {
    [[PXYImageCacheManager shareInstance] clearAllCacheImage];
}

//    NSUInteger fileSize = [imageProperties[(__bridge NSString *)kCGImagePropertyFileSize] integerValue];
//    NSDictionary *exiProperties = imageProperties[(__bridge NSString *)kCGImagePropertyExifDictionary];
//    NSString *exifCreateTime = imageProperties[(__bridge NSString*)kCGImagePropertyExifDateTimeOriginal];
//    NSLog(@"fileSize: %lu",(unsigned long)fileSize);
//    NSLog(@"exiProperties:%@",exiProperties);
//    NSLog(@"exifCreateTime:%@",exifCreateTime);

//    NSUInteger width = [imageRealProperties[(__bridge NSString *)kCGImagePropertyPixelWidth] unsignedIntegerValue]; //宽度，像素值
//    NSUInteger height = [imageRealProperties[(__bridge NSString *)kCGImagePropertyPixelHeight] unsignedIntegerValue]; //高度，像素值
//    BOOL hasAlpha = [imageRealProperties[(__bridge NSString *)kCGImagePropertyHasAlpha] boolValue]; //是否含有Alpha通道
//    CGImagePropertyOrientation exifOrientation = [imageRealProperties[(__bridge NSString *)kCGImagePropertyOrientation] integerValue]; // 这里也能直接拿到EXIF方向信息，和前面的一样。如果是iOS 7，就用NSInteger取吧 :)

@end
