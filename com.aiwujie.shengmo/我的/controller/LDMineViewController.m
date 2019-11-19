//
//  LDMineViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/18.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDMineViewController.h"
#import "LDStampViewController.h"
#import "LDBulletinViewController.h"
#import "LDCollectionDynamicViewController.h"
#import "LDSetViewController.h"
#import "LDAttentionListViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDMyWalletViewController.h"
#import "LDLookOrBeLookViewController.h"
#import "LDMemberViewController.h"
#import "LDGroupSpuareViewController.h"
#import "LDCertificateViewController.h"
#import "LDCertificateBeforeViewController.h"
#import "LDGroupNumberViewController.h" 
#import "LDMyWalletPageViewController.h"
#import "HeaderTabViewController.h"
#import "LDMatchmakerViewController.h"
#import "AppDelegate.h"
#import "LDShareView.h"
#import "LDSignView.h"
#import "ShowBadgeCell.h"
#import "UITabBar+badge.h"
#import "LDtotopViewController.h"
#import "LDhistorynameViewController.h"
#import "LDDynamicDetailViewController.h"
#import "IdcardViewController.h"
#import "LDCertificatePageVC.h"

@interface LDMineViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,PlatformButtonClickDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backH;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backW;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerH;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *lookButton;
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *showView;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;

//广告展示的数组数据
@property (nonatomic,strong) NSMutableArray *slideArray;

//个人认证状态
@property (nonatomic,copy) NSString *status;

//访问记录红点数
@property (nonatomic,copy) NSString *lookBadge;

//分享视图
@property (nonatomic,strong) LDShareView *shareView;
@end

@implementation LDMineViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.headImageView.layer.cornerRadius = 30;
    self.headImageView.clipsToBounds = YES;
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _slideArray = [NSMutableArray array];
    [self createRightButton];
    _dataArray = @[@[@"充值礼物",@"会员中心",@"动态推顶",@"消息邮票",@"红娘牵线"],@[@"我的认证",@"分享APP"],@[@"设置"]];
    [self createHeadData];
    _shareView = [[LDShareView alloc] init];
    //分享视图
    [self.tabBarController.view addSubview:[_shareView createBottomView:@"Mine" andNickName:nil andPicture:nil andId:nil]];
    //监听谁看过我
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookFangBadge) name:@"lookBadge" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suspenshowView) name:SUPVIEWNOTIFICATION object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createPersonInformationData];
    [self vhl_setNavBarShadowImageHidden:YES];
    //获得查看人数
    _lookBadge = [[NSUserDefaults standardUserDefaults] objectForKey:@"lookBadge"];
    //判断有无人查看来控制红点的显示与隐藏
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"lookBadge"] intValue] == 0) {
        
        [self.tabBarController.tabBar hideBadgeOnItemIndex:4];
        
    }else{
        
        [self.tabBarController.tabBar showBadgeOnItemIndex:4];
    }
    //获取个人认证状态
    [self createCertificateData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self vhl_setNavBarShadowImageHidden:NO];
}

//获取个人认证信息
-(void)createCertificateData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/getidstate"];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            _status = @"已认证";
        }
        if ([[responseObj objectForKey:@"retcode"] intValue]==2001) {
            _status = @"正在审核";
        }
        if ([[responseObj objectForKey:@"retcode"] intValue]==2002) {
            _status = @"立即认证";
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
    }];
}

/**
 * 有人查看我的监听方法
 */
