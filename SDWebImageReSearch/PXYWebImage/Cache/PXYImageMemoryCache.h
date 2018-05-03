//
//  PXYImageMemoryCache.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/6.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 内存缓存类
 1.利用 NSCache 实现内存缓存
 2.利用 “泛型” 标识 Key-Value 的类型
 3.利用 NSMapTable 属性做一个内存警告时候的小优化
 4.提供 API 返回当前缓存中的所有的 Key，Value，Key-Value，这个返回的 NSArray NSDictionary 不会强引用对象，也不要求 Key 实现 NSCoping 协议
 5.PXYImageMemoryCacheEliminatedDelegate 代理抛出，这里可以让外面控制缓存的淘汰策略
 
 
 
 * 这里是否有必要实现成单例类？CacheManager 管理的时候，一般都会将 MemoryCache 定义成属性，CacheManager 一般又是单例，所以这里定义成单例意义不大
 * 万一外界直接使用 MemoryCache 这个类，想查询当前的缓存情况，还是这里定义成单例吧
 
 */

@protocol PXYImageMemoryCacheEliminatedDelegate <NSObject>
@optional
- (void)imageMemoryCacheSetObject:(id)obj forKey:(id)key;
- (void)imageMemoryCacheObjectForKey:(id)key fetchValue:(id)value;
- (void)imageMemoryCacheRemoveObjectForKey:(id)key;
- (void)imageMemoryCacheRemoveAllObject;

@end

@interface PXYImageMemoryCache <KeyType, ObjectType> : NSCache <KeyType, ObjectType>

+ (instancetype)shareInstance;

@property (nonatomic, weak) id<PXYImageMemoryCacheEliminatedDelegate> eliminatedDelegate;

- (NSArray <KeyType>*)fetchAllCacheKeys;

- (NSArray <ObjectType>*)fetchAllCacheValues;

- (NSDictionary <KeyType, ObjectType>*)fetchAllKeyValues;




@end
