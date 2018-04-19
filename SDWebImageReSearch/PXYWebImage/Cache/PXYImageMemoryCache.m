//
//  PXYImageMemoryCache.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/6.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "PXYImageMemoryCache.h"
#import <UIKit/UIApplication.h>
#import "NSMutableArray+PXYExtension.h"
#import "NSMutableDictionary+PXYExtension.h"

#define LOCK(semaphore) dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
#define UNLOCK(semaphore) dispatch_semaphore_signal(semaphore)


@interface PXYImageMemoryCache <KeyType, ObjectType> ()<NSCacheDelegate,PXYImageMemoryCacheEliminatedDelegate>

@property (nonatomic, strong) NSMapTable<KeyType, ObjectType> *cacheMapTable;
@property (nonatomic, strong) dispatch_semaphore_t cacheSemaphore_t;


@end

@implementation PXYImageMemoryCache

#pragma mark - Life Cycle
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static PXYImageMemoryCache *instance;
    dispatch_once(&onceToken, ^{
        instance = [PXYImageMemoryCache new];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cacheMapTable = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory capacity:0];
        self.cacheSemaphore_t = dispatch_semaphore_create(1);
        self.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMemoryWarning:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Private Methods
- (void)didReceiveMemoryWarning:(NSNotification *)notification {
    // Only remove cache, but keep weak cache
    [super removeAllObjects];
    if ([self.eliminatedDelegate respondsToSelector:@selector(imageMemoryCacheRemoveAllObject)]) {
        [self.eliminatedDelegate imageMemoryCacheRemoveAllObject];
    }
    NSLog(@"Cacha didReceiveMemoryWarning");
}

#pragma mark - Pulbic Methods
//这里保证了内存中没有值，然后从 MapTable 中取值
- (id)objectForKey:key {
    id obj = [super objectForKey:key];
    if (key && !obj) {
        LOCK(self.cacheSemaphore_t);
        obj = [self.cacheMapTable objectForKey:key];
        UNLOCK(self.cacheSemaphore_t);
        if (obj) {
            [super setObject:obj forKey:key];
        }
    }
    NSLog(@"缓存取值：Key：%@ -- Value：%@",key,obj);
    if ([self.eliminatedDelegate respondsToSelector:@selector(imageMemoryCacheObjectForKey:fetchValue:)]) {
        [self.eliminatedDelegate imageMemoryCacheObjectForKey:key fetchValue:obj];
    }
    return obj;
}


- (void)setObject:obj forKey:key cost:(NSUInteger)g {
    [super setObject:obj forKey:key cost:g];
    if (obj && key) {
        LOCK(self.cacheSemaphore_t);
        [self.cacheMapTable setObject:obj forKey:key];
        NSLog(@"设置缓存：Key：%@ -- Value：%@",key,obj);
        UNLOCK(self.cacheSemaphore_t);
    }
    if ([self.eliminatedDelegate respondsToSelector:@selector(imageMemoryCacheSetObject:forKey:)]) {
        [self.eliminatedDelegate imageMemoryCacheSetObject:obj forKey:key];
    }
}

- (void)removeObjectForKey:key {
    [super removeObjectForKey:key];
    LOCK(self.cacheSemaphore_t);
    [self.cacheMapTable removeObjectForKey:key];
    NSLog(@"内存删除：Key：%@",key);
    UNLOCK(self.cacheSemaphore_t);
}

- (void)removeAllObjects {
    [super removeAllObjects];
    LOCK(self.cacheSemaphore_t);
    [self.cacheMapTable removeAllObjects];
    NSLog(@"移除内存所有图片缓存");
    UNLOCK(self.cacheSemaphore_t);
    if ([self.eliminatedDelegate respondsToSelector:@selector(imageMemoryCacheRemoveAllObject)]) {
        [self.eliminatedDelegate imageMemoryCacheRemoveAllObject];
    }
}

- (NSArray *)fetchAllCacheKeys {
    LOCK(self.cacheSemaphore_t);
    NSMutableArray *allKeysArray = [NSMutableArray creatWeakMutableArray];
    NSEnumerator *allKeys = [self.cacheMapTable keyEnumerator];
    id key;
    while (key = [allKeys nextObject] ) {
        if (key) {
            [allKeysArray addObject:key];
        }
    }
    UNLOCK(self.cacheSemaphore_t);
    return (NSArray *)allKeysArray;
}

- (NSArray *)fetchAllCacheValues {
    LOCK(self.cacheSemaphore_t);
    NSMutableArray *allValuesArray = [NSMutableArray creatWeakMutableArray];
    NSEnumerator *allValue = [self.cacheMapTable objectEnumerator];
    id key;
    while (key = [allValue nextObject] ) {
        if (key) {
            [allValuesArray addObject:key];
        }
    }
    UNLOCK(self.cacheSemaphore_t);
    return (NSArray *)allValuesArray;
}

- (NSDictionary *)fetchAllKeyValues {
    LOCK(self.cacheSemaphore_t);
    NSMutableDictionary *keyValueDict = [NSMutableDictionary creatWeakMutableDict];
    NSEnumerator *allKeys = [self.cacheMapTable keyEnumerator];
    id key;
    while (key = [allKeys nextObject] ) {
        if (key) {
            id value = [self.cacheMapTable objectForKey:key];
            if (value) {
                [keyValueDict setObject:value forKey:key];
            }
        }
    }
    UNLOCK(self.cacheSemaphore_t);
    return (NSDictionary *)keyValueDict;
}

#pragma mark - NSCacheDelegate
- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    NSLog(@"%s",__func__);
    if ([self.eliminatedDelegate respondsToSelector:@selector(imageMemoryCacheRemoveObjectForKey:)]) {
        
    }
}


@end
