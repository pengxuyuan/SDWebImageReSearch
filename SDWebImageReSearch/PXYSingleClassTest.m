//
//  PXYSingleClassTest.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/15.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

/*
 NEW
 alloc init
 shareInstance
 copy
 
 饿汉方式
 懒汉方式
 
 双重检查加锁
 内部类方式
 枚举方式
 
 确保获取到的是唯一实例，并且获取这个方式是线程安全的，并防止反序列化，反射，克隆等多种情况下重新生成新的对象
 
 
 */

#import "PXYSingleClassTest.h"

@implementation PXYSingleClassTest
//implementationSingleton(singleClassTest)
+ (instancetype)shareInstance {
    PXYSingleClassTest *shareInstance = [PXYSingleClassTest new];
    return shareInstance;
}

static PXYSingleClassTest *shareInstance;
static dispatch_once_t onceToken;
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    dispatch_once(&onceToken, ^{
        shareInstance = [super allocWithZone:zone];
    });
    return shareInstance;
}

- (id)copyWithZone:(NSZone *)zone{
    return shareInstance;
}

+ (void)destroyInstance {
    onceToken = 0;
    shareInstance = nil;
}

/*
 - (void)downloadImageSimple {
 NSString *imageUrlStr = kImgaeUrlStr;
 imageUrlStr = [imageUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
 NSURL *imageUrl = [[NSURL alloc] initWithString:imageUrlStr];
 NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
 self.imageView1.image = [UIImage imageWithData:imageData];
 }
 
 - (void)downloadImageWithChildThread {
 __weak __typeof__(self) weakSelf = self;
 
 dispatch_queue_t pengxuyuanQ = dispatch_queue_create("pengxuyuanDownloadImageQ", NULL);
 dispatch_async(pengxuyuanQ, ^{
 //网络下载图片  NSData格式
 NSString *imageUrlStr = kImgaeUrlStr;
 imageUrlStr = [imageUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
 NSURL *imageUrl = [[NSURL alloc] initWithString:imageUrlStr];
 
 UIImage *downloadImage = [UIImage new];
 
 NSError *error;
 NSData *imageData = [NSData dataWithContentsOfURL:imageUrl options:NSDataReadingMappedIfSafe error:&error];
 if (error) {
 NSLog(@"下载图片失败：%@",error);
 }else{
 if (imageData) {
 NSLog(@"下载成功");
 downloadImage = [UIImage imageWithData:imageData];
 }
 //回到主线程更新UI
 dispatch_async(dispatch_get_main_queue(), ^{
 __strong __typeof(self) strongSelf = weakSelf;
 [strongSelf.imageView1 setImage:downloadImage];
 });
 }
 });
 }
 
 #pragma mark - NSURLSeesion
 - (void)downloadImageWithURLSeesion {
 NSString *imageUrlStr = kImgaeUrlStr;
 imageUrlStr = [imageUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
 NSURL *imageUrl = [[NSURL alloc] initWithString:imageUrlStr];
 
 NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
 NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
 [[session downloadTaskWithURL:imageUrl completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
 if (error) {
 NSLog(@"downloadImageWithURLSeesion error:%@",error);
 return ;
 }
 
 NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:response.suggestedFilename];
 NSURL *fileUrl = [NSURL fileURLWithPath:fullPath];
 
 [[NSFileManager defaultManager] moveItemAtURL:location toURL:fileUrl error:nil];
 
 NSData *fileNata = [NSData dataWithContentsOfURL:fileUrl];
 
 dispatch_async(dispatch_get_main_queue(), ^{
 self.imageView1.image = [UIImage imageWithData:fileNata];
 NSLog(@"下载成功");
 });
 }] resume];
 
 //    NSURLRequest *quest = [NSURLRequest requestWithURL:imageUrl];
 //    [session downloadTaskWithRequest:quest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
 //
 //    }];
 }
 
 #pragma mark - Download Multi Images
 
 - (IBAction)downloadMultiImage:(id)sender {
 NSLog(@"开始下载多张图片");
 NSURL *url1 = [NSURL URLWithString:kMultiImage1];
 NSURL *url2 = [NSURL URLWithString:kMultiImage2];
 NSURL *url3 = [NSURL URLWithString:kMultiImage3];
 NSURL *url4 = [NSURL URLWithString:kMultiImage4];
 NSURL *url5 = [NSURL URLWithString:kMultiImage5];
 NSURL *url6 = [NSURL URLWithString:kMultiImage6];
 
 [self.multiImage1 setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"one"]];
 [self.multiImage2 setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@"one"]];
 [self.multiImage3 setImageWithURL:url3 placeholderImage:[UIImage imageNamed:@"one"]];
 [self.multiImage4 setImageWithURL:url4 placeholderImage:[UIImage imageNamed:@"one"]];
 [self.multiImage5 setImageWithURL:url5 placeholderImage:[UIImage imageNamed:@"one"]];
 [self.multiImage6 setImageWithURL:url6 placeholderImage:[UIImage imageNamed:@"one"]];
 
 }
 
 - (IBAction)emptyMultiImage:(id)sender {
 self.multiImage1.image = nil;
 self.multiImage2.image = nil;
 self.multiImage3.image = nil;
 self.multiImage4.image = nil;
 self.multiImage5.image = nil;
 self.multiImage6.image = nil;
 
 [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:nil];
 }
 
 - (IBAction)fetchImageFormMemory:(id)sender {
 //    self.multiImage1.image = [[PXYImageMemoryCache shareInstance] objectForKey:kMultiImage1];
 //    self.multiImage2.image = [[PXYImageMemoryCache shareInstance] objectForKey:kMultiImage2];
 //    self.multiImage3.image = [[PXYImageMemoryCache shareInstance] objectForKey:kMultiImage3];
 //    self.multiImage4.image = [[PXYImageMemoryCache shareInstance] objectForKey:kMultiImage4];
 //    self.multiImage5.image = [[PXYImageMemoryCache shareInstance] objectForKey:kMultiImage5];
 //    self.multiImage6.image = [[PXYImageMemoryCache shareInstance] objectForKey:kMultiImage6];
 
 [[PXYImageDiskCache shareInstance] removeDiskAllObjects];
 }

 
 //    NSString *home =  NSHomeDirectory();
 //
 //    NSString *doc1 = [home stringByAppendingPathComponent:@"Pengxuyuan"];
 //
 //    NSString *doc2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
 //
 //    //这个目录是在Library目录下的，需要自己手动创建文件夹(一般不会存在这个下面)
 //    NSString *docError = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
 //
 //    //4.缓存目录
 //    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
 //
 //    //5.临时目录
 //    NSString *tempDir = NSTemporaryDirectory();
 //
 //    NSLog(@"home:%@",home);
 //    NSLog(@"doc1:%@",doc1);
 //    NSLog(@"doc2:%@",doc2);
 //    NSLog(@"docError:%@",docError);
 //    NSLog(@"cacheDir:%@",cacheDir);
 
 //250*150 55KB  37500个像素 (1个像素有4个通道 1个通道占8位 共4个字节 32位)
 UIImage *image = [UIImage imageNamed:@"HomeActivity1@2x.png"];
 //    CFDataRef rawData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
 //
 //    NSData *pngData = UIImagePNGRepresentation(image);
 //    NSData *jpgData = UIImageJPEGRepresentation(image, 0.1);
 //    NSLog(@"rawData Size:%@",rawData);
 //    NSLog(@"PNGData Size:%lu",(unsigned long)[pngData length]);
 //    NSLog(@"JpgData Size:%lu",(unsigned long)[jpgData length]);
 //
 //    UIImage *pngImage = [UIImage imageWithData:pngData];
 //    UIImage *jpgImage = [UIImage imageWithData:jpgData];
 //    NSData *pngData1 = UIImagePNGRepresentation(pngImage);
 //    NSData *jpgData1 = UIImageJPEGRepresentation(jpgImage, 0.5);
 //    NSLog(@"pngData1 Size:%lu",(unsigned long)[pngData1 length]);
 //    NSLog(@"jpgData1 Size:%lu",(unsigned long)[jpgData1 length]);
 //    CFDataRef pngImageData = CGDataProviderCopyData(CGImageGetDataProvider(pngImage.CGImage));
 //    CFDataRef jpgImageData = CGDataProviderCopyData(CGImageGetDataProvider(jpgImage.CGImage));
 
 
 
 */
@end
