//
//  PXYImageDiskCache.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/6.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "PXYImageDiskCache.h"

@interface PXYImageDiskCache()

@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSString *fullPath;

@end

@implementation PXYImageDiskCache

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static PXYImageDiskCache *instance;
    dispatch_once(&onceToken, ^{
        instance = [PXYImageDiskCache new];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key {
    NSString *imagePath = [self.fullPath stringByAppendingPathComponent:key];
    NSData *imageData = UIImagePNGRepresentation(image);
    if ([self.fileManager createFileAtPath:imagePath contents:imageData attributes:nil]){
        NSLog(@"%@ 写文件成功",key);
    }else{
        NSLog(@"%@ 写文件失败",key);
    }
}

- (NSData *)fetchImageWithKey:(NSString *)key {
    NSString *filePath = [self.fullPath stringByAppendingPathComponent:key];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    NSLog(@"%@内存取值：%lu",key,(unsigned long)imageData.length);
    return imageData;
}

- (void)removeDiskAllObjects {
    NSError *error;
    if(![self.fileManager removeItemAtPath:self.fullPath error:&error]){
        NSLog(@"移除磁盘所有图片缓存失败 error: %@",error);
    }else{
        NSLog(@"移除磁盘所有图片缓存");
        self.fullPath = nil;
    }
}

#pragma mark - Lazzy load
- (NSFileManager *)fileManager {
    if (_fileManager == nil) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

- (NSString *)fullPath {
    if (_fullPath == nil) {
        NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        _fullPath = [cacheDir stringByAppendingPathComponent:@"pengxuyuanCacheImageDocument"];
        if  (![self.fileManager fileExistsAtPath:self.fullPath]) {
            // 创建目录
            BOOL res=[self.fileManager createDirectoryAtPath:self.fullPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (res) {
                NSLog(@"文件夹创建成功");
            }else{
                NSLog(@"文件夹创建失败");
            }
        }
    }
    return _fullPath;
}

@end
