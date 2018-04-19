//
//  LRUImplement.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/4/17.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "LRUImplement.h"

@interface LRUImplement ()

@property (nonatomic, strong) NSMutableDictionary *map;
@property (nonatomic, strong) NSMutableArray *accesses;

@property (nonatomic, assign) NSInteger maxCapacity;

@end

@implementation LRUImplement

- (instancetype)initLRUMaxCapacityWithCapacity:(NSInteger)capacity {
    self = [super init];
    if (self) {
        self.map = [NSMutableDictionary dictionary];
        self.accesses = [NSMutableArray array];
        self.maxCapacity = capacity;
    }
    return self;
}

- (void)putKey:(id)key Value:(id)value {
    if ([self.accesses containsObject:key]) {
        [self.accesses removeObject:key];
        [self.accesses addObject:key];
    }else{
        if (self.accesses.count >= self.maxCapacity) {
            NSString *key = [self.accesses firstObject];
            [self.accesses removeObject:key];
            [self.map removeObjectForKey:key];
        }
        
        [self.accesses addObject:key];
    }

    [self.map setObject:value forKey:key];
    NSLog(@"Access:%@",self.accesses);
}

- (id)getValueWithKey:(id)key {
    if ([self.accesses containsObject:key]) {
        [self.accesses removeObject:key];
        [self.accesses addObject:key];
    }
    
    id value = [self.map objectForKey:key];
    if (!value) {
        return @"-1";
    }
    return value;
}

//- (void)clearData {
//    [self.accesses removeAllObjects];
//    [self.map removeAllObjects];
//}

@end
