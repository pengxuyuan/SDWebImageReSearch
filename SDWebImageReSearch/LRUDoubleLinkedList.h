//
//  LRUDoubleLinkedList.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/4/18.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 双向链表实现 LRU
 */
@interface LRUDoubleLinkedList : NSObject

- (instancetype)initCacheWithCapacity:(NSInteger)capacity;
- (void)putWithKey:(id)key value:(id)value;
- (id)getWithKey:(id)key;
@end
