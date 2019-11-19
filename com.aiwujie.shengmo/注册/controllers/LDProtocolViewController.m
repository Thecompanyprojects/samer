//
//  LDProtocolViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/17.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDProtocolViewController.h"

@interface LDProtocolViewController ()

@end

@implementation LDProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Samer用户协议";
    
    WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX])];
    
    if (@available(iOS 11.0, *)) {
        
        web.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://hao.aiwujie.net/Home/Info/Shengmosimu/id/8"]]];
//    if ([self.type intValue] == 1) {
//
//        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://hao.aiwujie.net/Home/Info/Shengmosimu/id/8"]]];
//
//    }else{
//
//        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://hao.aiwujie.net/Home/Info/Shengmosimu/id/9"]]];
//
//    }
//
    [self.view addSubview:web];
    [self createButton];
}

- (void)createButton {
    UIButton * areaButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 36, 10, 14)];
    if (@available(iOS 11.0, *)) {
        
        [areaButton setImage:[UIImage imageNamed:@"back-11"] forState:UIControlStateNormal];
        
    }else{
        
        [areaButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    [areaButton addTarget:self action:@selector(backButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaButton];
    if (@available(iOS 11.0, *)) {
        
        leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 44);
    }
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)backButtonOnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
