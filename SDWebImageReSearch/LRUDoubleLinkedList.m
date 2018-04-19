//
//  LRUDoubleLinkedList.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/4/18.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//


#import "LRUDoubleLinkedList.h"

@interface Node : NSObject

@property (nonatomic, strong) id key;
@property (nonatomic, strong) id value;
@property (nonatomic, strong) Node *preNode;
@property (nonatomic, strong) Node *nextNode;

@end

@implementation Node
@end


@interface LRUDoubleLinkedList()

@property (nonatomic, strong) Node *headNode;
@property (nonatomic, strong) Node *tailNode;
@property (nonatomic, assign) NSInteger capacity;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMapTable *mapTable;

@end

@implementation LRUDoubleLinkedList

- (instancetype)initCacheWithCapacity:(NSInteger)capacity {
    self = [super init];
    if (self) {
        self.headNode = nil;
        self.tailNode = nil;
        self.capacity = capacity;
        self.count = 0;
        self.mapTable = [NSMapTable strongToStrongObjectsMapTable];
    }
    return self;
}

- (void)putWithKey:(id)key value:(id)value {
    if (self.mapTable.count == 0) { //如果链表为空，直接放在链表头部
        self.headNode = [Node new];
        self.headNode.key = key;
        self.headNode.value = value;
        self.headNode.preNode = nil;
        self.headNode.nextNode = nil;
        self.tailNode = self.headNode;
        [self.mapTable setObject:self.headNode forKey:key];
        self.count ++;
    } else {//否则，在map中查找 链表存在
        Node *node = [self.mapTable objectForKey:key];
        if (node) {
            node.value = value;
            [self pushFrontWithNode:node];
        } else {
            //没有命中 缓存中不存在，需要增加，所以要判断链表的长度时候超过限制值
            if (self.count == self.capacity) {
                //cache满了
                if (self.headNode == self.tailNode && self.headNode != nil) {//只有一个节点
                    [self.mapTable removeObjectForKey:self.headNode.key];
                    node = self.headNode;
                    node.key = key;
                    node.value = value;
                    node.preNode = nil;
                    node.nextNode = nil;
                    [self.mapTable setObject:node forKey:key];
                } else {
                    Node *p = self.tailNode;
                    self.tailNode.preNode.nextNode = self.tailNode.nextNode;
                    self.tailNode = self.tailNode.preNode;
                    
                    [self.mapTable removeObjectForKey:p.key];
                    
                    p.key = key;
                    p.value = value;
                    p.nextNode = self.headNode;
                    p.preNode = self.headNode.preNode;
                    
                    self.headNode.preNode = p;
                    self.headNode = p;
                    [self.mapTable setObject:self.headNode forKey:self.headNode.key];
                }
            } else {
                Node *node = [Node new];
                node.key = key;
                node.value = value;
                node.preNode = nil;
                self.headNode.preNode = node;
                node.nextNode = self.headNode;
                self.headNode = node;
                [self.mapTable setObject:node forKey:node.key];
                self.count ++;
            }
            
        }
    }
}



- (id)getWithKey:(id)key {
    if (self.mapTable.count == 0 || key == nil) {
        return nil;
    }
    
    Node *node = [self.mapTable objectForKey:key];
    if (node) {
        [self pushFrontWithNode:node];
        return node.value;
    } else {
        return nil;
    }

}

//将元素移到链表头部
- (void)pushFrontWithNode:(Node *)curNode {
    if (self.count == 1 ||
        self.mapTable.count == 0 ||
        curNode == self.headNode) {
        return;
    }
    
    if (curNode == self.tailNode) {
        self.tailNode = curNode.preNode;
    }
    
    //删除节点
    curNode.preNode.nextNode = curNode.nextNode;
    if (curNode.nextNode != nil) {//要删除的点不是最后一个点
        curNode.nextNode.preNode = curNode.preNode;
    }
    
    curNode.nextNode = self.headNode;
    curNode.preNode = nil;
    self.headNode.preNode = curNode;
    self.headNode = curNode;
}


























@end
