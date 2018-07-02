//
//  ListTableViewCell.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/19.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "ListTableViewCell.h"
#import "UIImageView+PXYWebCache.h"
#import "ListTableViewModel.h"

@interface ListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;


@end

@implementation ListTableViewCell

+ (instancetype)listTableViewCellWithTableVIew:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ListTableViewCell";
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ListTableViewCell" owner:self options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ListTableViewModel *)model {
    _model = model;
//    model.imageUrl1 = nil;
    [self.imageView1 setImageWithURL:[NSURL URLWithString:model.imageUrl1] placeholderImage:[UIImage imageNamed:@"HomeActivity1"]];
//    [self.imageView2 setImageWithURL:[NSURL URLWithString:model.imageUrl2] placeholderImage:[UIImage imageNamed:@"HomeActivity2"]];
//    [self.imageView3 setImageWithURL:[NSURL URLWithString:model.imageUrl3] placeholderImage:[UIImage imageNamed:@"HomeActivity3"]];
}

@end
