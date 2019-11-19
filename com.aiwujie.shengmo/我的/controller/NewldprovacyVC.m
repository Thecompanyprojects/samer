//
//  NewldprovacyVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/10.
//  Copyright © 2019 a. All rights reserved.
//

#import "NewldprovacyVC.h"
#import "LDProvacyCell0.h"
#import "LDProvacyCell1.h"
#import "LDPrivacyPhotoViewController.h"
#import "LDBlackListViewController.h"
#import "LDpermissionsVC.h"

@interface NewldprovacyVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,assign) BOOL isFocuson;// 允许关注
@property (nonatomic,assign) BOOL isShowgroup;//允许查看群组
@property (nonatomic,assign) BOOL location_switch; //允许定位
@property (nonatomic,assign) BOOL isLogintime;//登录时间
@property (nonatomic,assign) BOOL isshowPhoto;//是否开放相册
@property (nonatomic,assign) BOOL isshowalbum; //相册查看权限  true-好友/会员可见 false-所有人可见
@property (nonatomic,assign) BOOL isshowdynamic;// 主页动态查看 true-好友/会员可见 false-所有人可见
@property (nonatomic,assign) BOOL isshowcomments;// 主页评论查看 true-好友/会员可见 false-所有人可见
@property (nonatomic,assign) BOOL isshowName;//nickname_rule  true--SVIP可见 0   false-仅仅自己可见 1

@property (nonatomic,assign) BOOL location_city_switch;//城市位置 true -打开 false - 关闭

@property (nonatomic,copy) NSString *blackNumStr;

@property (nonatomic,assign) BOOL isallstealth; //  YES 全隐身  NO  不是全隐身
@end

static NSString *ldprovacyidentfity0 = @"ldprovacyidentfity0";
static NSString *ldprovacyidentfity1 = @"ldprovacyidentfity1";
static NSString *ldprovacyidentfity2 = @"ldprovacyidentfity2";
static NSString *ldprovacyidentfity3 = @"ldprovacyidentfity3";
static NSString *ldprovacyidentfity4 = @"ldprovacyidentfity4";
static NSString *ldprovacyidentfity5 = @"ldprovacyidentfity5";
static NSString *ldprovacyidentfity6 = @"ldprovacyidentfity6";
static NSString *ldprovacyidentfity7 = @"ldprovacyidentfity7";
static NSString *ldprovacyidentfity8 = @"ldprovacyidentfity8";
static NSString *ldprovacyidentfity9 = @"ldprovacyidentfity9";
static NSString *ldprovacyidentfity10 = @"ldprovacyidentfity10";

@implementation NewldprovacyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"隐私";
    [self.view addSubview:self.table];
    [self createStatusData];
   // [self quanyinshen];
}

-(void)quanyinshen
{
    self.isallstealth = NO;
    NSString *url = [PICHEADURL stringByAppendingString:hideStateSwitchUrl];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSDictionary *para = @{@"uid":uid};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSDictionary *data = [responseObj objectForKey:@"data"];
            NSString *code = [data objectForKey:@"code"];
            if ([code intValue]==1) {
                self.isallstealth = YES;
            }
            else
            {
                self.isallstealth = NO;
            }
        }
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self afterstaticData];
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
        NSLog(@"页面pop成功了");
        [self backButtonOnClick];
    }
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStyleGrouped];
        _table.dataSource = self;
        _table.delegate = self;
        _table.tableFooterView = [UIView new];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _table;
}

#pragma mark - getData

-(void)createStatusData{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getSecretSitUrl];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
        }
        else
        {
            if ([responseObj[@"data"][@"follow_list_switch"] intValue] == 0)
            {
                self.isFocuson = YES;
                
            }
            else
            {
                self.isFocuson = NO;
                
            }
            if ([responseObj[@"data"][@"group_list_switch"] intValue] == 0) {
                self.isShowgroup = YES;
            }else{
                
                self.isShowgroup = NO;
            }
            
            if ([responseObj[@"data"][@"login_time_switch"] intValue] == 0) {
                self.isLogintime = YES;
            }else{
                self.isLogintime = NO;
            }
            
            if ([responseObj[@"data"][@"photo_lock"] intValue] == 1) {
                
                self.isshowPhoto = YES;
            }else{
                
                self.isshowPhoto = NO;
            }
            
            //相册查看权限 0 所有人可见 1 好友/会员可见
            if ([responseObj[@"data"][@"photo_rule"] intValue] == 1) {
                
                self.isshowalbum = YES;
            }
            else
            {
                self.isshowalbum = NO;
            }
            
            //主页动态查看 0 所有人可见 1 好友/会员可见
            if ([responseObj[@"data"][@"dynamic_rule"] intValue] == 1) {
                
                self.isshowdynamic = YES;
            }
            else
            {
                self.isshowdynamic = NO;
            }

            //主页评论查看 0 所有人可见 1 好友/会员可见
            if ([responseObj[@"data"][@"comment_rule"] intValue] == 1) {
                
                self.isshowcomments = YES;
            }
            else
            {
                self.isshowcomments = NO;
            }
            
            //历史昵称是否可见
            if ([responseObj[@"data"][@"nickname_rule"] intValue] == 1) {
                self.isshowName = YES;
            }
            else
            {
                self.isshowName = NO;
            }
            //定位
            if ([responseObj[@"data"][@"location_switch"] intValue]==1) {
                self.location_switch = NO;
            }
            else
            {
                self.location_switch = YES;
            }
            //城市
            if ([responseObj[@"data"][@"location_city_switch"] intValue]==1) {
                self.location_city_switch = NO;
            }
            else
            {
                self.location_city_switch = YES;
            }
            //查看
            self.blackNumStr = responseObj[@"data"][@"black_limit"];
        }
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",errorMsg);
    }];
}

