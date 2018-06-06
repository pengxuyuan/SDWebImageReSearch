//
//  AppDelegate.m
//  SDWebImageReSearch
//
//  Created by Pengxuyuan on 2018/2/26.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "AppDelegate.h"
#import "PXYSingleClassTest.h"
#import "PXYMD5DigestHelper.h"
#import "PXYImageMemoryCacheEliminatedRule.h"
#import "PXYSingleClassTest1.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
    NSLog(@"程序即将启动完成 %s",__func__);
    
    
    
//    NSString *urlStr = @"http://www.baidu.com";
//    NSURL *url = [NSURL URLWithString:urlStr];
//    urlStr = @"http://www.baidu.com/a|b";
//    url = [NSURL URLWithString:urlStr];
//    urlStr = @"https://upload.jianshu.io/admin_banners/web_images/4219/05809448a1c38a25c913d9668eb6fcda272b4ab2.jpg?imageMogr2/auto-orient/strip|imageView2/1/w/1250/h/540";
//    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
//    NSString *path = @"www.baidu.com?a=1&b=2";
//    NSString *path2 = @"http://fanyi.baidu.com/translate?query=#auto/zh/";
//    NSString *path3 = @"http://fanyi.baidu.com/translate?query=#zh/en/测试";
//    NSURL *url = [NSURL URLWithString:path];
//    NSURL *url2 = [NSURL URLWithString:path2];
//    NSURL *url3 = [NSURL URLWithString:path3];
//    
//    NSLog(@"%@", url);
//    NSLog(@"%@", url2);
//    NSLog(@"%@", url3);
//    
//    path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    path isEqualToString:<#(nonnull NSString *)#>
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"程序完全启动完成 %s",__func__);
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"程序将要进入前台 %s",__func__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"程序已经获取到焦点 %s",__func__);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"程序将要失去焦点 %s",__func__);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"程序已经进入后台 %s",__func__);
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"程序收到内存警告 %s",__func__);
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"程序将要退出 %s",__func__);
}
- (void)applicationSignificantTimeChange:(UIApplication *)application {
    NSLog(@"程序收到时间修改 %s",__func__);
}



@end
