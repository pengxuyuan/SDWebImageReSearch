//
//  PXYSingleClassTest1.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/4/24.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXYSingleClassTest1 : NSObject <NSCopying, NSMutableCopying>

+ (instancetype)shareInstance;

+ (id)shareInstance1;

//- (void)test;
@end
