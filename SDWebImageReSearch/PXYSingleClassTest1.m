//
//  PXYSingleClassTest1.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/4/24.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "PXYSingleClassTest1.h"

@implementation PXYSingleClassTest1

+ (instancetype)shareInstance {
    PXYSingleClassTest1 *instance = [PXYSingleClassTest1 new];
    return instance;
}

+ (id)shareInstance1 {
    NSObject *a = [[NSObject alloc] init];
    return a;
//    PXYSingleClassTest1 *instance = [PXYSingleClassTest1 new];
//    return instance;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    static PXYSingleClassTest1 *instance;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}
    
- (id)copyWithZone:(nullable NSZone *)zone {
    return [PXYSingleClassTest1 shareInstance];
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [PXYSingleClassTest1 shareInstance];
}

- (void)test {
    
}
@end
