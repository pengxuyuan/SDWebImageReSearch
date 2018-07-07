//
//  NSOperation+PXYWebImageExtension.h
//  SD-下载一张图片
//
//  Created by Pengxuyuan on 2018/6/2.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperation (PXYWebImageExtension)
/* !!!: 这里已经不需要扩展了，自定义 Operation 直接声明属性就可以了 */
@property (nonatomic, strong) NSMutableArray <NSMutableDictionary *>*operationCallbackArray;

@end
