//
//  PXYImageMemoryCache.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/6.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXYImageMemoryCache <KeyType, ObjectType> : NSCache <KeyType, ObjectType>

+ (instancetype)shareInstance;

- (NSArray <KeyType>*)fetchAllCacheKeys;

- (NSArray <ObjectType>*)fetchAllCacheValues;

- (NSDictionary <KeyType, ObjectType>*)fetchAllKeyValues;


@end
