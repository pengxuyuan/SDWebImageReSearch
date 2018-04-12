//
//  UIImage+WCImage.m
//  textApp
//
//  Created by MacBook on 2017/4/11.
//  Copyright © 2017年 王创. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIImage+WCImage.h"

#define WCNetSourceIsImageNot @"WCDownloadImage_IsNetImage"

#define CacheImageFileName @"WCNetImageDownloadCache"

//缓存文件夹
#define CacheFile [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,                                                                NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent: CacheImageFileName]

@interface WCImageDownloadManager : NSObject

//内存下载操作字典,用来记录下载操作
@property (nonatomic,strong)NSMutableDictionary *oprationDic;

+(instancetype)shareManager;

//下载图片
-(void)downloadNetSourceWithURLStr:(NSString *)urlStr successBlock:(successBlock)block;
@end


@interface WCImageDownloadManager()
//内存图片字典,用来缓存内存图片
@property (nonatomic,strong)NSMutableDictionary *imageDic;

//下载队列
@property (nonatomic,strong)NSOperationQueue *queue;

@end
@implementation WCImageDownloadManager

//MARK:- 懒加载queue
-(NSOperationQueue *)queue
{
    if (_queue==nil) {
        _queue = [[NSOperationQueue alloc]init];
        
    }
    return _queue;
}
//MARK:- 懒加载操作字典
-(NSMutableDictionary *)oprationDic
{
    if (_oprationDic==nil) {
        _oprationDic = [[NSMutableDictionary alloc]init];
    }
    return _oprationDic;
}
//MARK:- 懒加载图片字典
-(NSMutableDictionary *)imageDic
{
    if (_imageDic==nil) {
        _imageDic = [[NSMutableDictionary alloc]init];
    }
    return _imageDic;
}
//MARK:- 单例
+(instancetype)shareManager
{
    static WCImageDownloadManager *instence;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instence = [[self alloc]init];
    });
    return instence;
}

