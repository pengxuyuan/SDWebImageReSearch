//
//  NSOperation+PXYWebImageExtension.m
//  SD-下载一张图片
//
//  Created by Pengxuyuan on 2018/6/2.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "NSOperation+PXYWebImageExtension.h"
#import <objc/runtime.h>

const void * kOperationCallbackArray = @"koperationCallbackArray";

@implementation NSOperation (PXYWebImageExtension)

- (NSMutableArray<NSMutableDictionary *> *)operationCallbackArray {
    return objc_getAssociatedObject(self, &kOperationCallbackArray);
}

- (void)setOperationCallbackArray:(NSMutableArray<NSMutableDictionary *> *)operationCallbackArray {
    objc_setAssociatedObject(self, &kOperationCallbackArray, operationCallbackArray, OBJC_ASSOCIATION_RETAIN);
}

@end
