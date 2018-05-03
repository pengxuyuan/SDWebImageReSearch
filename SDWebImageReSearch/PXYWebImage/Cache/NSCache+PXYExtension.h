//
//  NSCache+PXYExtension.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/4/17.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 NSCache 扩展
 */
@interface NSCache (PXYExtension)

/**
 实现这两个方法，NSCache 就具有下标糖语法功能
 */
- (id)objectForKeyedSubscript:(id)key;

- (void)setObject:(id)object forKeyedSubscript:(id)key;

@end
