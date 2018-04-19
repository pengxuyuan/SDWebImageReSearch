//
//  PXYImageMemoryCacheEliminatedRule.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/4/19.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Image Memory Cache 内存淘汰算法 目前用 LRU
 */
@interface PXYImageMemoryCacheEliminatedRule : NSObject

+ (instancetype)shareInstanceWithCapacity:(NSInteger)capacity;

@end
