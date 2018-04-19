//
//  LRUImplement.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/4/17.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 实现 LRU 算法，最近最少使用淘汰算法
 1.按照自己的理解，利用 Objective-C 来实现
    使用 Map 来记录 Key-Value
    使用 Array 来记录 Key 的使用顺序
 
 */

@interface LRUImplement : NSObject

- (instancetype)initLRUMaxCapacityWithCapacity:(NSInteger)capacity;

- (void)putKey:(id)key Value:(id)value;
- (id)getValueWithKey:(id)key;


@end
