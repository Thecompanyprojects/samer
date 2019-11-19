//
//  LDGetChangeBindingPhoneNumCodeViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/24.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGetChangeBindingPhoneNumCodeViewController.h"
#import "LDBindingPhoneNumViewController.h"

@interface LDGetChangeBindingPhoneNumCodeViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

//发送验证码计时器
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic, assign) int second;

//图形验证码
@property (weak, nonatomic) IBOutlet UIView *picCodeView;
@property (weak, nonatomic) IBOutlet UITextField *picCodeField;
@property (weak, nonatomic) IBOutlet UIButton *picCodeButton;

//获取到cookie
@property (nonatomic, copy) NSString *cookieString;

@end

@implementation LDGetChangeBindingPhoneNumCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"验证原手机号";
    
    _codeView.layer.cornerRadius = 2;
    _codeView.clipsToBounds = YES;
    
    _doneButton.layer.cornerRadius = 2;
    _doneButton.clipsToBounds = YES;
    
    _codeButton.layer.cornerRadius = 2;
    _codeButton.clipsToBounds = YES;
    
    _picCodeView.layer.cornerRadius = 2;
    _picCodeView.clipsToBounds = YES;
    
    NSString *str = [_phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    _introduceLabel.text = [NSString stringWithFormat:@"您的手机 +86-%@",str];
    
    [self createPicCode];
    
}
- (IBAction)picCodeButtonClick:(id)sender {
    
    [self createPicCode];
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
//                NSDictionary *fields = [HTTPResponse allHeaderFields];// 原生NSURLConnection写法
//                NSLog(@"fields = %@", [fields description]);
        
        // 获取cookie方法2
        self->_cookieString = [[[HTTPResponse allHeaderFields] valueForKey:@"Set-Cookie"] componentsSeparatedByString:@";"][0];
        
        UIImage *image = [UIImage imageWithData:responseObject];
        
        [self.picCodeButton setBackgroundImage:image forState:UIControlStateNormal];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)getCode{
    
    if (self.picCodeField.text.length == 0) {
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请输入图形验证码!"];
        
    }else{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPSessionManager *manager = [LDAFManager sharedDataManager];
        
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager.requestSerializer setValue:_cookieString forHTTPHeaderField:@"Cookie"];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Api/sendVerCode_change"];
        
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"verify":self.picCodeField.text};
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *responseObjectDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSInteger integer = [[responseObjectDic objectForKey:@"retcode"] integerValue];
            
            if (integer != 2000) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObjectDic objectForKey:@"msg"]];
                
            }else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                self.second = 60;
                
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
                
                [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
                
                self.codeButton.userInteractionEnabled = NO;
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"验证码发送失败~"];
            
        }];
    }
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
}

- (IBAction)doneButtonClick:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/chargeMCodeByBinding"];
    
    if (self.codeField.text.length == 0) {
        
        self.codeField.text = @"";
    }
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"code":self.codeField.text,@"type":@"0"};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            for (UIViewController *view in self.navigationController.viewControllers) {
                
                if ([view isKindOfClass:[LDBindingPhoneNumViewController class]]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"绑定手机" object:nil];
                    
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
