//
//  LDBulletinViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/26.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDBulletinViewController.h"

@interface LDBulletinViewController ()

@end

@implementation LDBulletinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX])];
    
    if (@available(iOS 11.0, *)) {
        
        web.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];

    [self.view addSubview:web];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
