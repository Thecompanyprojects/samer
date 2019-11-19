//
//  LDFindPasswordViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/15.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDFindPasswordViewController.h"

@interface LDFindPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic, assign) int second;

//图形验证码
@property (weak, nonatomic) IBOutlet UIView *picCodeView;
@property (weak, nonatomic) IBOutlet UITextField *picCodeField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picCodeButtonH;
@property (weak, nonatomic) IBOutlet UIButton *picCodeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picCodeViewH;
//去除cookie
@property (nonatomic, copy) NSString *cookieString;
@end

@implementation LDFindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"密码找回";
    
    self.phoneView.layer.cornerRadius = 25;
    self.phoneView.clipsToBounds = YES;
    self.phoneView.layer.borderWidth = 1;
    self.phoneView.layer.borderColor = [UIColor colorWithHexString:@"B7B7B7" alpha:1].CGColor;
    self.phoneView.backgroundColor = [UIColor whiteColor];
    
    self.codeView.layer.cornerRadius = 25;
    self.codeView.clipsToBounds = YES;
    self.codeView.layer.borderWidth = 1;
    self.codeView.layer.borderColor = [UIColor colorWithHexString:@"B7B7B7" alpha:1].CGColor;
    self.codeView.backgroundColor = [UIColor whiteColor];
    
    self.picCodeView.layer.cornerRadius = 25;
    self.picCodeView.clipsToBounds = YES;
    self.picCodeView.layer.borderWidth = 1;
    self.picCodeView.layer.borderColor = [UIColor colorWithHexString:@"B7B7B7" alpha:1].CGColor;
    self.picCodeView.backgroundColor = [UIColor whiteColor];
    
    self.passwordView.layer.cornerRadius = 25;
    self.passwordView.clipsToBounds = YES;
    self.passwordView.layer.borderWidth = 1;
    self.passwordView.layer.borderColor = [UIColor colorWithHexString:@"B7B7B7" alpha:1].CGColor;
    self.passwordView.backgroundColor = [UIColor whiteColor];
    
    self.sureButton.layer.cornerRadius = 25;
    self.sureButton.clipsToBounds = YES;
    
    self.codeButton.layer.cornerRadius = 25;
    self.codeButton.clipsToBounds = YES;
    [self createButton];
    [self createPicCode];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

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

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

}

-(void)createPicCode{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/verify"];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:[NSURL URLWithString:url]];

    for (NSHTTPCookie *tempCookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:tempCookie];
    }
    
    //1.创建会话管理者
    AFHTTPSessionManager *getManager = [AFHTTPSessionManager manager];
    //3种解析方式:JSON & XML &http(不做任何处理)
    getManager.responseSerializer = [AFHTTPResponseSerializer serializer];//用XML解析数据
    //2.发请求
    [getManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 获取所有数据报头信息
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
        //        NSDictionary *fields = [HTTPResponse allHeaderFields];// 原生NSURLConnection写法
        //        NSLog(@"fields = %@", [fields description]);
        
        // 获取cookie方法2
        _cookieString = [[[HTTPResponse allHeaderFields] valueForKey:@"Set-Cookie"] componentsSeparatedByString:@";"][0];
        
        UIImage *image = [UIImage imageWithData:responseObject];
        
        [self.picCodeButton setBackgroundImage:image forState:UIControlStateNormal];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (IBAction)picCodeButtonClick:(id)sender {
    
    [self createPicCode];
}


-(void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    [self status];
}

- (IBAction)codeButtonClick:(id)sender {
    
     [self.view endEditing:YES];
    
    if (self.phoneField.text.length != 0) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPSessionManager *manager;
        
        NSString *url;
        
        NSDictionary *parameters;
        
        if([self.phoneField.text rangeOfString:@"@"].location !=NSNotFound)//_roaldSearchText
        {
            manager = [LDAFManager sharedManager];
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Api/sendMailCode_forget"];
            
            parameters = @{@"email":self.phoneField.text};
            
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
                //                NSLog(@"%@",responseObject);
                if (integer != 2000) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                    
                }else{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    _second = 60;
                    
                    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
                    
                    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
                    
                    self.codeButton.userInteractionEnabled = NO;
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }];
        }
        else
        {
            
            if (self.picCodeField.text.length == 0) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请输入图形验证码!"];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }else{
                
                manager = [LDAFManager sharedDataManager];
                
                [manager.requestSerializer setValue:_cookieString forHTTPHeaderField:@"Cookie"];
                
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Api/sendVerCode_forget"];
                
                parameters = @{@"mobile":self.phoneField.text,@"verify":self.picCodeField.text};
                
                [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSDictionary *responseObjectDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                    
                    NSInteger integer = [[responseObjectDic objectForKey:@"retcode"] integerValue];
                    //                NSLog(@"%@",responseObject);
                    if (integer != 2000) {
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObjectDic objectForKey:@"msg"]];
                        
                    }else{
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                        _second = 60;
                        
                        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
                        
                        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
                        
                        self.codeButton.userInteractionEnabled = NO;
                    }
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                }];
            }  
        }

    }else{
    
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请输入手机号码或邮箱~"];
        
    }
}
- (IBAction)sureButtonClick:(id)sender {
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/forgotPassword"];
    
    NSDictionary *parameters = @{@"mobile":self.phoneField.text,@"password":self.passwordField.text,@"code":self.codeField.text};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        //                NSLog(@"%@",responseObject);
        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"修改失败,请稍后重试~"];

    }];
}

-(void)timeFireMethod{
    
    if (_second == 0) {
        // 设置IDCountDownButton的title为开始倒计时前的title
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        
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

//textField代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

-(void)status{
    
    if (self.phoneField.text.length != 0 && self.codeField.text.length != 0 &&self.passwordField.text.length != 0 && self.picCodeField.text.length != 0 ) {
        
        self.sureButton.userInteractionEnabled = YES;
    }else{

        self.sureButton.userInteractionEnabled = NO;
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
