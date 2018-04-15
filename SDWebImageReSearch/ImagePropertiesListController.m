//
//  ImagePropertiesListController.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/4/14.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "ImagePropertiesListController.h"
#import "ImageProcessHelper.h"

@interface ImagePropertiesListController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSourceArray;

@end

@implementation ImagePropertiesListController

#pragma mark - UIViewController Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    _dataSourceArray = PropTree(PXYFetchImagePropertiesWithImageName(@"HomeActivity1@2x.png"));
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Public Methods

#pragma mark - Private Methods

#pragma mark - Request

#pragma mark - Setter

#pragma mark - Lazzy load & Getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"UITableViewCellImage";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    
    NSDictionary *dict = _dataSourceArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@",[dict objectForKey:@"key"],[dict objectForKey:@"val"]];
    
//    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
