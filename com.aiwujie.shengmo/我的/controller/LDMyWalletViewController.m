//
//  LDMyWalletViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/8.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDMyWalletViewController.h"
#import "LDChargeCenterViewController.h"
#import "LDDepositViewController.h"
#import "LDBillViewController.h"

@interface LDMyWalletViewController ()
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *chargeButton;
@property (weak, nonatomic) IBOutlet UIButton *depositButton;

@property (nonatomic,copy) NSString *account;
@property (nonatomic,copy) NSString *balance;
@property (nonatomic,copy) NSString *scale;
@end

@implementation LDMyWalletViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createData];
}

-(void)createData{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getmywalletUrl];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
        }else{
            self.balanceLabel.text = [NSString stringWithFormat:@"%@ 魔豆",responseObj[@"data"][@"wallet"]];
            self.account = responseObj[@"data"][@"nickname"];
            self.balance = responseObj[@"data"][@"wallet"];
            self.scale = responseObj[@"data"][@"pay"];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的钱包";
    self.chargeButton.layer.cornerRadius = 2;
    self.chargeButton.clipsToBounds = YES;
    self.depositButton.layer.cornerRadius = 2;
    self.depositButton.clipsToBounds = YES;
    [self createButton];
}

-(void)createButton{
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setTitle:@"账单" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)rightButtonOnClick{
    
    LDBillViewController *bvc = [[LDBillViewController alloc] init];
    [self.navigationController pushViewController:bvc animated:YES];
}

- (IBAction)chargeButtonClick:(id)sender {
    LDChargeCenterViewController *cvc = [[LDChargeCenterViewController alloc] init];
    [self.navigationController pushViewController:cvc animated:YES];
}

- (IBAction)depositButtonClick:(id)sender {
    
    LDDepositViewController *dvc = [[LDDepositViewController alloc] init];
    dvc.beanNumber = _balance;
    dvc.scale = _scale;
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
