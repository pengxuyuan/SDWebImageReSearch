//
//  NSOperation+PXYWebImageExtension.h
//  SD-下载一张图片
//
//  Created by Pengxuyuan on 2018/6/2.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperation (PXYWebImageExtension)

@property (nonatomic, strong) NSMutableArray <NSMutableDictionary *>*operationCallbackArray;

@end
