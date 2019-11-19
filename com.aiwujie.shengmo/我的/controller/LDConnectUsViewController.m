//
//  LDConnectUsViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/14.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDConnectUsViewController.h"

@interface LDConnectUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *shengmoLabel;

@end

@implementation LDConnectUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"联系我们";
    [self createData];
}

-(void)createData{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/getCallAct"];
    
    [NetManager afPostRequest:url parms:nil finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 2000) {
            
            self.emailLabel.text = responseObj[@"data"][@"EMAIL"];
            
            self.mobileLabel.text = responseObj[@"data"][@"KFDH"];
            
            self.phoneLabel.text = responseObj[@"data"][@"KFSJ"];
            
            self.companyLabel.text = responseObj[@"data"][@"QYQQ"];
            
            self.shengmoLabel.text = responseObj[@"data"][@"SMQQ"];
        }
    } failed:^(NSString *errorMsg) {
        
    }];

}

- (IBAction)mobileButtonClick:(id)sender {
    
    WKWebView *webView = [[WKWebView alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_mobileLabel.text]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];

}
- (IBAction)phoneButtonClick:(id)sender {
    
    WKWebView *webView = [[WKWebView alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneLabel.text]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];

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
