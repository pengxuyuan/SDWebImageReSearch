//
//  ListViewController.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/3/19.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "ListViewController.h"
#import "ListTableViewCell.h"
#import "ListTableViewModel.h"
#import "UIImageView+PXYWebCache.h"

//static NSString *const kMultiImage0 = @"https://upload.jianshu.io/admin_banners/web_images/4219/05809448a1c38a25c913d9668eb6fcda272b4ab2.jpg?imageMogr2/auto-orient/strip|imageView2/1/w/1250/h/540";
static NSString *const kMultiImage0 = @"https://upload.jianshu.io/admin_banners/web_images/4274/c5284959b5cd3b77e607e7398a0abc82a3eabd4e.jpg";
static NSString *const kMultiImage1 = @"https://upload.jianshu.io/collections/images/95/1.jpg";
static NSString *const kMultiImage2 = @"https://upload-images.jianshu.io/upload_images/6525607-ca0cb16d295d0c55.jpg";
static NSString *const kMultiImage3 = @"https://upload.jianshu.io/collections/images/21/20120316041115481.jpg";
static NSString *const kMultiImage4 = @"https://upload.jianshu.io/collections/images/261938/man-hands-reading-boy-large.jpg";
static NSString *const kMultiImage5 = @"https://upload.jianshu.io/collections/images/14/6249340_194140034135_2.jpg";
static NSString *const kMultiImage6 = @"https://upload.jianshu.io/collections/imag7es/494271/51164a1egd7b1a4a7c491_690.jpg";

@interface ListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildData];
    [self.view addSubview:self.tableView];
}

- (nullable NSString *)fetchPersonWithAdress:(_Nullable id * _Nonnull )adress {
    return nil;
}

- (nullable NSString *)fetchPersonWithTeacher:(_Nonnull id * _Nonnull )adress {
    return nil;
}

- (void)buildData {
    _modelArray = [NSMutableArray array];
    ListTableViewModel *model1 = [ListTableViewModel creatModelWithImageUrl1:kMultiImage0 imageUrl2:kMultiImage1 imageUrl3:kMultiImage2];
    ListTableViewModel *model2 = [ListTableViewModel creatModelWithImageUrl1:kMultiImage0 imageUrl2:kMultiImage1 imageUrl3:kMultiImage2];
    ListTableViewModel *model3 = [ListTableViewModel creatModelWithImageUrl1:kMultiImage0 imageUrl2:kMultiImage1 imageUrl3:kMultiImage2];
    ListTableViewModel *model4 = [ListTableViewModel creatModelWithImageUrl1:kMultiImage0 imageUrl2:kMultiImage1 imageUrl3:kMultiImage2];
    ListTableViewModel *model5 = [ListTableViewModel creatModelWithImageUrl1:kMultiImage0 imageUrl2:kMultiImage1 imageUrl3:kMultiImage2];
    ListTableViewModel *model6 = [ListTableViewModel creatModelWithImageUrl1:kMultiImage0 imageUrl2:kMultiImage1 imageUrl3:kMultiImage2];
    ListTableViewModel *model7 = [ListTableViewModel creatModelWithImageUrl1:kMultiImage0 imageUrl2:kMultiImage1 imageUrl3:kMultiImage2];
    ListTableViewModel *model8 = [ListTableViewModel creatModelWithImageUrl1:kMultiImage0 imageUrl2:kMultiImage1 imageUrl3:kMultiImage2];
    ListTableViewModel *model9 = [ListTableViewModel creatModelWithImageUrl1:kMultiImage0 imageUrl2:kMultiImage1 imageUrl3:kMultiImage2];
    ListTableViewModel *model10 = [ListTableViewModel creatModelWithImageUrl1:kMultiImage0 imageUrl2:kMultiImage1 imageUrl3:kMultiImage2];
    
    NSArray *array = @[model1,
                    model2,
                    model3,
                    model4,
                    model5,
                    model6,
                    model7,
                    model8,
                    model9,
                    model10];
    
    [_modelArray addObjectsFromArray:array];
    [_modelArray addObjectsFromArray:array];
    [_modelArray addObjectsFromArray:array];
    [_modelArray addObjectsFromArray:array];
    [_modelArray addObjectsFromArray:array];
    [_modelArray addObjectsFromArray:array];
    [_modelArray addObjectsFromArray:array];
    [_modelArray addObjectsFromArray:array];
    [_modelArray addObjectsFromArray:array];
    [_modelArray addObjectsFromArray:array];
    [_modelArray addObjectsFromArray:array];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableViewCell *cell = [ListTableViewCell listTableViewCellWithTableVIew:tableView indexPath:indexPath];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.rowHeight = 80;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


@end
