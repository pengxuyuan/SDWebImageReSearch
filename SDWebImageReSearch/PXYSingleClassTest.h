//
//  PXYSingleClassTest.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/15.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCSingleTool.h"

@interface PXYSingleClassTest : NSObject
interfaceSingleton(singleClassTest)

+ (instancetype)shareInstance;


+ (void)destroyInstance;

@end
