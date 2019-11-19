//
//  switchVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/5.
//  Copyright © 2019 a. All rights reserved.
//

#import "switchVC.h"
#import "LDLoginViewController.h"
#import "LDswitchModel.h"
#import "LDswitchManager.h"
#import "switchaccountCell.h"
#import "addaccountVC.h"
#import "LDMainTabViewController.h"


@interface switchVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) NSMutableArray *changeArray;
@end

static NSString *switchaccountidedfity = @"switchaccountidedfity";

@implementation switchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"切换账号";

    [self createdata];
    [self createTableView];
  
    self.table.tableHeaderView = self.headView;
}

-(void)createdata
{
    self.dataSource = [NSMutableArray new];
    self.changeArray = [NSMutableArray new];
    self.dataSource = [[LDswitchManager sharedClient] loaddata];
    for (int i = 0; i<self.dataSource.count; i++) {
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        NSString *str = @"0";
        LDswitchModel *model = [self.dataSource objectAtIndex:i];
        if ([uid isEqualToString:model.uid]) {
            str = @"1";
        }
        [self.changeArray addObject:str];
    }
    [self.table reloadData];
}

-(void)createTableView{
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStyleGrouped];
    self.table.delegate = self;
    self.table.dataSource = self;
    if (@available(iOS 11.0, *)) {
        _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.table.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.table];
}

-(UIView *)headView
{
    if(!_headView)
    {
        _headView = [[UIView alloc] init];
        _headView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5" alpha:1];
        _headView.frame = CGRectMake(0, 0, WIDTH, 40);
        UILabel *lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(0, 0, WIDTH, 40);
        lab.textColor = TextCOLOR;
        lab.font = [UIFont systemFontOfSize:13];
        lab.text = @"    选择你要登录的账号";
        
        [_headView addSubview:lab];
    }
    return _headView;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataSource.count>=5) {
        return 1;
    }
    else
    {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.dataSource.count?:0;
    }
    if (section==1) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        switchaccountCell *cell = [tableView dequeueReusableCellWithIdentifier:switchaccountidedfity];
        cell = [[switchaccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:switchaccountidedfity];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataSource[indexPath.row];
        NSString *str = self.changeArray[indexPath.row];
        if ([str isEqualToString:@"1"]) {
            [cell.changeImg setHidden:NO];
        }
        else
        {
            [cell.changeImg setHidden:YES];
        }
        return cell;
    }
    if (indexPath.section==1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"添加新账号";
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = TextCOLOR;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        LDswitchModel *ldmodel = self.dataSource[indexPath.row];
        NSString *str = self.changeArray[indexPath.row];
        if (![str isEqualToString:@"1"]) {
            if ([ldmodel.way intValue]==0) {
                [self submitbtnclickwith:ldmodel];
            }
            else
            {
                [self newsubmitbtnclickwith:ldmodel];
            }
        }
        else
        {
            
        }
    }
    if (indexPath.section==1) {
        addaccountVC *vc = [addaccountVC new];
        vc.returnValueBlock = ^{
            [self createdata];
            [[LDswitchManager sharedClient] getVipStatusData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 66;
    }
    else
    {
        return 50;
    }
    return 66;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

#pragma mark - 切换账号

-(void)submitbtnclickwith:(LDswitchModel *)model
{
    NSDictionary *basicDic = @{@"user_name":model.account,@"password":model.password};
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
    
    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSDictionary *responseDic = [NSObject parseJSONStringToNSDictionary:result];
            
            if ([responseDic[@"retcode"] intValue] == 2000) {
                
                //存储用户的登录的账号
                [[NSUserDefaults standardUserDefaults] setObject:model.account forKey:@"accountNumber"];
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
                 [SuspensionAssistiveTouch defaultTool].roomidStr = roomidStr.copy;
                [[SuspensionAssistiveTouch defaultTool] backbtnClick];
                [self createdata];
                [[LDswitchManager sharedClient] getVipStatusData];
            }else{
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseDic objectForKey:@"msg"]];
            }
            
        });
    }];
}

-(void)newsubmitbtnclickwith:(LDswitchModel *)model
{
    NSString *url = [PICHEADURL stringByAppendingString:login_thirdUrl];
    NSString *uid = model.uid;
    NSString *device;
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.aiwujie.shengmoApp"];
    if ([keychain[@"device_token"] length] == 0) {
        
        device = @"";
        
    }else{
        
        device = keychain[@"device_token"];
    }
    NSDictionary *params = @{@"uid":uid,@"device_token":device};
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
        
        if ([responseObj[@"retcode"] intValue] == 2000) {
            
//            //存储用户的登录的账号
//            [[NSUserDefaults standardUserDefaults] setObject:model.account forKey:@"accountNumber"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObj[@"data"][@"sex"] forKey:@"newestSex"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObj[@"data"][@"sexual"] forKey:@"newestSexual"];
            
            if ([responseObj[@"data"][@"uid"] intValue] == 11 || [responseObj[@"data"][@"uid"] intValue] == 14514 || [responseObj[@"data"][@"uid"] intValue] == 14518)
            {

                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchSwitch"];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sexButton"];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sexualButton"];

                //根据我的性取向展示感兴趣的动态
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"动态筛选"];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"dynamicSex"];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"dynamicSexual"];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"uid"]] forKey:@"uid"];
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObj[@"data"][@"r_token"] forKey:@"token"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"chatstatus"]] forKey:@"ableOrDisable"];
            
            LDMainTabViewController *mvc = [[LDMainTabViewController alloc] initWithNibName:@"LDMainTabViewController" bundle:nil];
    
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
            
            [self createdata];
            [[LDswitchManager sharedClient] getVipStatusData];
            
        }
        else
        {
            NSString *msg = [responseObj objectForKey:@"msg"];
            [AlertTool alertqute:self andTitle:@"提示" andMessage:msg];
        }
                    
    } failed:^(NSString *errorMsg) {
        
    }];

}

//滑动删除执行的代理方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击左滑出现的Delete按钮执行的操作");
    LDswitchModel *model = self.dataSource[indexPath.row];
    NSString *newUid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if ([model.uid isEqualToString:newUid]) {
        //不能删除
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"不能删除当前登录账号"];
    }
    else
    {
        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除账号吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[LDswitchManager sharedClient] deletefromuid:model.uid];
            [self.dataSource  removeObjectAtIndex:indexPath.row];
            [self.changeArray removeObjectAtIndex:indexPath.row];
            [self.table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }];
        [control addAction:action0];
        [control addAction:action1];
        [self presentViewController:control animated:YES completion:^{
            
        }];
    }
}

//修改默认Delete按钮的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

@end
