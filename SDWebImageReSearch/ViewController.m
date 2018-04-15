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
#import "ImageRelateViewController.h"
#import "ImageProcessHelper.h"
#import "ImagePropertiesListController.h"

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
    self.imageView.image = PXYCreateUIImageFromFileName(@"timg5.gif");
    self.imageView2.image = PXYCreateUIImageFromFileName(@"HomeActivity1@2x.png");
    
    PXYFetchImagePropertiesWithImageName(@"HomeActivity1@2x.png");
    PXYFetchImagePropertiesWithImageName(@"timg5.gif");
    
    
//    self.imageView2.image = PXYFetchThumbnailImageFromFileName(@"HomeActivity1@2x.png", 20);
    
//    UIImage *image0 = PXYCreateUIImageFromFileName(@"HomeActivity1@2x.png");
//    UIImage *image1 = PXYFetchThumbnailImageFromFileName(@"HomeActivity1@2x.png", 0.1);
//    UIImage *image2 = PXYFetchThumbnailImageFromFileName(@"HomeActivity1@2x.png", 10);
//    UIImage *image3 = PXYFetchThumbnailImageFromFileName(@"HomeActivity1@2x.png", 100);
//    UIImage *image4 = PXYFetchThumbnailImageFromFileName(@"HomeActivity1@2x.png", 1000);
    
    //    self.imageView2.image = [UIImage wc_imageByLocalName:@"timg5.gif"];
    
    //编码
//    NSData *imageData1 = [self encodeImageWithImage:self.imageView.image];
//    NSLog(@"imageData:%@",imageData1);
//
//    GenericsModel *model = [GenericsModel new];
}

//编码
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
- (IBAction)imageRelate:(id)sender {
    ImageRelateViewController *imageRelate = [ImageRelateViewController new];
    [self.navigationController pushViewController:imageRelate animated:YES];
}
- (IBAction)imagePropertiesPage:(id)sender {
    ImagePropertiesListController *imageProperty = [ImagePropertiesListController new];
    [self.navigationController pushViewController:imageProperty animated:YES];
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
