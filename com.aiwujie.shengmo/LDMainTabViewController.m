//
//  LDMainTabViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/18.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDMainTabViewController.h"
#import "LDMainNavViewController.h"

@interface LDMainTabViewController ()

@end

@implementation LDMainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *array;
    array = @[@"LDHomeViewController",@"LDDynamicViewController",@"LDInformationViewController",@"LDDiscoverViewController",@"LDMineViewController"];
    
    NSArray *imgArray = @[@"附近灰",@"动态灰",@"消息灰",@"发现灰",@"我的灰"];
    NSArray *nameArray = @[@"身边",@"动态",@"消息",@"公益",@"我的"];
    NSArray *titleArray = @[@"",@"",@"消息",@"公益",@"我的"];
    NSArray *sImageArray = @[@"附近紫",@"动态紫",@"消息紫",@"发现紫",@"我的紫"];
    
    for (int i = 0; i < 5; i++) {
        
        Class class = NSClassFromString(array[i]);
        UIViewController *vc = [[class alloc] init];
        LDMainNavViewController *nvc = [[LDMainNavViewController alloc] initWithRootViewController:vc];
        UIImage *image = [UIImage imageNamed:imgArray[i]];
        nvc.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nvc.tabBarItem.title = nameArray[i];
        nvc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        vc.navigationItem.title = titleArray[i];
        UIImage *sImage = [UIImage imageNamed:sImageArray[i]];
        nvc.tabBarItem.selectedImage = [sImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //更改tabbar上字体的颜色
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MainColor, NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:10],NSFontAttributeName, nil] forState:UIControlStateSelected];

        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:10],NSFontAttributeName, nil] forState:UIControlStateNormal];
        
        [self addChildViewController:nvc];
    }

//    UIView *backView = [[UIView alloc] init];
//    if (ISIPHONEX) {
//        backView.frame = CGRectMake(0, 0, WIDTH, 88);
//    }
//    else
//    {
//        backView.frame = CGRectMake(0, 0, WIDTH, 49);
//    }
//    backView.alpha = 0.8;
//    backView.backgroundColor = [UIColor blackColor];
//    [self.tabBar insertSubview:backView atIndex:0];
//    self.tabBar.opaque = YES;
    
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
