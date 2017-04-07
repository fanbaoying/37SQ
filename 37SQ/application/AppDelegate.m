//
//  AppDelegate.m
//  37shequ
//
//  Created by administrator on 16/9/22.
//  Copyright © 2016年 hjp. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "AddNewViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "AFNetworking.h"
#import "SMS_SDK/SMSSDK.h"

#define AppKey @"1783c58ec9364"
#define AppSecret @"91abcef1f515be8bb059423efbdfcfa9"

@interface AppDelegate ()
//< RCIMUserInfoDataSource>


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //融云
//    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    
    ///
    self.addType = 0;
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    ViewController *vc = [[ViewController alloc]init];
    SecondViewController *sc = [[SecondViewController alloc]init];
    ThirdViewController *tc = [[ThirdViewController alloc]init];
    FourthViewController *fc = [[FourthViewController alloc]init];
//    AddNewViewController *anvc = [[AddNewViewController alloc]init];
    
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:vc];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:sc];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:tc];
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:fc];
    UINavigationController *nav = [[UINavigationController alloc]init];
    
    self.tabBar = [[UITabBarController alloc]init];
    self.tabBar.viewControllers = @[nav1,nav2,nav,nav3,nav4];
    
    //选中与未被选中图片的渲染
    nav1.tabBarItem.title = @"首页";
    nav1.tabBarItem.image = [[UIImage imageNamed:@"home@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav1.tabBarItem.selectedImage = [[UIImage imageNamed:@"home@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    nav2.tabBarItem.title = @"喜好";
    nav2.tabBarItem.image = [[UIImage imageNamed:@"favorites@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav2.tabBarItem.selectedImage = [[UIImage imageNamed:@"favorites@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
 
//    nav.tabBarItem.image = [[UIImage imageNamed:@"add@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    nav3.tabBarItem.title = @"社区";
    nav3.tabBarItem.image = [[UIImage imageNamed:@"spider@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav3.tabBarItem.selectedImage = [[UIImage imageNamed:@"spider@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    nav4.tabBarItem.title = @"我的";
    nav4.tabBarItem.image = [[UIImage imageNamed:@"user@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav4.tabBarItem.selectedImage = [[UIImage imageNamed:@"user@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    //tabBar主题颜色
    self.tabBar.tabBar.tintColor = [UIColor colorWithRed:255/255.0 green:204/255.0 blue:102/255.0 alpha:1];
    self.tabBar.tabBar.backgroundColor = [UIColor whiteColor];
    
    //设置tabBar的背景View(backgroundColor给到的是半透明的颜色)
    UIView *tabBarBgView = [[UIView alloc]initWithFrame:self.tabBar.tabBar.bounds];
    tabBarBgView.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    [self.tabBar.tabBar insertSubview:tabBarBgView atIndex:0];
    self.tabBar.tabBar.opaque = YES;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:204/255.0 blue:102/255.0 alpha:1]} forState:UIControlStateSelected];

    
    //隐藏导航栏
    nav1.navigationBarHidden = YES;
    nav2.navigationBarHidden = YES;
    nav3.navigationBarHidden = YES;
    nav4.navigationBarHidden = YES;
//    nav.navigationBarHidden = YES;
    
    [nav.navigationController removeFromParentViewController];
    self.window.rootViewController = _tabBar;
    
    //初始化应用,appKey和appSecret从后台申请得
    [SMSSDK registerApp:AppKey withSecret:AppSecret];

    [self.window makeKeyAndVisible];
    
    
    
//    //中间的加号按钮
    
    self.mids = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-45, [UIScreen mainScreen].bounds.size.height-60, 90, 90)];
    self.mids.backgroundColor = [UIColor clearColor];
    
    self.mid = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-30, [UIScreen mainScreen].bounds.size.height-60, 60, 60)];
    self.mid.layer.cornerRadius = 30;
    self.mid.backgroundColor = [UIColor colorWithRed:255/255.0 green:204/255.0 blue:102/255.0 alpha:1];
    [self.mid setImage:[UIImage imageNamed:@"add@2x"] forState:0];
    [self.mid setImage:[UIImage imageNamed:@"add@2x"] forState:1];
    [self.mid.layer setBorderWidth:1.0];
    [self.mid.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.mid addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:_mids];
    [[UIApplication sharedApplication].keyWindow addSubview:_mid];

    return YES;
}

- (void)add {
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [SQUserid objectForKey:@"userid"];
    
    if (user_id) {
        AddNewViewController *addView = [[AddNewViewController alloc]init];
        
//        self.mid.hidden = YES;
        
        [self.window.rootViewController presentViewController:addView animated:YES completion:nil];
        
    }else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"前往登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:action1];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
