//
//  NSMutableDictionary+PXYExtension.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/14.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary <KeyType, ObjectType> (PXYExtension)

+ (NSMutableDictionary <KeyType, ObjectType>*)creatWeakMutableDict;

@end
