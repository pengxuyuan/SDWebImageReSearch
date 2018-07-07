//
//  ViewController.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/2/26.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "ViewController.h"

#import "ListViewController.h"
#import "PXYImageCacheManager.h"
#import "NSMutableArray+PXYExtension.h" 
#import "NSMutableDictionary+PXYExtension.h"
#import "ListTableViewModel.h"
#import "UIImage+WCImage.h"
#import "GenericsModel.h"
#import "ImageRelateViewController.h"
#import "ImageProcessHelper.h"
#import "ImagePropertiesListController.h"

#import "PXYImageMemoryCache.h"
#import "NSCache+PXYExtension.h"
#import "LRUImplement.h"
#import "LRUDoubleLinkedList.h"
#import "PXYImageMemoryCacheEliminatedRule.h"

#import "ImageResearchController.h"
#import "SandboxViewController.h"
#import "ImageTypeListController.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UILabel *diskCacheInfo;


@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = PXYCreateUIImageFromFileName(@"timg5.gif");
    self.imageView2.image = PXYCreateUIImageFromFileName(@"HomeActivity1@2x.png");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *info = [NSString stringWithFormat:@"DiskCache:Size:%lu-Count:%lu",(unsigned long)[[PXYImageCacheManager shareInstance] fetchDiskCacheSize],(unsigned long)[[PXYImageCacheManager shareInstance] fetchDiskCacheCount]];
    self.diskCacheInfo.text = info;
}

- (IBAction)jumpTableViewPage:(id)sender {
    ListViewController *list = [ListViewController new];
    [self.navigationController pushViewController:list animated:YES];
}

- (IBAction)clearMemoryCache:(id)sender {
    [[PXYImageCacheManager shareInstance] clearAllMemoryCache];
}

- (IBAction)clearDiskCache:(id)sender {
    [[PXYImageCacheManager shareInstance] clearAllDiskCacheCompletion:nil];
}

- (IBAction)clearAllCache:(id)sender {
    [[PXYImageCacheManager shareInstance] clearAllMemoryCache];
    [[PXYImageCacheManager shareInstance] clearAllDiskCacheCompletion:nil];
}

- (IBAction)imageRelate:(id)sender {
    ImageRelateViewController *imageRelate = [ImageRelateViewController new];
    [self.navigationController pushViewController:imageRelate animated:YES];
}

- (IBAction)imagePropertiesPage:(id)sender {
    ImagePropertiesListController *imageProperty = [ImagePropertiesListController new];
    [self.navigationController pushViewController:imageProperty animated:YES];
}

- (IBAction)imageResearch:(id)sender {
//    ImageResearchController *research = [ImageResearchController new];
//    [self.navigationController pushViewController:research animated:YES];
    
    ImageTypeListController *imageType = [ImageTypeListController new];
    [self.navigationController pushViewController:imageType animated:YES];
}

- (IBAction)sandbox:(id)sender {
//    SandboxViewController *sandbox = [SandboxViewController new];
//    [self.navigationController pushViewController:sandbox animated:YES];
    
    ImageResearchController *research = [ImageResearchController new];
    [self.navigationController pushViewController:research animated:YES];
}




@end
