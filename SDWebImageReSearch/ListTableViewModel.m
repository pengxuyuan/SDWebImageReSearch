//
//  ListTableViewModel.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/19.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "ListTableViewModel.h"

@implementation ListTableViewModel

+ (instancetype)creatModelWithImageUrl1:(NSString *)url1
                              imageUrl2:(NSString *)url2
                              imageUrl3:(NSString *)url3 {
    ListTableViewModel *model = [ListTableViewModel new];
    model.imageUrl1 = url1;
    model.imageUrl2 = url2;
    model.imageUrl3 = url3;
    return model;
}

@end
