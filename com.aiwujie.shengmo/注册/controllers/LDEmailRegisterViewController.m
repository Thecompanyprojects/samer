//
//  LDEmailRegisterViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/15.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDEmailRegisterViewController.h"
#import "LDProtocolViewController.h"
#import "LDResigerNextViewController.h"

@interface LDEmailRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *circleButton;
@property (weak, nonatomic) IBOutlet UIButton *protocolButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (nonatomic,assign) BOOL isAgree;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

//发送验证码计时器
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic, assign) int second;

@end

@implementation LDEmailRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"邮箱注册";
    
    _isAgree = NO;
    
    self.phoneView.layer.cornerRadius = 25;
    self.phoneView.clipsToBounds = YES;
    self.phoneView.backgroundColor = [UIColor whiteColor];
    self.phoneView.layer.borderColor = [UIColor colorWithHexString:@"B7B7B7" alpha:1].CGColor;
    self.phoneView.layer.borderWidth = 1;
    
    
    self.passwordView.layer.cornerRadius = 25;
    self.passwordView.clipsToBounds = YES;
    self.passwordView.backgroundColor = [UIColor whiteColor];
    self.passwordView.layer.borderColor = [UIColor colorWithHexString:@"B7B7B7" alpha:1].CGColor;
    self.passwordView.layer.borderWidth = 1;
    
    self.registerButton.layer.cornerRadius = 25;
    self.registerButton.clipsToBounds = YES;
    self.registerButton.layer.borderColor = [UIColor colorWithHexString:@"B7B7B7" alpha:1].CGColor;
    self.registerButton.layer.borderWidth = 1;
    
    self.codeButton.layer.cornerRadius = 25;
    self.codeButton.clipsToBounds = YES;
    self.codeButton.layer.borderColor = [UIColor colorWithHexString:@"B7B7B7" alpha:1].CGColor;
    self.codeButton.layer.borderWidth = 1;
    
    self.codeView.layer.cornerRadius = 25;
    self.codeView.clipsToBounds = YES;
    self.codeView.backgroundColor = [UIColor whiteColor];
    self.codeView.layer.borderColor = [UIColor colorWithHexString:@"B7B7B7" alpha:1].CGColor;
    self.codeView.layer.borderWidth = 1;
    
    [self createButton];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    self.isAgree = YES;
    [self.circleButton setBackgroundImage:[UIImage imageNamed:@"shiguanzhu"] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHandle:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardHandle:(NSNotification *)notify{

    [self status];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self vhl_setNavBarShadowImageHidden:YES];
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self status];
}

- (IBAction)circleButtonClick:(id)sender {
    
    if (_isAgree) {
        
        _isAgree = NO;
        [self.circleButton setBackgroundImage:[UIImage imageNamed:@"kongguanzhu"] forState:UIControlStateNormal];
        [self.view endEditing:YES];
        [self status];

    }else{
        
        _isAgree = YES;
        [self.circleButton setBackgroundImage:[UIImage imageNamed:@"shiguanzhu"] forState:UIControlStateNormal];
        [self.view endEditing:YES];
        [self status];
    }
}

- (IBAction)codeButtonClick:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,sendMailCode_regUrl];
    
    NSDictionary *parameters = @{@"email":_phoneField.text};
    
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
        [self.codeButton setTitle:@"点击获取验证码" forState:UIControlStateNormal];
        
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
}

//协议查看
- (IBAction)protocolButtonClick:(id)sender {
    [self.view endEditing:YES];
    LDProtocolViewController *pvc = [[LDProtocolViewController alloc] init];
    [self.navigationController pushViewController:pvc animated:YES];
}


//注册按钮
- (IBAction)registerButtonClick:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/users/chargeFristnew"];

    NSString *device;

    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.aiwujie.shengmoApp"];

    if ([keychain[@"device_token"] length] == 0) {

        device = @"";

    }else{

        device = keychain[@"device_token"];
    }

    NSDictionary *parameters = @{@"email":self.phoneField.text,@"password":self.passwordField.text,@"code":self.codeField.text,@"device_token":device};

    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];

        if (integer != 2000) {

            [MBProgressHUD hideHUDForView:self.view animated:YES];

            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];

        }else{

            [MBProgressHUD hideHUDForView:self.view animated:YES];

            LDResigerNextViewController *ivc = [[LDResigerNextViewController alloc] init];

            NSDictionary* dict = @{
                                   @"email" :self.phoneField.text,
                                   @"password": self.passwordField.text,
                                   @"code":self.codeField.text
                                   };

            ivc.basicDic = dict;

            [self.navigationController pushViewController:ivc animated:YES];
        }

    } failed:^(NSString *errorMsg) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请求超时,请稍后重试~"];
    }];

}

//textField代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


-(void)status{
    
    if (self.phoneField.text.length != 0 &&self.passwordField.text.length != 0 && _isAgree == YES && self.codeField.text.length != 0) {
        self.registerButton.userInteractionEnabled = YES;

    }else{
        self.registerButton.userInteractionEnabled = NO;
    }
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
