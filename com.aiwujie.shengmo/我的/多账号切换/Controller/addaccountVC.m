//
//  addaccountVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/5.
//  Copyright © 2019 a. All rights reserved.
//

#import "addaccountVC.h"
#import "addView.h"
#import "LDswitchModel.h"
#import "LDswitchManager.h"
#import "LDMainTabViewController.h"
#import "LDResigerNextViewController.h"
#import "AppDelegate.h"

@interface addaccountVC ()<TencentSessionDelegate>
{
    TencentOAuth *_tencentOAuth;
}
@property (nonatomic,strong) addView *accountView;
@property (nonatomic,strong) addView *passwordView;
@property (nonatomic,strong) UIButton *submitBtn;
@property (nonatomic,strong) UILabel *messageLab;
@property (nonatomic,strong) UIButton *qqBtn;
@property (nonatomic,strong) UIButton *wxBtn;
@property (nonatomic,strong) UIButton *wbBtn;

@property (nonatomic,strong) UILabel *lab;
@property (nonatomic,strong) UIView *leftLine;
@property (nonatomic,strong) UIView *rightLine;

@end

@implementation addaccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5" alpha:1];
    self.title = @"添加新账号";
    [self.view addSubview:self.messageLab];
    [self.view addSubview:self.accountView];
    [self.view addSubview:self.passwordView];
    [self.view addSubview:self.submitBtn];
    [self.view addSubview:self.qqBtn];
    [self.view addSubview:self.wxBtn];
    [self.view addSubview:self.wbBtn];
    [self.view addSubview:self.lab];
    [self.view addSubview:self.leftLine];
    [self.view addSubview:self.rightLine];
    [self setuplayout];
    [self isshowbuttons];
}

/// 判断是否展示第三方登录
-(void)isshowbuttons
{
    [self.qqBtn setHidden:YES];
    [self.wxBtn setHidden:YES];
    [self.wbBtn setHidden:YES];
    [self.lab setHidden:YES];
    [self.leftLine setHidden:YES];
    [self.rightLine setHidden:YES];
    NSString *url = [PICHEADURL stringByAppendingFormat:@"api/power/thirdParty"];
    [NetManager afPostRequest:url parms:nil finished:^(id responseObj) {
        
        NSDictionary *dict = [responseObj objectForKey:@"data"];
        NSString *state = [NSString stringWithFormat:@"%@",[dict objectForKey:@"state"]];
        if ([state intValue]==1) {
            [self.qqBtn setHidden:NO];
            [self.wxBtn setHidden:NO];
            [self.wbBtn setHidden:NO];
            [self.lab setHidden:NO];
            [self.leftLine setHidden:NO];
            [self.rightLine setHidden:NO];
        }
        else
        {
            [self.qqBtn setHidden:YES];
            [self.wxBtn setHidden:YES];
            [self.wbBtn setHidden:YES];
            [self.lab setHidden:YES];
            [self.leftLine setHidden:YES];
            [self.rightLine setHidden:YES];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).with.offset(10);
        make.height.mas_offset(18);
    }];
    
    [weakSelf.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).with.offset(40);
        make.height.mas_offset(50);
    }];
    
    [weakSelf.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.accountView.mas_bottom).with.offset(10);
        make.height.mas_offset(50);
    }];
    
    [weakSelf.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.passwordView.mas_bottom).with.offset(28);
        make.left.equalTo(weakSelf.view).with.offset(20);
        make.right.equalTo(weakSelf.view).with.offset(-20);
        make.height.mas_offset(40);
    }];
    
    [weakSelf.wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.submitBtn.mas_bottom).with.offset(80);
        make.width.mas_offset(60);
        make.height.mas_offset(60);
    }];
    
    [weakSelf.qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).with.offset(40);
        make.top.equalTo(weakSelf.wxBtn);
        make.width.mas_offset(60);
        make.height.mas_offset(60);
    }];
    
    [weakSelf.wbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).with.offset(-40);
        make.top.equalTo(weakSelf.wxBtn);
        make.width.mas_offset(60);
        make.height.mas_offset(60);
    }];
    
    [weakSelf.lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.width.mas_offset(80);
        make.height.mas_offset(14);
        make.top.equalTo(weakSelf.submitBtn.mas_bottom).with.offset(40);
    }];
    [weakSelf.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.lab.mas_left).with.offset(-5);
        make.centerY.equalTo(weakSelf.lab);
        make.left.equalTo(weakSelf.view).with.offset(50);
        make.height.mas_offset(1);
    }];
    [weakSelf.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lab.mas_right).with.offset(5);
        make.centerY.equalTo(weakSelf.lab);
        make.right.equalTo(weakSelf.view).with.offset(-50);
        make.height.mas_offset(1);
    }];
}

