//
//  PXYMD5DigestHelper.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/16.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 MD5 摘要算法
 */
@interface PXYMD5DigestHelper : NSObject

/**
 将字符串转换成大写32位MD5值 16进制
 */
+ (NSString *)convertToUpper32BitsMD5With:(NSString *)str;

/**
 将字符串转换成小写32位MD5值 16进制
 */
+ (NSString *)convertToLower32BitsMD5With:(NSString *)str;

/**
 将字符串转换成大写16位MD5值 16进制
 */
+ (NSString *)convertToUpper16BitsMD5With:(NSString *)str;

/**
 将字符串转换成小写16位MD5值 16进制
 */
+ (NSString *)convertToLower16BitsMD5With:(NSString *)str;


@end
