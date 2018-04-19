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

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
    NSLog(@"程序即将启动完成 %s",__func__);
#if UIKIT_STRING_ENUMS
    NSLog(@"1");
#else
    NSLog(@"0");
#endif
    
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