-(void)afterstaticData
{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getSecretSitUrl];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        if ([responseObj[@"data"][@"photo_lock"] intValue] == 1) {

            self.isshowPhoto = YES;
        }else{

            self.isshowPhoto = NO;
        }
        
         self.blackNumStr = responseObj[@"data"][@"black_limit"];
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return 3;
    }
    if (section==2) {
        return 5;
    }
    if (section==3) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            LDProvacyCell0 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity0];
            cell = [[LDProvacyCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ldprovacyidentfity0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"允许他人查看关注列表";
            [cell.switchBtn addTarget:self action:@selector(changeFocuson:) forControlEvents:UIControlEventValueChanged];
            if (self.isFocuson) {
                cell.switchBtn.on = YES;
            }
            else
            {
                cell.switchBtn.on = NO;
            }
            [cell.lineView setHidden:YES];
            return cell;
        }
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            LDProvacyCell0 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity3];
            cell = [[LDProvacyCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ldprovacyidentfity3];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"登录时间";
            [cell.switchBtn addTarget:self action:@selector(changeLogintime:) forControlEvents:UIControlEventValueChanged];
            if (self.isLogintime) {
                cell.switchBtn.on = YES;
            }
            else
            {
                cell.switchBtn.on = NO;
            }
            [cell.lineView setHidden:NO];
            return cell;
        
        }
        if (indexPath.row==1) {
            LDProvacyCell0 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity2];
            cell = [[LDProvacyCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ldprovacyidentfity2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"距离位置";
            [cell.switchBtn addTarget:self action:@selector(changePosition:) forControlEvents:UIControlEventValueChanged];
            if (self.location_switch) {
                cell.switchBtn.on = YES;
            }
            else
            {
                cell.switchBtn.on = NO;
            }
            [cell.lineView setHidden:NO];
            return cell;
        }
        if (indexPath.row==2) {
            LDProvacyCell0 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity2];
            cell = [[LDProvacyCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ldprovacyidentfity2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"所在城市";
            [cell.switchBtn addTarget:self action:@selector(changeCity:) forControlEvents:UIControlEventValueChanged];
            if (self.location_city_switch) {
                cell.switchBtn.on = YES;
            }
            else
            {
                cell.switchBtn.on = NO;
            }
            
            UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(98, 17, 45, 13)];
            newLabel.text = @"new";
            newLabel.font = [UIFont italicSystemFontOfSize:13];//设置字体为斜体
            newLabel.textColor = [UIColor redColor];
            [cell addSubview:newLabel];
            
            [cell.lineView setHidden:NO];
            return cell;
        }
        if (indexPath.row==3) {
            LDProvacyCell0 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity10];
            cell = [[LDProvacyCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ldprovacyidentfity10];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"全隐身登录(svip)";
            [cell.switchBtn addTarget:self action:@selector(changestealth:) forControlEvents:UIControlEventValueChanged];
            if (self.isallstealth) {
                cell.switchBtn.on = YES;
            }
            else
            {
                cell.switchBtn.on = NO;
            }
            cell.messageLab.hidden = NO;
            UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(148, 17, 45, 13)];
            newLabel.text = @"new";
            newLabel.font = [UIFont italicSystemFontOfSize:13];//设置字体为斜体
            newLabel.textColor = [UIColor redColor];
            [cell addSubview:newLabel];
            
            [cell.lineView setHidden:YES];
            return cell;
        }
    }
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            LDProvacyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity4];
            cell = [[LDProvacyCell1 alloc] initWithStyle:(UITableViewCellStyle)UITableViewCellStyleDefault reuseIdentifier:ldprovacyidentfity4];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"密码相册";
            if (self.isshowPhoto) {
                cell.contentLab.text = @"已开放";
            }
            else
            {
                cell.contentLab.text = @"未开放";
            }
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        if (indexPath.row==1) {
            LDProvacyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity5];
            cell = [[LDProvacyCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  ldprovacyidentfity5];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"历史昵称查看权限";
            if (!self.isshowName) {
                cell.contentLab.text = @"SVIP可见";
            }
            else
            {
                cell.contentLab.text = @"仅自己可见";
            }
            UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 17, 45, 13)];
            newLabel.text = @"new";
            newLabel.font = [UIFont italicSystemFontOfSize:13];//设置字体为斜体
            newLabel.textColor = [UIColor redColor];
            [cell addSubview:newLabel];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        if (indexPath.row==2) {
            LDProvacyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity5];
            cell = [[LDProvacyCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  ldprovacyidentfity5];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"主页相册查看权限";
            if (!self.isshowalbum) {
                cell.contentLab.text = @"所有人可见";
            }
            else
            {
                cell.contentLab.text = @"好友/会员可见";
            }
            UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 17, 45, 13)];
            newLabel.text = @"new";
            newLabel.font = [UIFont italicSystemFontOfSize:13];//设置字体为斜体
            newLabel.textColor = [UIColor redColor];
            [cell addSubview:newLabel];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        if (indexPath.row==3) {
            LDProvacyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity6];
            cell = [[LDProvacyCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  ldprovacyidentfity6];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"主页动态查看权限";
            if (!self.isshowdynamic) {
                cell.contentLab.text = @"所有人可见";
            }
            else
            {
                cell.contentLab.text = @"好友/会员可见";
            }
            UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 17, 45, 13)];
            newLabel.text = @"new";
            newLabel.font = [UIFont italicSystemFontOfSize:13];//设置字体为斜体
            newLabel.textColor = [UIColor redColor];
            [cell addSubview:newLabel];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        if (indexPath.row==4) {
            LDProvacyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity7];
            cell = [[LDProvacyCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  ldprovacyidentfity7];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"主页评论查看权限";
            if (!self.isshowcomments) {
                cell.contentLab.text = @"所有人可见";
            }
            else
            {
                cell.contentLab.text = @"好友/会员可见";
            }
            UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 17, 45, 13)];
            newLabel.text = @"new";
            newLabel.font = [UIFont italicSystemFontOfSize:13];//设置字体为斜体
            newLabel.textColor = [UIColor redColor];
            [cell addSubview:newLabel];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            [cell.lineView setHidden:YES];
            return cell;
        }
    }
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            LDProvacyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity8];
            cell = [[LDProvacyCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  ldprovacyidentfity8];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"黑名单";
            cell.contentLab.text = self.blackNumStr?:@"";
            cell.contentLab.font = [UIFont systemFontOfSize:13];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        if (indexPath.row==1) {
            LDProvacyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ldprovacyidentfity9];
            cell = [[LDProvacyCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  ldprovacyidentfity9];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLab.text = @"处罚记录";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            [cell.lineView setHidden:YES];
            return cell;
        }
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1&&indexPath.row==3) {
        return 80;
    }
    else
    {
        return 50;
    }
    return 50;
}