-(void)lookFangBadge{
    
    _lookBadge = [[NSUserDefaults standardUserDefaults] objectForKey:@"lookBadge"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

-(void)createRightButton{

    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton setTitle:@"收藏" forState:UIControlStateNormal];
    [rightButton setTitleColor:TextCOLOR forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton addTarget:self action:@selector(signButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIButton * liftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [liftButton setTitle:@"签到" forState:UIControlStateNormal];
    [liftButton setTitleColor:TextCOLOR forState:UIControlStateNormal];
    liftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [liftButton addTarget:self action:@selector(liftButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* liftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:liftButton];
    self.navigationItem.leftBarButtonItem = liftBarButtonItem;
}

-(void)liftButtonOnClick{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getSignTimesInWeeksUrl];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer == 2002) {
            LDSignView *signView = [[LDSignView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
            [signView getSignDays:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"signtimes"]] andsignState:@"未签到"];
            [self.tabBarController.view addSubview:signView];
        }else if (integer == 2001){
            LDSignView *signView = [[LDSignView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
            [signView getSignDays:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"signtimes"]] andsignState:@"已签到"];
            [self.tabBarController.view addSubview:signView];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)signButtonOnClick{
    LDCollectionDynamicViewController *dvc = [[LDCollectionDynamicViewController alloc] init];
    dvc.title = @"我的收藏";
    [self.navigationController pushViewController:dvc animated:YES];
}

-(void)createHeadData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getSlideMoreUrl];
    NSDictionary *parameters = @{@"type":@"4"};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            self.headerH.constant = 0;
            self.backW.constant = WIDTH;
            self.backH.constant = self.backView.frame.size.height - 98;
            self.backView.frame = CGRectMake(0, 0, self.backW.constant, self.backH.constant);
            [self createPersonInformationData];
        }else{
            self.headerH.constant = ADVERTISEMENT;
            self.backW.constant = WIDTH;
            self.backH.constant = 135 + self.headerH.constant;
            self.backView.frame = CGRectMake(0, 0, self.backW.constant, 135 + self.headerH.constant);
            [_slideArray addObjectsFromArray:responseObj[@"data"]];
            NSMutableArray *pathArray = [NSMutableArray array];
            for (NSDictionary *dic in responseObj[@"data"]) {
                [pathArray addObject:dic[@"path"]];
            }
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, ADVERTISEMENT) delegate:self placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
            cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            cycleScrollView.imageURLStringsGroup = pathArray;
            cycleScrollView.autoScrollTimeInterval = 3.0;
            [_headerImageView addSubview:cycleScrollView];
            UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 25, 5, 20, 20)];
            [deleteButton setBackgroundImage:[UIImage imageNamed:@"删除按钮"] forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [self.headerImageView addSubview:deleteButton];
        }
        [self createTableView];
    } failed:^(NSString *errorMsg) {
        self.headerH.constant = 0;
        self.backW.constant = WIDTH;
        self.backH.constant = self.backView.frame.size.height - 98;
        self.backView.frame = CGRectMake(0, 0, self.backW.constant, self.backH.constant);
        [self createTableView];
        [self createPersonInformationData];
    }];
    
    self.backView.backgroundColor = [UIColor colorWithHexString:@"686868" alpha:1];
    self.nameView.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
    self.showView.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
    self.nameLabel.textColor = [UIColor lightGrayColor];
    self.attentionLabel.textColor = [UIColor lightGrayColor];
    self.fansLabel.textColor = [UIColor lightGrayColor];
    self.groupLabel.textColor = [UIColor lightGrayColor];
    [self.lookButton setTitleColor:[UIColor lightGrayColor] forState:normal];
    
}

