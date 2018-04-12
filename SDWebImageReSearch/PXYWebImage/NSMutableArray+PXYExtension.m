//
//  NSMutableArray+PXYExtension.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/14.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "NSMutableArray+PXYExtension.h"
#import <CoreFoundation/CoreFoundation.h>

@implementation NSMutableArray (PXYExtension)

+ (NSMutableArray *)creatWeakMutableArray {
    CFMutableArrayRef cfMutableArray = CFArrayCreateMutable(NULL, 0, &arrayCallbacks);
    NSMutableArray *mutableArray = (__bridge_transfer NSMutableArray *) cfMutableArray;
    return mutableArray;
}

const void * PXYArrayRetainCallBack(CFAllocatorRef allocator, const void *value) {
    return value;
}

void PXYAArrayReleaseCallBack(CFAllocatorRef allocator, const void *value) {
    
}

CFArrayCallBacks arrayCallbacks = {
    0,
    PXYArrayRetainCallBack,
    PXYAArrayReleaseCallBack,
    NULL,
    CFEqual
};




@end
