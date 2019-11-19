//
//  LDGetChangeBindingEmailCodeViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/24.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGetChangeBindingEmailCodeViewController.h"
#import "LDBindingEmailViewController.h"

@interface LDGetChangeBindingEmailCodeViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

//发送验证码计时器
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic, assign) int second;

@end

@implementation LDGetChangeBindingEmailCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"验证原邮箱";
    
    _codeView.layer.cornerRadius = 2;
    _codeView.clipsToBounds = YES;
    
    _doneButton.layer.cornerRadius = 2;
    _doneButton.clipsToBounds = YES;
    
    _codeButton.layer.cornerRadius = 2;
    _codeButton.clipsToBounds = YES;
    
    NSArray *array = [_emailNum componentsSeparatedByString:@"@"];
    
    NSString *string = [NSString string];
    
    for (int i = 0; i < [array[0] length] - 2; i++) {
        
        string = [string stringByAppendingString:@"*"];
    }
    
    NSString *str = [_emailNum stringByReplacingCharactersInRange:NSMakeRange(1, [array[0] length] - 2) withString:string];
    
    _introduceLabel.text = [NSString stringWithFormat:@"您的邮箱 %@",str];
    
    [self getCode];
}

-(void)getCode{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Api/sendEmailCode_change"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            _second = 60;
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            
            self.codeButton.userInteractionEnabled = NO;
            
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"验证码发送失败~"];
    }];
}

-(void)timeFireMethod{
    
    if (_second == 0) {
        // 设置IDCountDownButton的title为开始倒计时前的title
        [self.codeButton setTitle:@"重新发送验证码" forState:UIControlStateNormal];
        
        // 恢复IDCountDownButton开始倒计时的能力
        _second = 60;
        
        self.codeButton.userInteractionEnabled = YES;
        
        [_timer invalidate];
        
    } else {
        
        _second --;
        
        self.codeButton.userInteractionEnabled = NO;
        
        // 设置IDCountDownButton的title为当前倒计时剩余的时间
        [self.codeButton setTitle:[NSString stringWithFormat:@"%d秒后可重新发送", _second] forState:UIControlStateNormal];
    }
    
    
}

- (void)dealloc {
    
    [_timer invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (IBAction)doneButtonClick:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/chargeMCodeByBinding"];
    
    if (self.codeField.text.length == 0) {
        
        self.codeField.text = @"";
    }
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"code":self.codeField.text,@"type":@"1"};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        //                        NSLog(@"%@",responseObject);
        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            for (UIViewController *view in self.navigationController.viewControllers) {
                
                if ([view isKindOfClass:[LDBindingEmailViewController class]]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"绑定邮箱" object:nil];
                    
                    [self.navigationController popToViewController:view animated:YES];
                }
            }
            
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (IBAction)codeButtonClick:(id)sender {
    
    [self getCode];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
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
