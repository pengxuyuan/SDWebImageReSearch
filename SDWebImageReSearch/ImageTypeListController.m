//
//  ImageTypeListController.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/6/20.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "ImageTypeListController.h"
#import "ImageProcessHelper.h"
#import "NSData+PXYImageContentType.h"

@interface ImageTypeListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imageStrArray;

@end

@implementation ImageTypeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageStrArray = [NSMutableArray array];
    [self.imageStrArray addObject:@"JPEG.jpg"];
    [self.imageStrArray addObject:@"JPEG2000.jp2"];
    [self.imageStrArray addObject:@"JPG.jpg"];
    [self.imageStrArray addObject:@"mew_baseline.jpg"];
    
    [self.imageStrArray addObject:@"PNG.png"];
    [self.imageStrArray addObject:@"mew_baseline.png"];
    [self.imageStrArray addObject:@"check_green.png"];
    
    [self.imageStrArray addObject:@"BMP.bmp"];
    [self.imageStrArray addObject:@"GIF.gif"];
    [self.imageStrArray addObject:@"HEIF.heic"];
    [self.imageStrArray addObject:@"OpenEXR.exr"];
    [self.imageStrArray addObject:@"PDF.pdf"];
    [self.imageStrArray addObject:@"TIFF.tiff"];
    [self.imageStrArray addObject:@"WebP.webp"];
    

    
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.imageStrArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"dequeueReusableCellWithIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imageStr = self.imageStrArray[indexPath.row];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageStr ofType:@""];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    

    
    cell.imageView.image = [UIImage imageNamed:imageStr];
    
    NSString *imageUTType = PXYFecthImageUTType([UIImage imageNamed:imageStr]);
    PXYImageFormat imageFormat = [NSData pxy_fecthImageFormatForImageData:imageData];
    imageUTType = [NSData pxy_fectchUTTypeForPXYImageFormat:imageFormat];
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",imageStr,imageUTType];
    cell.textLabel.numberOfLines = 0;

}

#pragma mark - Lazzy load
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
    }
    return _tableView;
}


@end
