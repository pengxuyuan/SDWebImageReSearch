//
//  NSCache+PXYExtension.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/4/17.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "NSCache+PXYExtension.h"

@implementation NSCache (PXYExtension)

- (id)objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}

- (void)setObject:(id)object forKeyedSubscript:(id)key {
    if (!object) {
        object =  [NSNull null];
    }
    [self setObject:object forKey:key];
}

@end
