//
//  SandboxViewController.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/6/5.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "SandboxViewController.h"


/*
 沙盒目录文件夹：
 Documents
 Library: Cache & Preference
 SystemData
 tmp
 
 Documen 目录 存储用户数据
 这个目录下面的文件会被 iTunes 同步
 
 Libraty 目录
 Cache 不会被 itun 同步，存放缓存数据
 Preference 偏好设置，会被 iTunes 同步，这里就是 NSUserDefaults 写的 Plist 文件
 
 tmp 临时文件，不会被 iTunes 同步
 
 */

/*
 持久化方式：
 1、将数据写成 Plist 文件
 2、NSUserDefault
 3、NSKeyedArchiver
 4、数据库
 
 
 属性列表：NSUserDefault，以 plist 格式存储在 Library/Preference，应为是明文的，这里不能存私密数据
 
 */

@interface SandboxViewController ()

@end

@implementation SandboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *homeDir = NSHomeDirectory();
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"pengxuyuan" forKey:@"name"];
    [userDefaults synchronize];
    
}


@end
