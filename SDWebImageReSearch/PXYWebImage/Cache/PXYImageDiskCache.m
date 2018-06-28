//
//  PXYImageDiskCache.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/6.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "PXYImageDiskCache.h"
#import "PXYMD5DigestHelper.h"

#define MD5(URL) [PXYMD5DigestHelper convertToUpper32BitsMD5With:URL]

@interface PXYImageDiskCache()

@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSString *diskCachePath;

@end

@implementation PXYImageDiskCache

#pragma mark - Life Cycle
+ (instancetype)shareInstance {
    PXYImageDiskCache *instance = [PXYImageDiskCache new];
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    static PXYImageDiskCache *instance;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

#pragma mark - Plublic Methods
/**
 获取磁盘缓存 Cache 目录
 */
- (nonnull NSString *)fetchDiskCachePathWithNameSpace:(NSString *)nameSpace {
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [cacheDir stringByAppendingPathComponent:nameSpace];
}

/**
 将 NSData 存入到缓存文件夹中
 */
- (void)storeImageDataToDisk:(nullable NSData *)imageData key:(nullable NSString *)key {
    if (!imageData || !key) {
        return;
    }
    
    if (![self.fileManager fileExistsAtPath:self.diskCachePath]) {
        BOOL res = [self.fileManager createDirectoryAtPath:self.diskCachePath withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            NSLog(@"文件夹创建成功");
        } else {
            NSLog(@"文件夹创建失败");
        }
    }
    
    //写磁盘
    NSString *cachePathForKey = [self defaultCachePathForKey:key];
    NSURL *fileURL = [NSURL fileURLWithPath:cachePathForKey];
    BOOL write = [imageData writeToURL:fileURL options:NSDataWritingAtomic error:nil];
    if (write) {
        NSLog(@"%@ 写文件成功",key);
    } else {
        NSLog(@"%@ 写文件失败",key);
    }
}

/**
 查询磁盘是否存在这个图片
 */
- (BOOL)inquireDiskImageExistsWithKey:(nullable NSString *)key {
    if (!key) {
        return NO;
    }
    
    BOOL exists = [self.fileManager fileExistsAtPath:[self defaultCachePathForKey:key]];
    return exists;
}

/**
 磁盘查找图片
 */
- (NSData *_Nullable)fetchDiskImageDataWithKey:(nullable NSString *)key {
    if (!key) {
        return nil;
    }
    
    
    NSString *imagePath = [self defaultCachePathForKey:key];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    NSLog(@"磁盘缓存取值：Key：%@ -- Value：%lu",key,(unsigned long)[imageData length]);
    if (imageData) {
        return imageData;
    } else {
        return nil;
    }
}

/**
 在磁盘上面移除图片
 */
- (void)removeDiskImageDataForKey:(nullable NSString*)key {
    NSString *imagePath = [self defaultCachePathForKey:key];
    if ([self.fileManager removeItemAtPath:imagePath error:nil]) {
        NSLog(@"磁盘移除成功：Key：%@",key);
    } else {
        NSLog(@"磁盘移除失败：Key：%@",key);
    }
}

/**
 清除磁盘中的图片缓存
 */
- (void)clearImageOnDiskCache {
    [self.fileManager removeItemAtPath:self.diskCachePath error:nil];
    [self.fileManager createDirectoryAtPath:self.diskCachePath withIntermediateDirectories:YES attributes:nil error:nil];
}

/**
 获取磁盘图片大小
 */
- (NSUInteger)fetchDiskImageSize {
    NSUInteger size = 0;
    NSDirectoryEnumerator *fileEnumerator = [self.fileManager enumeratorAtPath:self.diskCachePath];
    for (NSString *fileName in fileEnumerator) {
        if (fileName.length < 32) {
            continue;
        }
        NSString *filePath = [self p_defaultCachePathNoMD5ForKey:fileName];
        NSDictionary <NSString *,id> *attrs = [self.fileManager attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}

/**
 获取磁盘图片数量
 */
- (NSUInteger)fetchDiskImageCount {
    NSUInteger count = 0;
    NSDirectoryEnumerator *fileEnumerator = [self.fileManager enumeratorAtPath:self.diskCachePath];
    count = fileEnumerator.allObjects.count;
    return count;
}


#pragma mark - Private Methods
- (NSString *)defaultCachePathForKey:(NSString *)key {
    return [self cachePathForKey:key inPath:self.diskCachePath];
}

- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path {
    NSString *fileName = [self cacheFileNameForKey:key];
    return [path stringByAppendingPathComponent:fileName];
}

- (NSString *)cacheFileNameForKey:(NSString *)key {
    return MD5(key);
}

- (NSString *)p_defaultCachePathNoMD5ForKey:(NSString *)key {
    return [self.diskCachePath stringByAppendingPathComponent:key];
}

#pragma mark - Lazzy load
- (NSString *)diskCachePath {
    if (_diskCachePath == nil) {
        _diskCachePath = [self fetchDiskCachePathWithNameSpace:@"PXYImageCache"];
    }
    return _diskCachePath;
}

#pragma mark - Lazzy load
- (NSFileManager *)fileManager {
    if (_fileManager == nil) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}


@end
