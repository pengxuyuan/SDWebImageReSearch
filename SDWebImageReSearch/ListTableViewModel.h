//
//  ListTableViewModel.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/19.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListTableViewModel : NSObject

@property (nonatomic, copy) NSString *imageUrl1;
@property (nonatomic, copy) NSString *imageUrl2;
@property (nonatomic, copy) NSString *imageUrl3;

+ (instancetype)creatModelWithImageUrl1:(NSString *)url1
                              imageUrl2:(NSString *)url2
                              imageUrl3:(NSString *)url3;


@end