#pragma mark - getters

-(UILabel *)messageLab
{
    if(!_messageLab)
    {
        _messageLab = [[UILabel alloc] init];
        _messageLab.textColor = TextCOLOR;
        _messageLab.font = [UIFont systemFontOfSize:13];
        _messageLab.text = @"    最多只能添加5个账号";
    }
    return _messageLab;
}

-(addView *)accountView
{
    if(!_accountView)
    {
        _accountView = [[addView alloc] init];
        _accountView.leftLab.text = @"账号";
        _accountView.addText.placeholder = @"手机号或邮箱";
        
    }
    return _accountView;
}

-(addView *)passwordView
{
    if(!_passwordView)
    {
        _passwordView = [[addView alloc] init];
        _passwordView.leftLab.text = @"密码";
        _passwordView.addText.placeholder = @"请输入密码";
        _passwordView.addText.secureTextEntry = YES;
    }
    return _passwordView;
}

-(UIButton *)qqBtn
{
    if(!_qqBtn)
    {
        _qqBtn = [[UIButton alloc] init];
        [_qqBtn setImage:[UIImage imageNamed:@"qq"] forState:normal];
        [_qqBtn addTarget:self action:@selector(qqbtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qqBtn;
}

-(UIButton *)wxBtn
{
    if(!_wxBtn)
    {
        _wxBtn = [[UIButton alloc] init];
        [_wxBtn setImage:[UIImage imageNamed:@"weixin"] forState:normal];
        [_wxBtn addTarget:self action:@selector(wxbtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wxBtn;
}

-(UIButton *)wbBtn
{
    if(!_wbBtn)
    {
        _wbBtn = [[UIButton alloc] init];
        [_wbBtn setImage:[UIImage imageNamed:@"weibo"] forState:normal];
        [_wbBtn addTarget:self action:@selector(wbbtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wbBtn;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:@"登  录" forState:normal];
        _submitBtn.backgroundColor = MainColor;
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:normal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _submitBtn.layer.cornerRadius = 8;
        [_submitBtn addTarget:self action:@selector(submitbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

-(UILabel *)lab
{
    if(!_lab)
    {
        _lab = [UILabel new];
        _lab.textColor = [UIColor colorWithHexString:@"B7B7B7" alpha:1];
        _lab.font = [UIFont systemFontOfSize:12];
        _lab.textAlignment = NSTextAlignmentCenter;
        _lab.text = @"添加快捷登录";
    }
    return _lab;
}

-(UIView *)leftLine
{
    if(!_leftLine)
    {
        _leftLine = [[UIView alloc] init];
        _leftLine.backgroundColor = [UIColor colorWithHexString:@"B7B7B7" alpha:1];
    }
    return _leftLine;
}

-(UIView *)rightLine
{
    if(!_rightLine)
    {
        _rightLine = [[UIView alloc] init];
        _rightLine.backgroundColor = [UIColor colorWithHexString:@"B7B7B7" alpha:1];
    }
    return _rightLine;
}

#pragma mark - 切换账号

-(void)submitbtnclick
{
    
    NSDictionary *basicDic = @{@"user_name":self.accountView.addText.text,@"password":self.passwordView.addText.text};
    NSString *lat;
    NSString *lng;
    NSString *city;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:latitude] length] == 0) {
        
        lat = @"";
        
    }else{
        
        lat = [[NSUserDefaults standardUserDefaults] objectForKey:latitude];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:longitude] length] == 0) {
        
        lng = @"";
        
    }else{
        
        lng = [[NSUserDefaults standardUserDefaults] objectForKey:longitude];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"city"] length] == 0) {
        
        city = @"";
        
    }else{
        
        city = [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
    }
    
    NSDictionary *locationDic = @{@"lat":lat,@"lng":lng,@"city":city};
    
    NSString *device;
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.aiwujie.shengmoApp"];
    
    if ([keychain[@"device_token"] length] == 0) {
        
        device = @"";
        
    }else{
        
        device = keychain[@"device_token"];
    }
    
    NSDictionary *deviceDic = @{@"device_token":device};
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/login_pw"]];
    
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
    
    NSDictionary *d = @{@"basic":basicDic,@"location":locationDic,@"device_info":deviceDic};
    
    NSData* da = [NSJSONSerialization dataWithJSONObject:d options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *bodyData = [[NSString alloc] initWithData:da encoding:NSUTF8StringEncoding];
    
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    
    [postRequest setHTTPMethod:@"POST"];
    
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [MBProgressHUD showActivityMessage:@"登录中..."];
    
    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [MBProgressHUD hideHUD];
            
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSDictionary *responseDic = [NSObject parseJSONStringToNSDictionary:result];
            
            if ([responseDic[@"retcode"] intValue] == 2000) {

                //存储用户的登录的账号
                [[NSUserDefaults standardUserDefaults] setObject:self.accountView.addText.text forKey:@"accountNumber"];
                [[NSUserDefaults standardUserDefaults] setObject:responseDic[@"data"][@"sex"] forKey:@"newestSex"];
                [[NSUserDefaults standardUserDefaults] setObject:responseDic[@"data"][@"sexual"] forKey:@"newestSexual"];
                if ([responseDic[@"data"][@"uid"] intValue] == 11 || [responseDic[@"data"][@"uid"] intValue] == 14514 || [responseDic[@"data"][@"uid"] intValue] == 14518)
                {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchSwitch"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sexButton"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sexualButton"];
                    
                    //根据我的性取向展示感兴趣的动态
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"动态筛选"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"dynamicSex"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"dynamicSexual"];
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseDic[@"data"][@"uid"]] forKey:@"uid"];
                [[NSUserDefaults standardUserDefaults] setObject:responseDic[@"data"][@"r_token"] forKey:@"token"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseDic[@"data"][@"chatstatus"]] forKey:@"ableOrDisable"];
                
                if ([[LDswitchManager sharedClient]iscaninsert]) {
                    LDswitchModel *model = [LDswitchModel new];
                    model.account = self.accountView.addText.text;
                    model.password = self.passwordView.addText.text;
                    model.uid = responseDic[@"data"][@"uid"];
                    model.nickname = responseDic[@"data"][@"nickname"];
                    model.imageUrl = responseDic[@"data"][@"match_photo"];
                    model.token = responseDic[@"data"][@"r_token"];
                    model.sexual = [NSString stringWithFormat:@"%@",responseDic[@"data"][@"sexual"]];
                    model.sex = [NSString stringWithFormat:@"%@",responseDic[@"data"][@"sex"]];
                    model.chatstatus = responseDic[@"data"][@"chatstatus"];
                    model.way = @"0";
                    [[LDswitchManager sharedClient] insertInfowith:model];
                }
                [SuspensionAssistiveTouch defaultTool].roomidStr = roomidStr.copy;
                [[SuspensionAssistiveTouch defaultTool] backbtnClick];
                LDMainTabViewController *mvc = [[LDMainTabViewController alloc] initWithNibName:@"LDMainTabViewController" bundle:nil];
                
                /**
                 融云聊天集成
                 */
                [[RCIM sharedRCIM] connectWithToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] success:^(NSString *userId) {
                    
                    NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                    //[self createData:userId];
                    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UITabBarItem * item=[mvc.tabBar.items objectAtIndex:2];
                        
                        NSInteger badge = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
                        
                        if (badge <= 0) {
                            
                            item.badgeValue = 0;
                            
                        }else{
                            
                            item.badgeValue = [NSString stringWithFormat:@"%ld",(long)badge];
                        }
                        
                       
                        if (self.returnValueBlock) {
                            self.returnValueBlock();
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    });
                    
                } error:^(RCConnectErrorCode status) {
                    
                    NSLog(@"登陆的错误码为:%ld", (long)status);
                    
                } tokenIncorrect:^{
                    
                    NSLog(@"token错误");
                }];
                
            }else{
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseDic objectForKey:@"msg"]];
            }
            
        });
    }];
}

