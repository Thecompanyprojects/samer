//
//  LDAlwaysQuestionH5ViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/10/20.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDAlwaysQuestionH5ViewController.h"

@interface LDAlwaysQuestionH5ViewController ()

@end

@implementation LDAlwaysQuestionH5ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Samer";

    WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX])];
    if (@available(iOS 11.0, *)) {
        web.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.url]]];
    [web loadRequest:request];
   // web.scalesPageToFit = YES;
    [self.view addSubview:web];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
