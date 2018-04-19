//
//  PXYImageMemoryCacheEliminatedRule.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/4/19.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "PXYImageMemoryCacheEliminatedRule.h"
#import "PXYImageMemoryCache.h"

@interface ImageCacheNode : NSObject

@property (nonatomic, strong) id key;
@property (nonatomic, strong) ImageCacheNode *preNode;
@property (nonatomic, strong) ImageCacheNode *nextNode;

@end

@implementation ImageCacheNode

@end


@interface PXYImageMemoryCacheEliminatedRule() <PXYImageMemoryCacheEliminatedDelegate>

@property (nonatomic, assign) NSInteger capacity;
@property (nonatomic, strong) ImageCacheNode *headNode;
@property (nonatomic, strong) ImageCacheNode *tailNode;
@property (nonatomic, strong) NSMapTable *mapTable;

@end

@implementation PXYImageMemoryCacheEliminatedRule

#pragma mark - Life Cycle
+ (instancetype)shareInstanceWithCapacity:(NSInteger)capacity {
    static dispatch_once_t onceToken;
    static PXYImageMemoryCacheEliminatedRule *shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [PXYImageMemoryCacheEliminatedRule new];
        [PXYImageMemoryCache shareInstance].eliminatedDelegate = shareInstance;
        shareInstance.mapTable = [NSMapTable strongToStrongObjectsMapTable];
        shareInstance.capacity = capacity;
    });
    return shareInstance;
}

#pragma mark - PXYImageMemoryCacheEliminatedDelegate
- (void)imageMemoryCacheObjectForKey:(id)key fetchValue:(id)value {
    if (key == nil ||
        [[PXYImageMemoryCache shareInstance] fetchAllCacheKeys].count == 0) {
        return;
    }
    
    ImageCacheNode *node = [self.mapTable objectForKey:key];
    if (node) {
        [self pushFrontWithNode:node];
    }
}

- (void)imageMemoryCacheSetObject:(id)obj forKey:(id)key {

    if (self.mapTable.count == 0) { //如果链表为空，直接放在链表头部
        self.headNode = [ImageCacheNode new];
        self.headNode.key = key;
        self.headNode.preNode = nil;
        self.headNode.nextNode = nil;
        self.tailNode = self.headNode;
        
        [self.mapTable setObject:self.headNode forKey:key];
    } else { //否则，在map中查找 链表存在
        ImageCacheNode *node = [self.mapTable objectForKey:key];
        if (node) {
            [self pushFrontWithNode:node];
        } else {
            //没有命中 缓存中不存在，需要增加，所以要判断链表的长度时候超过限制值
            if (self.mapTable.count == self.capacity) { //cache满了
                
                if (self.headNode == self.tailNode && self.headNode != nil) { //只有一个节点
                    [self.mapTable removeObjectForKey:key];
                    [[PXYImageMemoryCache shareInstance] removeObjectForKey:key];
                    
                    node = self.headNode;
                    node.key = key;
                    node.preNode = nil;
                    node.nextNode= nil;
                    
                    [self.mapTable setObject:node forKey:key];
                    [[PXYImageMemoryCache shareInstance] setObject:obj forKey:key];
                } else {
                    ImageCacheNode *p = self.tailNode;
                    self.tailNode.preNode.nextNode = self.tailNode.nextNode;
                    self.tailNode = self.tailNode.preNode;
                    
                    [self.mapTable removeObjectForKey:p.key];
                    [[PXYImageMemoryCache shareInstance] removeObjectForKey:p.key];
                    
                    p.key = key;
                    p.preNode = nil;
                    p.nextNode = self.headNode;
                    
                    self.headNode.preNode = p;
                    self.headNode = p;
                    
                    [self.mapTable setObject:p forKey:p.key];
                    [[PXYImageMemoryCache shareInstance] setObject:obj forKey:key];
                }
                
            } else {
                ImageCacheNode *node = [ImageCacheNode new];
                node.key = key;
                node.preNode = nil;
                node.nextNode = self.headNode;
                self.headNode.preNode = node;
                self.headNode = node;
                
                [self.mapTable setObject:node forKey:key];
            }
        }
    }
    
    
    
}

- (void)imageMemoryCacheRemoveObjectForKey:(id)key {
    ImageCacheNode *node = [self.mapTable objectForKey:key];
    [self deleteNodeWithNode:node];
    [self.mapTable removeObjectForKey:key];
}

- (void)imageMemoryCacheRemoveAllObject {
    self.headNode = nil;
    self.tailNode = nil;
    [self.mapTable removeAllObjects];
}

- (id)imageMemoryCacheShouldRemoveCache {
    return nil;
}

#pragma mark - Private Methods
- (void)pushFrontWithNode:(ImageCacheNode *)curNode {
    if ([[PXYImageMemoryCache shareInstance] fetchAllCacheKeys].count == 1 ||
        curNode == _headNode) {
        return;
    }
    
    if (curNode == _tailNode) {
        self.tailNode = _tailNode.preNode;
    }
    
    curNode.preNode.nextNode = curNode.nextNode;
    if (curNode.nextNode != nil) {
        curNode.nextNode.preNode = curNode.preNode;
    }
    
    curNode.nextNode = self.headNode;
    curNode.preNode = nil;
    self.headNode.preNode = curNode;
    self.headNode = curNode;
}

- (void)deleteNodeWithNode:(ImageCacheNode *)node {
    if (!node) {
        return;
    }
    
    if (self.mapTable.count == 1 ||
        (self.headNode == self.tailNode && self.headNode != nil)) {
        [self.mapTable removeObjectForKey:self.headNode.key];
        self.headNode = nil;
        self.tailNode = nil;
    } else {
        if (node == self.headNode) {
            node.nextNode.preNode = nil;
            self.headNode = node.nextNode;
        } else if (node == self.tailNode) {
            node.preNode.nextNode = nil;
            self.tailNode = node.preNode;
        } else {
            node.preNode.nextNode = node.nextNode;
            node.nextNode.preNode = node.preNode;
        }
    }
    
}



@end
