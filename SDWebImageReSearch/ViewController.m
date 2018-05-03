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
//    [[PXYImageCacheManager shareInstance] clearAllCacheImage];
//    1 -1 -1 3 4
//    LRUDoubleLinkedList *cache = [[LRUDoubleLinkedList alloc] initCacheWithCapacity:2];
//    [cache putWithKey:@"1" value:@"1"];
//    [cache putWithKey:@"2" value:@"2"];
//    NSLog(@"--:%@",[cache getWithKey:@"1"]);
//    [cache putWithKey:@"3" value:@"3"];
//    NSLog(@"--:%@",[cache getWithKey:@"2"]);
//    [cache putWithKey:@"4" value:@"4"];
//    NSLog(@"--:%@",[cache getWithKey:@"1"]);
//    NSLog(@"--:%@",[cache getWithKey:@"3"]);
//    NSLog(@"--:%@",[cache getWithKey:@"4"]);
//    NSLog(@"=======");
//
//    //-1 -1 2 6
//    LRUDoubleLinkedList *cache1 = [[LRUDoubleLinkedList alloc] initCacheWithCapacity:2];
//    NSLog(@"--:%@",[cache1 getWithKey:@"2"]);
//    [cache1 putWithKey:@"2" value:@"6"];
//    NSLog(@"--:%@",[cache1 getWithKey:@"1"]);
//    [cache1 putWithKey:@"1" value:@"5"];
//    [cache1 putWithKey:@"1" value:@"2"];
//    NSLog(@"--:%@",[cache1 getWithKey:@"1"]);
//    NSLog(@"--:%@",[cache1 getWithKey:@"2"]);
//
//    NSLog(@"=======");
//    //1
//    LRUDoubleLinkedList *cache2 = [[LRUDoubleLinkedList alloc] initCacheWithCapacity:1];
//    [cache2 putWithKey:@"2" value:@"1"];
//    [cache2 putWithKey:@"1" value:@"2"];
//    [cache2 putWithKey:@"1" value:@"2"];
//    [cache2 putWithKey:@"3" value:@"3"];
//    NSLog(@"--:%@",[cache2 getWithKey:@"2"]);
    
    
//    [PXYImageMemoryCacheEliminatedRule shareInstanceWithCapacity:2];
////    1 -1 -1 3 4
//    [[PXYImageMemoryCache shareInstance] setObject:@"1" forKey:@"1"];
//    [[PXYImageMemoryCache shareInstance] setObject:@"2" forKey:@"2"];
//    NSLog(@"===%@",[[PXYImageMemoryCache shareInstance] objectForKey:@"1"]);
//    [[PXYImageMemoryCache shareInstance] setObject:@"3" forKey:@"3"];
//    NSLog(@"===%@",[[PXYImageMemoryCache shareInstance] objectForKey:@"2"]);
//    [[PXYImageMemoryCache shareInstance] setObject:@"4" forKey:@"4"];
//    NSLog(@"===%@",[[PXYImageMemoryCache shareInstance] objectForKey:@"1"]);
//    NSLog(@"===%@",[[PXYImageMemoryCache shareInstance] objectForKey:@"3"]);
//    NSLog(@"===%@",[[PXYImageMemoryCache shareInstance] objectForKey:@"4"]);
    
    [PXYImageMemoryCacheEliminatedRule shareInstanceWithCapacity:2];
    NSLog(@"===%@",[[PXYImageMemoryCache shareInstance] objectForKey:@"2"]);
    [[PXYImageMemoryCache shareInstance] setObject:@"6" forKey:@"2"];
    NSLog(@"===%@",[[PXYImageMemoryCache shareInstance] objectForKey:@"1"]);
    [[PXYImageMemoryCache shareInstance] setObject:@"5" forKey:@"1"];
    [[PXYImageMemoryCache shareInstance] setObject:@"2" forKey:@"1"];
    NSLog(@"===%@",[[PXYImageMemoryCache shareInstance] objectForKey:@"1"]);
    NSLog(@"===%@",[[PXYImageMemoryCache shareInstance] objectForKey:@"2"]);
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