//MARK:- 下载图片
-(void)downloadNetSourceWithURLStr:(NSString *)urlStr successBlock:(successBlock)block{
    
    if (urlStr.length <= 0) {
        block(nil);
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    if (url == nil) {
        block(nil);
        return;
    }
    
    //文件名称. 处理"/",因为"/"在储存时,具有特殊意义,会被作为路径,也不能拿[urlStr lastPathComponent],因为结尾可能很短,就会
    //造成重复,不精确,所以此处直接替换特殊字符,精确的储存.
    NSString *tempURLStr = [urlStr stringByReplacingOccurrencesOfString:@"/" withString:@""];
    //文件名称
    NSString *cacheImageName = [NSString stringWithFormat:@"%@%@%@",CacheImageFileName,tempURLStr,@".png"];
    //文件储存路径
    NSString *cacheStr = [CacheFile stringByAppendingPathComponent:cacheImageName];
    //创建文件夹
    __block NSFileManager *fileManeger = [NSFileManager defaultManager];
    if (![fileManeger fileExistsAtPath:CacheFile]) {
        //创建 WCDownloadImage文件夹
        [fileManeger createDirectoryAtPath:CacheFile withIntermediateDirectories:YES attributes:nil error:nil];
    }    
    
    __block UIImage *image;
    //是否有内存缓存
    UIImage *memCacheImage = [self.imageDic objectForKey:cacheImageName];
    if ([self.imageDic objectForKey:cacheImageName] != nil) {
        image = memCacheImage;
        block(image);
        return;
    }
    
    //是否有沙盒缓存
    NSData *cacheData = [NSData dataWithContentsOfFile:cacheStr];
    if (cacheData) {
        image = [UIImage imageWithData:cacheData];
        //转换一份放在内存,以备下次使用内存
        self.imageDic[cacheImageName] = image;
        block(image);
        return;
    }
    
    //没有内存缓存、没有磁盘缓存.  -> 准备做下载操作处理
    //下载操作已存在,什么都不做,等待下载
    NSBlockOperation *download = [self.oprationDic objectForKey:cacheImageName];
    if (download) {
        NSLog(@"下载%@ 的操作已存在,下载中....请等待",urlStr);
    }else{
        //下载操作不存在. 封装操作,开线程,去下载二进制数据.
        download = [NSBlockOperation blockOperationWithBlock:^{
            
            NSURL *url = [NSURL URLWithString:urlStr];
            //二进制数据
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            //是否下载失败,请求超时须从操作字典中移除,因为下载操作会被缓存,所以如果下载操作超时/失败,
            //那么该下载操作依然存在队列中,那下一次刷新时,就会继续等待,即使网络好了,也不会被加载,所以如果下载了而没照片,
            //直接将其从操作字典中移除,下次下载时重新进入下载流程
            if (data) {
                //照片
                image = [UIImage imageWithData:data];
                if (image) {
                    //保存到内存缓存
                    self.imageDic[cacheImageName] = image;
                    //保存到磁盘缓存
                    [data writeToFile:cacheStr atomically:YES];
                }else{
                    [self.oprationDic removeObjectForKey:cacheImageName];
                }
            }else{
                [self.oprationDic removeObjectForKey:cacheImageName];
            }
            
            //无论成功与否,回调block
            block(image);
        }];
        
        //记录下载操作. 注意:操作缓存需要在任务添加到队列前 缓存,因为操作一添加到队列中就有可能被执行完了
        self.oprationDic[cacheImageName] = download;
        //添加下载操作到任务队列中
        [self.queue addOperation:download];
    }
}
@end







#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (WCScrollViewImage)

// MARK:- 获取本地图片
+(instancetype)wc_imageByLocalName:(NSString *)name
{
    //GIF
    NSRange GIFRange = [name rangeOfString:@".gif"];
    NSRange GIFRange1 = [name rangeOfString:@".GIF"];
    UIImage *image;
    if (GIFRange.location != NSNotFound || GIFRange1.location != NSNotFound) {
        image = [UIImage wc_imageByGIFName:name];
        return image;
    }    
    
    //非GIF
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    //优先方式1
    image = [[UIImage alloc]initWithContentsOfFile:sourcePath];
    if (image) {
        return image;
    }
    //方式2
    image = [UIImage imageNamed:name];
    return image;
}
// MARK:- 处理本地GIF图片
+(instancetype)wc_imageByGIFName:(NSString *)name
{
    //容错
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    if (sourcePath == nil || [sourcePath isEqualToString:@""]) {
        return nil;
    }
    
    //加载指定路径的图片（二进制数据）
    NSData *data = [NSData dataWithContentsOfFile:sourcePath];
    if (data == nil) {
        NSLog(@"找不到bundle中的GIF图片");
        return nil;
    }
    
    //如果data不为空，则直接调用loadAnimatedGIFWithData返回一张可动画的图片
    return [self wc_imageByGIFData:data];
}

//本地图片. imageSize 生成的图片对应的大小
+(instancetype)wc_imageByLocalName:(NSString *)name imageSize:(CGSize)imageSize
{
    UIImage *image = [self wc_imageByLocalName:name];
    if (image == nil) {
        return nil;
    }
    
    //没设置期望大小,给定图片的原始大小
    if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
        return image;
    }
    
    //设置了期望大小,去绘制
    image = [image imageWithImageSize:imageSize];
    return image;
}

//本地图片, 拉伸图片.(平铺模式、中间1*1拉伸模式)
+(instancetype)wc_imageByLocalName:(NSString *)name resizeMode:(UIImageResizingMode)resizeMode
{
    UIImage *image = [self wc_imageByLocalName:name];
    if (image) {
        //平铺模式
        if (resizeMode == UIImageResizingModeTile) {
            image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
            //拉伸模式. 拉伸中间1*1
        }else{
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.5, image.size.width * 0.5, image.size.height * 0.5 - 1, image.size.width * 0.5 - 1) resizingMode:UIImageResizingModeStretch];
        }
    }
    
    return image;
}
+(instancetype)wc_imageByLocalName:(NSString *)name protectInsets:(UIEdgeInsets)protectInsets resizeMode:(UIImageResizingMode)resizeMode
{
    UIImage *image = [self wc_imageByLocalName:name];
    if (image) {
        //平铺模式
        if (resizeMode == UIImageResizingModeTile) {
            image = [image resizableImageWithCapInsets:protectInsets];
            //拉伸模式、保护区域
        }else{
            image = [image resizableImageWithCapInsets:protectInsets resizingMode:UIImageResizingModeStretch];
        }
    }
    
    return image;
}

// MARK:- 获取网络图片
+(void)wc_imageByNetName:(NSString *)name successBlock:(successBlock)block
{
  [[WCImageDownloadManager shareManager]downloadNetSourceWithURLStr:name successBlock:block];
}

