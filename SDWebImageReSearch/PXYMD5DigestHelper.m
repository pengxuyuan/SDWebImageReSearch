//
//  PXYMD5DigestHelper.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/16.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "PXYMD5DigestHelper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation PXYMD5DigestHelper

/**
 将字符串转换成大写32位MD5值 16进制
 */
+ (NSString *)convertToUpper32BitsMD5With:(NSString *)str {
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        /*
         %02X是格式控制符：‘x’表示以16进制输出，‘02’表示不足两位，前面补0；
         */
        [hash appendFormat:@"%02X", result[i]];
        //        [hash appendFormat:@"%02x", result[i]];
    }
//    NSString *mdfiveString = [hash lowercaseString];
    return hash;
}

/**
 将字符串转换成小写32位MD5值 16进制
 */
+ (NSString *)convertToLower32BitsMD5With:(NSString *)str {
    return [[self convertToUpper32BitsMD5With:str] lowercaseString];
}

/**
 将字符串转换成大写16位MD5值 16进制
 */
+ (NSString *)convertToUpper16BitsMD5With:(NSString *)str {
    NSString *str1;
    NSString *upperStr = [self convertToUpper32BitsMD5With:str];
    if (upperStr.length == 32) {
        str1 = [upperStr substringWithRange:NSMakeRange(8, 16)];
    }
    return str1;
}

/**
 将字符串转换成小写16位MD5值 16进制
 */
+ (NSString *)convertToLower16BitsMD5With:(NSString *)str {
    return [[self convertToUpper16BitsMD5With:str] lowercaseString];
}


@end