#pragma mark - 第三方

-(void)qqbtnClick
{
    _tencentOAuth =
    [[TencentOAuth alloc] initWithAppId:@"1109831381" andDelegate:self];
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_GET_INFO,kOPEN_PERMISSION_ADD_SHARE , nil];
    _tencentOAuth.sessionDelegate = self;
    [_tencentOAuth authorize:permissions inSafari:NO];
}

-(void)wxbtnClick
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123WX" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

-(void)wbbtnClick
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}


- (void)tencentDidLogin {
    
    if ([_tencentOAuth getUserInfo]) {
        [[NSUserDefaults standardUserDefaults] setObject:[_tencentOAuth getUserOpenID] forKey:@"openid"];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"message:@"获取个人信息失败" delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil)otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
    if (cancelled == YES) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消授权" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"授权失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    }
}
//
- (void)tencentDidNotNetWork {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误,授权失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
}
//qq登录回调
-(void)getUserInfoResponse:(APIResponse *)response
{
    [[NSUserDefaults standardUserDefaults] setObject:response.jsonResponse forKey:@"response"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,charge_openidUrl];
    
    NSString *device;
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.aiwujie.shengmoApp"];
    
    if ([keychain[@"device_token"] length] == 0) {
        
        device = @"";
        
    }else{
        
        device = keychain[@"device_token"];
    }

    NSString *new_device_brand = [[LDFromwebManager defaultTool] getCurrentDeviceModel];
    
    NSString *new_device_version = [[UIDevice currentDevice] systemVersion];
    
    NSString *new_device_appversion = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
   
    NSString *access_token = _tencentOAuth.accessToken;
    NSString *newurl = [NSString stringWithFormat:@"%@%@%@",@"https://graph.qq.com/oauth2.0/me?access_token=",access_token,@"&unionid=1"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript" ,@"text/plain",@"text/html" , nil];
    [manager GET:newurl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
        NSString *resultString  =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *str2 = [resultString substringFromIndex:9];
        NSString *str1 = [str2 substringToIndex:str2.length-3];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str1 dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        NSString *unionid = [dic objectForKey:@"unionid"];
        NSLog(@"unic-----%@",unionid);
        
        
        NSDictionary *parameters = @{@"openid":[_tencentOAuth getUserOpenID],@"channel":@"2",@"device_token":device,@"new_device_brand":new_device_brand?:@"",@"new_device_version":new_device_version?:@"",@"new_device_appversion":new_device_appversion?:@"",@"unionid":unionid?:@""};
          
        
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
               
               NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
               
               if (integer == 4000) {
                   
                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                   
                   LDResigerNextViewController *nvc = [[LDResigerNextViewController alloc] init];
                   
                   nvc.loginState = @"qq";
                   
                   [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"channel"]] forKey:@"loginChannel"];
                   
                   [self.navigationController pushViewController:nvc animated:YES];
                   
               }else if(integer == 2000){
                   
                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                   
                   [[NSUserDefaults standardUserDefaults] setObject:responseObj[@"data"][@"sex"] forKey:@"newestSex"];
                   
                   [[NSUserDefaults standardUserDefaults] setObject:responseObj[@"data"][@"sexual"] forKey:@"newestSexual"];
                   
                   [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"uid"]] forKey:@"uid"];
                   
                   [[NSUserDefaults standardUserDefaults] setObject:responseObj[@"data"][@"r_token"] forKey:@"token"];
                   
                   [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"chatstatus"]] forKey:@"ableOrDisable"];

                   if ([[LDswitchManager sharedClient] iscaninsert]) {
                       LDswitchModel *model = [LDswitchModel new];
                       model.account = @"";
                       model.password = @"";
                       model.uid = responseObj[@"data"][@"uid"];
                       model.nickname = responseObj[@"data"][@"nickname"];
                       model.imageUrl = responseObj[@"data"][@"head_pic"];
                       model.token = responseObj[@"data"][@"r_token"];
                       model.sexual = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"sexual"]];
                       model.sex = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"sex"]];
                       model.chatstatus = responseObj[@"data"][@"chatstatus"];
                       model.way = @"1";
                       [[LDswitchManager sharedClient] insertInfowith:model];
                   }
                   
                   LDMainTabViewController *mvc = [[LDMainTabViewController alloc] initWithNibName:@"LDMainTabViewController" bundle:nil];
                   
                   /**
                    
                    融云聊天集成
                    
                    */
                   [[RCIM sharedRCIM] connectWithToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] success:^(NSString *userId) {
                       
                       NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                       
                       [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           
                           UITabBarItem * item=[mvc.tabBar.items objectAtIndex:2];
                           NSInteger badge = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
                           if (badge <= 0) {
                               
                               item.badgeValue = 0;
                               
                           }else{
                               
                               item.badgeValue = [NSString stringWithFormat:@"%ld",(long)badge];
                           }
                       });
                       
                   } error:^(RCConnectErrorCode status) {
                       NSLog(@"登陆的错误码为:%ld", (long)status);
                   } tokenIncorrect:^{
                       //token过期或者不正确。
                       //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                       //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                       NSLog(@"token错误");
                   }];
                   
                   AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                   app.window.rootViewController = mvc;
               }else{
                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                   [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
               }
           } failed:^(NSString *errorMsg) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
           }];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

@end