//删除上面的广告
-(void)deleteButtonClick{
    for (UIView *view in self.headerImageView.subviews) {
        [view removeFromSuperview];
    }
    self.headerH.constant = 0;
    self.backW.constant = WIDTH;
    self.backH.constant = 135;
    self.backView.frame = CGRectMake(0, 0, self.backW.constant, 135);
    self.tableView.tableHeaderView = self.backView;
    [self.tableView reloadData];
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    //link_type 0:url,1:话题,2:动态,3:主页,
    if ([_slideArray[index][@"link_type"] intValue] == 0) {
        NSString *newURL = [NSString stringWithFormat:@"%@?uid=%@",self.slideArray[index][@"url"],[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
        LDWebVC *webVC = [[LDWebVC alloc] initWithURLString:newURL];
        webVC.title = self.slideArray[index][@"title"];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    if ([_slideArray[index][@"link_type"] intValue] == 1) {
        HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
        tvc.tid = [NSString stringWithFormat:@"%@",_slideArray[index][@"link_id"]];
        [self.navigationController pushViewController:tvc animated:YES];
    }
    if ([_slideArray[index][@"link_type"] intValue] == 2) {
        LDDynamicDetailViewController *vc = [LDDynamicDetailViewController new];
        vc.did = [NSString stringWithFormat:@"%@",_slideArray[index][@"link_id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([_slideArray[index][@"link_type"] intValue] == 3) {
        LDOwnInformationViewController *VC = [LDOwnInformationViewController new];
        VC.userID = [NSString stringWithFormat:@"%@",_slideArray[index][@"link_id"]];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

-(void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 49) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.backView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShowBadgeCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ShowBadgeCell" owner:self options:nil].lastObject;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.headView.image = [UIImage imageNamed:self.dataArray[indexPath.section][indexPath.row]];
    cell.nameLabel.text = self.dataArray[indexPath.section][indexPath.row];
    cell.headView.alpha = 0.5;
    if (indexPath.row==2&&indexPath.section==0) {

        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.nameLabel.frame)-55, CGRectGetMinY(cell.nameLabel.frame)+5, 50, 13)];
        newLabel.text = @"new";
        newLabel.font = [UIFont italicSystemFontOfSize:13];//设置字体为斜体
        newLabel.textColor = [UIColor redColor];
        [cell addSubview:newLabel];
        
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (_lookBadge.length != 0) {
            cell.badgeLabel.hidden = NO;
            if ([_lookBadge intValue] > 99) {
                cell.badgeLabel.text = @"99+";
            }else{
                cell.badgeLabel.text = _lookBadge;
            }
        }else{
            cell.badgeLabel.hidden = YES;
        }
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.nameLabel.frame)-55, CGRectGetMinY(cell.nameLabel.frame)+5, 50, 13)];
        newLabel.text = @"new";
        newLabel.font = [UIFont italicSystemFontOfSize:13];//设置字体为斜体
        newLabel.textColor = [UIColor redColor];
        [cell addSubview:newLabel];
    }
    if (indexPath.section == 0 && indexPath.row == 4) {
        cell.lineView.hidden = YES;
    }else if (indexPath.section == 1 && indexPath.row == 1){
        cell.lineView.hidden = YES;
    }else if (indexPath.section == 2 && indexPath.row == 0){
        cell.lineView.hidden = YES;
    }
    else{
        cell.lineView.hidden = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            LDMyWalletPageViewController *mvc = [[LDMyWalletPageViewController alloc] init];
            [self.navigationController pushViewController:mvc animated:YES];
        }else if (indexPath.row == 1){
            LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
            mvc.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            [self.navigationController pushViewController:mvc animated:YES];
        }
            else if (indexPath.row==2){
            LDtotopViewController *vc = [LDtotopViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 3) {
            LDStampViewController *svc = [[LDStampViewController alloc] init];
            [self.navigationController pushViewController:svc animated:YES];
         
            
        }else if (indexPath.row == 4){
            LDMatchmakerViewController *match = [[LDMatchmakerViewController alloc] init];
            [self.navigationController pushViewController:match animated:YES];
            
        }else if (indexPath.row == 6){
            
            
        }else if(indexPath.row == 7){
        
        } else {
            
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            LDCertificatePageVC *VC = [[LDCertificatePageVC alloc] init];
            VC.status = self.status;
            [self.navigationController pushViewController:VC animated:YES];
        } else if (indexPath.row == 1) {
            
            YSActionSheetView * ysSheet=[[YSActionSheetView alloc]initNYSView];
            ysSheet.delegate=self;
            ysSheet.comeFrom = @"Mine";
            [self.view addSubview:ysSheet];
            
        } else
        {
            
        }
    } else {
        if (indexPath.row == 0) {
            LDSetViewController *svc = [[LDSetViewController alloc] init];
            [self.navigationController pushViewController:svc animated:YES];
        }
    }
}

- (IBAction)lookOwnButtonClick:(id)sender {
    
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    ivc.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    [self.navigationController pushViewController:ivc animated:YES];
}

- (IBAction)attentButtonClick:(id)sender {
    
    LDAttentionpageVC *avc = [[LDAttentionpageVC alloc] init];
    avc.type = @"0";
    avc.isguanzhu = YES;
    avc.isMine = YES;
    avc.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];;
    [self.navigationController pushViewController:avc animated:YES];
}

- (IBAction)fansButtonClick:(id)sender {
    LDAttentionpageVC *avc = [[LDAttentionpageVC alloc] init];
    avc.type = @"1";
    avc.isguanzhu = NO;
    avc.isMine = YES;
    avc.isfromGuanzhu = YES;
    avc.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];;
    [self.navigationController pushViewController:avc animated:YES];
}

- (IBAction)groupButtonClick:(id)sender {
    
    LDGroupNumberViewController *nvc = [[LDGroupNumberViewController alloc] init];
    nvc.userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
    [self.navigationController pushViewController:nvc animated:YES];
}

-(void)createPersonInformationData{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getmineinfoUrl];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
        }else{
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.nameLabel.text = responseObj[@"data"][@"nickname"];
            self.attentionLabel.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"follow_num"]];
            self.fansLabel.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"fans_num"]];
            self.groupLabel.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"group_num"]];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)suspenshowView
{
    int index =  (int)[self.tabBarController selectedIndex];
    if (index==4) {
        ChatroomVC *vc = [ChatroomVC new];
        vc.roomidStr = roomidStr.copy;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - shanreDelegate

- (void) customActionSheetButtonClick:(YSActionSheetButton *) btn
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
