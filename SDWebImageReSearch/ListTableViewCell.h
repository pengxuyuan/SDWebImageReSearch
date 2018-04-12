//
//  ListTableViewCell.h
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/19.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListTableViewModel;

@interface ListTableViewCell : UITableViewCell

+ (instancetype)listTableViewCellWithTableVIew:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) ListTableViewModel *model;


@end