- (void)privacyButtonClick{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 0) {
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您现在还不是会员,不能设置相册密码~"];
        
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1){
        
        LDPrivacyPhotoViewController *pvc = [[LDPrivacyPhotoViewController alloc] init];
        if (self.isshowPhoto) {
            pvc.privacyString = @"1";
        }
        else
        {
            pvc.privacyString = @"2";
        }
        
        if (self.isFocuson) {
            pvc.attentString = @"0";
        }
        else
        {
            pvc.attentString = @"1";
        }
        [self.navigationController pushViewController:pvc animated:YES];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==2) {
        if (indexPath.row==0) {
            [self privacyButtonClick];
        }
        if (indexPath.row==1) {
            
            LDpermissionsVC *VC = [LDpermissionsVC new];
            VC.InActionType = ENUM_PERMISSIONCOMMENTS_HistorynameType;
            VC.isChoose = self.isshowName;
            VC.returnValueBlock = ^(BOOL isChoose) {
                self.isshowName = isChoose;
                [self.table reloadData];
            };
            [self.navigationController pushViewController:VC animated:YES];
            
        }
        if (indexPath.row==2) {
            LDpermissionsVC *VC = [LDpermissionsVC new];
            VC.InActionType = ENUM_PERMISSIONPHOTO_ActionType;
            VC.isChoose = self.isshowalbum;
            VC.returnValueBlock = ^(BOOL isChoose) {
                self.isshowalbum = isChoose;
                [self.table reloadData];
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
        if (indexPath.row==3) {
            LDpermissionsVC *VC = [LDpermissionsVC new];
            VC.InActionType = ENUM_PERMISSIONDYNAMIC_ActionType;
            VC.isChoose = self.isshowdynamic;
            VC.returnValueBlock = ^(BOOL isChoose) {
                self.isshowdynamic = isChoose;
                [self.table reloadData];
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
        if (indexPath.row==4) {
            LDpermissionsVC *VC = [LDpermissionsVC new];
            VC.InActionType = ENUM_PERMISSIONCOMMENTS_ActionType;
            VC.isChoose = self.isshowcomments;
            VC.returnValueBlock = ^(BOOL isChoose) {
                self.isshowcomments = isChoose;
                [self.table reloadData];
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            LDBlackListViewController *bvc = [[LDBlackListViewController alloc] init];
            [self.navigationController pushViewController:bvc animated:YES];
        }
        if (indexPath.row==1) {
            
        }
    }
}

#pragma mark - UISwitch-Click

-(void)changeFocuson:(UISwitch *)swi{
    self.isFocuson = !self.isFocuson;
    [self.table reloadData];
}


-(void)changePosition:(UISwitch *)swi
{
    self.location_switch = !self.location_switch;
    [self.table reloadData];
}

-(void)changeCity:(UISwitch *)swi
{
    self.location_city_switch = !self.location_city_switch;
    [self.table reloadData];
}

-(void)changeLogintime:(UISwitch *)swi
{
    self.isLogintime = !self.isLogintime;
    [self.table reloadData];
}

-(void)changestealth:(UISwitch *)swi
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue]==1) {
        self.isallstealth = !self.isallstealth;
        [self.table reloadData];
    }
    else
    {
        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"全隐身登录限SVIP可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
            [self.navigationController pushViewController:mvc animated:YES];
        }];
        [control addAction:action0];
        [control addAction:action1];
        [self presentViewController:control animated:YES completion:nil];
    }
}