// MARK:- 获取视频的第N帧的图片
+(instancetype)wc_imageByMovieName:(NSString *)name index:(NSInteger)index;
{    
    //容错
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    if (sourcePath == nil || [sourcePath isEqualToString:@""]) {
        return nil;
    }
    
    NSURL *tempURL = [NSURL fileURLWithPath:sourcePath];
    if (tempURL == nil) {
        return nil;
    }
    
    //加载图片
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:tempURL options:nil];
    
    AVAssetImageGenerator *assetImageGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetImageGen.appliesPreferredTrackTransform = YES;
    //设置这2个属性,就会获取精确时间,从而获取到具体帧;若不设置,会在一定范围从缓存获取,而优化内存
    if (index > 0) {
        assetImageGen.requestedTimeToleranceAfter = kCMTimeZero;
        assetImageGen.requestedTimeToleranceBefore = kCMTimeZero;
    }
    
    CMTime cmTime = CMTimeMakeWithSeconds(index, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    //获取图片
    CGImageRef cgImage = [assetImageGen copyCGImageAtTime:cmTime actualTime:&actualTime error:&error];
    
    UIImage *image = [[UIImage alloc] initWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return image;
    
}

//把图片的二进制数据转换为图片（GIF）
+(UIImage *)wc_imageByGIFData:(NSData *)data {
    
    //如果传入的二进制数据为空，则直接返回nil
    if (!data) {
        return nil;
    }
    
    // 创建图像源
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    // 获取图片帧数
    size_t count = CGImageSourceGetCount(source);
    
    //初始化animatedImage
    UIImage *animatedImage;
    
    //如果图片帧数小于等于1，那么就直接把二进制数据转换为图片，并返回图片
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else
    {
        //创建可变的空的图片数组
        __block  NSMutableArray *imagesArr = [NSMutableArray array];
        
        //初始化动画播放时间为0
        NSTimeInterval duration = 0.0f;
        
        // 遍历并且提取所有的动画帧
        for (size_t i = 0; i < count; i++) {
            
            //先累计时间
            duration += [self GIFFrameDurationAtIndex:i source:source];
            
            //若帧数过大,做稀释帧数处理.(默认都会稀释到20帧左右. 注意:总帧数越少,稀释度需要越少,也就是保留的帧数越多) *
            if (count > 100) {
                if (i % 5 != 0) {    //20帧以上
                    continue ;
                }
            }else if (count > 80) {  //20~25帧左右
                if (i % 4 != 0) {
                    continue ;
                }
            }else if (count > 60) {  //20~27帧左右
                if (i % 3 != 0) {
                    continue ;
                }
            }else if (count > 30) { //15~30帧左右
                if (i % 2 != 0) {
                    continue ;
                }
            }else {                 //30帧以内
                //NSLog(@"30张以内的GIF帧数, 不做处理");
            }
            
            //从图片源里获取此时i对应的图片
            CGImageRef cgimage = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            //转换成image
            __block UIImage * newImage = [UIImage imageWithCGImage:cgimage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
            
            //绘图,重新生成image *
            newImage = [newImage renderImage];
            
            // 将图像添加到动画数组
            [imagesArr addObject:newImage];
            //释放操作
            CGImageRelease(cgimage);
        }
        
        //动画时间容错
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        // 建立可动画图像
        animatedImage = [UIImage animatedImageWithImages:imagesArr duration:duration];
    }
    
    //释放操作
    CFRelease(source);
    
    return animatedImage;
}

//MARK: - 获取对应尺寸的图片
-(UIImage *)imageWithImageSize:(CGSize)imageSize
{
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//MARK: - 获取渲染的图片
-(UIImage *)renderImage
{
    UIImageView *tempImageView = [[UIImageView alloc]initWithImage:self];
    //1. 开启上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO,0.0);
    
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


//获得播放的时间长度
+(float)GIFFrameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    
    float frameDuration = 0.1f;
    //获得图像的属性（图像源，索引）
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    //桥接转换为NSDictionary类型
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    //取出图像属性里面kCGImagePropertyGIFDictionary这个KEY对应的值，即GIF属性
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    //得到延迟时间
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        //把延迟时间转换为浮点数类型
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else
    {
        //如果上面获得的延迟时间为空，则换另外一种方式获得
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp){
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    //处理延迟时间
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    //释放操作
    CFRelease(cfFrameProperties);
    return frameDuration;
}
@end
