//
//  LDDepositViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/8.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDDepositViewController.h"
#import "LDSetBankCardViewController.h"
#import "LDSetBankCardViewController.h"

@interface LDDepositViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *selectLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *beanField;

@property (nonatomic,copy) NSString *bid;

@end

@implementation LDDepositViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self createData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提现";
    
    self.submitButton.layer.cornerRadius = 2;
    
    self.submitButton.clipsToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bankClick:) name:@"bank" object:nil];
    
}

-(void)bankClick:(NSNotification *)text{

    self.selectLabel.text = text.userInfo[@"bank"];
    
    _bid = text.userInfo[@"bid"];
}

-(void)createData{
  
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getbankcard"];

    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};

    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 4002) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未绑定银行卡,请前往:设置/绑定银行卡"    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                LDSetBankCardViewController *bvc = [[LDSetBankCardViewController alloc] init];
                
                [self.navigationController pushViewController:bvc animated:YES];
            }];
            
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [action setValue:MainColor forKey:@"_titleTextColor"];
            
            [cancelAction setValue:MainColor forKey:@"_titleTextColor"];
            
            [alert addAction:action];
            
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];

}
- (IBAction)setBackButtonClick:(id)sender {
    
    LDSetBankCardViewController *cvc = [[LDSetBankCardViewController alloc] init];
    
//    cvc.block = ^(NSString *bankCard,NSString *bid){
//    
//        self.selectLabel.text = bankCard;
//        
//        _bid = bid;
//    
//    };
    
    [self.navigationController pushViewController:cvc animated:YES];
}
- (IBAction)submitButtonClick:(id)sender {
    
    if ([self.beanField.text intValue] > [_beanNumber intValue]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"魔豆不足,不能提现"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            self.beanField.text = nil;
        }];
        
        [action setValue:MainColor forKey:@"_titleTextColor"];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
    
        if ([self.beanField.text floatValue] >=70) {
            
            if ([self.beanField.text intValue] % 7 == 0) {
                
                [self createSubmitData:[self.beanField.text intValue]/7];
                
            }else{
            
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"提现金额%.2f元,剩余魔豆%d个",[self.beanField.text intValue] / 7 * [_scale floatValue],[self.beanField.text intValue] % 7]    preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self createSubmitData:[self.beanField.text intValue]/7];
                    
                }];
                
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
                
                if (PHONEVERSION.doubleValue >= 8.3) {
                    
                    [action setValue:MainColor forKey:@"_titleTextColor"];
                    
                    [cancelAction setValue:MainColor forKey:@"_titleTextColor"];
                }
                
                [alert addAction:action];
                
                [alert addAction:cancelAction];
                
                [self presentViewController:alert animated:YES completion:nil];
            
            }
            
            
        }else{
        
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"提现魔豆数量必须大于等于70"    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                self.beanField.text = nil;
            }];
            
            [action setValue:MainColor forKey:@"_titleTextColor"];
            
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    
    }
    
}

-(void)createSubmitData:(int)price{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/tixian"];
    
    if (_bid.length == 0) {
        
        _bid = @"";
    }
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"bid":_bid,@"money":[NSString stringWithFormat:@"%d",7 * price],@"amount":[NSString stringWithFormat:@"%.2f",price * [_scale floatValue]]};
    
    NSLog(@"%@,%@",[NSString stringWithFormat:@"%d",7 * price],[NSString stringWithFormat:@"%.2f",price * [_scale floatValue]]);
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
        }else{
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
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
