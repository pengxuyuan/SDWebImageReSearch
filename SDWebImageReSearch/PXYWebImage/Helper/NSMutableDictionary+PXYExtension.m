//
//  NSMutableDictionary+PXYExtension.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/14.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "NSMutableDictionary+PXYExtension.h"
#import <CoreFoundation/CoreFoundation.h>

@implementation NSMutableDictionary (PXYExtension)

+ (NSMutableDictionary *)creatWeakMutableDict {
    
    CFMutableDictionaryRef cfMutableDict = CFDictionaryCreateMutable(NULL,
                                                                     0,
                                                                     &keyCallBack,
                                                                     &valueCallbacks);
    NSMutableDictionary *mutableDict = (__bridge_transfer NSMutableDictionary *)cfMutableDict;
    
    return mutableDict;
}

//typedef const void *    (*CFDictionaryRetainCallBack)(CFAllocatorRef allocator, const void *value);
//typedef void        (*CFDictionaryReleaseCallBack)(CFAllocatorRef allocator, const void *value);
const void * PXYDictionaryRetainCallback (CFAllocatorRef allocator, const void *value) {
    return value;
}

void PXYDictionaryReleaseCallback(CFAllocatorRef allocator, const void *value) {
    //    return value;
}

CFDictionaryKeyCallBacks keyCallBack = {
    0,
    PXYDictionaryRetainCallback,
    PXYDictionaryReleaseCallback,
    NULL,
    CFEqual,
    CFHash

//    CFIndex                version;
//    CFDictionaryRetainCallBack        retain;
//    CFDictionaryReleaseCallBack        release;
//    CFDictionaryCopyDescriptionCallBack    copyDescription;
//    CFDictionaryEqualCallBack        equal;
//    CFDictionaryHashCallBack        hash;
};

CFDictionaryValueCallBacks valueCallbacks = {
    0,
    PXYDictionaryRetainCallback,
    PXYDictionaryReleaseCallback,
    NULL,
    CFEqual
    
//    CFIndex                version;
//    CFDictionaryRetainCallBack        retain;
//    CFDictionaryReleaseCallBack        release;
//    CFDictionaryCopyDescriptionCallBack    copyDescription;
//    CFDictionaryEqualCallBack        equal;
};






@end