-(void)setquanyinshenClick
{
    //uid
    //type：空      获取code1：全隐身    2：不隐身
    //type：0    设置关闭隐身
    //type：1    设置隐身
    NSString *url = [PICHEADURL stringByAppendingString:hideStateSwitchUrl];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *type = @"";
    if (self.isallstealth) {
        type = @"1";
    }else
    {
        type = @"0";
    }
    NSDictionary *params = @{@"type":type,@"uid":uid};
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - back

-(void)backButtonOnClick{
    
    [self changeldprovacyClick];
//    [self setquanyinshenClick];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)changeldprovacyClick
{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,setSecretSitUrl];
    NSString *attentString = [NSString new];
    if (self.isFocuson) {
        attentString = @"0";
    }
    else
    {
        attentString = @"1";
    }
    NSString *loginTimeString = [NSString new];
    if (self.isLogintime) {
        loginTimeString = @"0";
    }
    else
    {
        loginTimeString = @"1";
    }
    
    NSString *photo_rule = [NSString new];
    if (!self.isshowalbum) {
        photo_rule = @"0";
    }
    else
    {
        photo_rule = @"1";
    }
    
    NSString *dynamic_rule = [NSString new];
    if (!self.isshowdynamic) {
        dynamic_rule = @"0";
    }
    else
    {
        dynamic_rule = @"1";
    }
    
    NSString *comment_rule = [NSString new];
    if (!self.isshowcomments) {
        comment_rule = @"0";
    }
    else
    {
        comment_rule = @"1";
    }
    
    NSString *nickname_rule = [NSString new];
    if (!self.isshowName) {
        nickname_rule = @"0";
    }
    else
    {
        nickname_rule = @"1";
    }
    
    NSString *location_city_switch = [NSString new];
    if (self.location_city_switch) {
        location_city_switch = @"0";
    }
    else
    {
        location_city_switch = @"1";
    }
    
    NSString *location_switch = [NSString new];
    if (self.location_switch) {
        location_switch = @"0";
    }
    else
    {
        location_switch = @"1";
    }
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"follow_list_switch":attentString,@"login_time_switch":loginTimeString,@"photo_rule":photo_rule,@"dynamic_rule":dynamic_rule,@"comment_rule":comment_rule,@"nickname_rule":nickname_rule,@"location_switch":location_switch,@"location_city_switch":location_city_switch};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseObj objectForKey:@"msg"]    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:action];
            //[self presentViewController:alert animated:YES completion:nil];
        }else{
           // [self.navigationController popViewControllerAnimated:YES];
        }
    } failed:^(NSString *errorMsg) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"因网络等原因修改失败"    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:action];
        //[self presentViewController:alert animated:YES completion:nil];
    }];
}

@end
