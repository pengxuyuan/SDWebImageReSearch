//
//  PXYImageDiskCache.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/6.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PXYImageDiskCache : NSObject

+ (instancetype)shareInstance;

- (void)storeImage:(UIImage *)image forKey:(NSString *)key;

- (NSData *)fetchImageWithKey:(NSString *)key;

- (void)removeDiskAllObjects;

@end
