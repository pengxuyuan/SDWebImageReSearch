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

#import "PXYImageMemoryCache.h"
#import "NSCache+PXYExtension.h"
#import "LRUImplement.h"
#import "LRUDoubleLinkedList.h"
#import "PXYImageMemoryCacheEliminatedRule.h"

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
@property (weak, nonatomic) IBOutlet UILabel *diskCacheInfo;


@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = PXYCreateUIImageFromFileName(@"timg5.gif");
    self.imageView2.image = PXYCreateUIImageFromFileName(@"HomeActivity1@2x.png");
    
//    NSDictionary *imageP = PXYFetchImagePropertiesWithImageName(@"HomeActivity1@2x.png");
//    NSDictionary *gifP = PXYFetchImagePropertiesWithImageName(@"timg5.gif");
//
//    UIImage *image0 = PXYCreateUIImageFromFileName(@"HomeActivity1@2x.png");
//    UIImage *image1 = PXYFetchThumbnailImageFromFileName(@"HomeActivity1@2x.png", 0.1);
    
    //编码
//    NSData *imageData1 = [self encodeImageWithImage:self.imageView.image];
//    NSLog(@"imageData:%@",imageData1);
//
//    GenericsModel *model = [GenericsModel new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *info = [NSString stringWithFormat:@"DiskCache:Size:%lu-Count:%lu",(unsigned long)[[PXYImageCacheManager shareInstance] fetchDiskCacheSize],(unsigned long)[[PXYImageCacheManager shareInstance] fetchDiskCacheCount] ];
    self.diskCacheInfo.text = info;
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
    [[PXYImageCacheManager shareInstance] clearAllMemoryCache];
}

- (IBAction)clearDiskCache:(id)sender {
    [[PXYImageCacheManager shareInstance] clearAllDiskCacheCompletion:nil];
}

- (IBAction)clearAllCache:(id)sender {
    [[PXYImageCacheManager shareInstance] clearAllMemoryCache];
    [[PXYImageCacheManager shareInstance] clearAllDiskCacheCompletion:nil];
}

- (IBAction)imageRelate:(id)sender {
    ImageRelateViewController *imageRelate = [ImageRelateViewController new];
    [self.navigationController pushViewController:imageRelate animated:YES];
}

- (IBAction)imagePropertiesPage:(id)sender {
    ImagePropertiesListController *imageProperty = [ImagePropertiesListController new];
    [self.navigationController pushViewController:imageProperty animated:YES];
}


@end
