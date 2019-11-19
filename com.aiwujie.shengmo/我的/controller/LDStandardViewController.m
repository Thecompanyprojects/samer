//
//  LDStandardViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/4/12.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDStandardViewController.h"

@interface LDStandardViewController ()

@end

@implementation LDStandardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX])];
    
    if (@available(iOS 11.0, *)) {
        
        web.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSURLRequest *request = [[NSURLRequest alloc] init];
    
    if ([self.state isEqualToString:@"图文规范"]) {
        
        request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://hao.aiwujie.net/Home/Info/Shengmosimu/id/11"]];
        
    }else if([self.state isEqualToString:@"隐私协议"]){
    
        request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://hao.aiwujie.net/Home/Info/Shengmosimu/id/12"]];
        
    }else if([self.state isEqualToString:@"排名规则"]){
    
        request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Home/Info/Shengmosimu/id/2"]]];
        
    }else if ([self.state isEqualToString:@"互联网群组信息服务管理规定"]){
    
        request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Home/Info/Shengmosimu/id/1"]]];
        
    }else if ([self.state isEqualToString:@"动态推荐"]){
        
        request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Home/Info/news/id/5"]]];
    }
    
    [web loadRequest:request];
    
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
