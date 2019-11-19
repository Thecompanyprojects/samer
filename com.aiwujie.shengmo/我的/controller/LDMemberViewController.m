//
//  LDMemberViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/10.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDMemberViewController.h"
#import "LDProtocolViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDMemberPageViewController.h"
#import <StoreKit/StoreKit.h>
#import <AFNetworkReachabilityManager.h>
#import "LDBillPageViewController.h"
#import "LDBillPresenter.h"

@interface LDMemberViewController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource,SDCycleScrollViewDelegate>{
    
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipMemberLabel;

//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDMemberPageViewController *memberPageViewController;

//存放按钮和下划线的view
@property (weak, nonatomic) IBOutlet UIView *topView;

//赠送会员
@property (weak, nonatomic) IBOutlet UIView *giveView;
@property (weak, nonatomic) IBOutlet UIImageView *giveHeadView;
@property (weak, nonatomic) IBOutlet UIImageView *givedHeadView;

//本人购买会员
@property (weak, nonatomic) IBOutlet UIView *buyView;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;

//显示目前在哪个界面
@property (nonatomic,assign) NSInteger index;

//存储选择充值哪个会员
@property (nonatomic,copy) NSString *buttonString;

//订单凭证
@property (nonatomic,copy) NSString *receipt;

//订单号
@property (nonatomic,copy) NSString *order_no;

//订单号
@property (nonatomic,copy) NSString *VIPIndex;

//存储会员的内购id
@property (nonatomic,strong) NSArray *shopArray;

//存储超级会员的内购id
@property (nonatomic,strong) NSArray *svipArray;

@property (nonatomic,strong) UIButton *chooseBtn;
@property (nonatomic,assign) BOOL isChoose;//yes  上大喇叭  传1  不上 传2

//是否显示广告
@property (nonatomic,assign) BOOL isshowadvertising;
//广告展示的数组数据
@property (nonatomic,strong) NSMutableArray *slideArray;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,copy) NSString *buyUrl;
@property (nonatomic,strong) UIButton *exchangebtn;
@property (nonatomic,assign) BOOL isshow;
@end

@implementation LDMemberViewController

- (NSArray *)pageContentArray {
    
    if (!_pageContentArray) {
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        LDMemberPageViewController *v1 = [[LDMemberPageViewController alloc] init];
        LDMemberPageViewController *v2 = [[LDMemberPageViewController alloc] init];
        [arrayM addObject:v1];
        [arrayM addObject:v2];
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
    }
    return _pageContentArray;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.slideArray = [NSMutableArray array];
    if ([self.type isEqualToString:@"give"]) {
        
        self.navigationItem.title = @"赠送会员";
        
        [self.givedHeadView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_headUrl]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        self.giveHeadView.contentMode = UIViewContentModeScaleAspectFill;
        self.givedHeadView.layer.cornerRadius = 30;
        self.givedHeadView.clipsToBounds = YES;
        
        self.giveHeadView.layer.cornerRadius = 30;
        self.giveHeadView.clipsToBounds = YES;
        
        self.buyView.hidden = YES;
        
        self.givedHeadView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.isChoose = YES;
        self.chooseBtn = [[UIButton alloc] init];
        [self.view addSubview:self.chooseBtn];
        [self.chooseBtn setBackgroundImage:[UIImage imageNamed:@"shiguanzhu"] forState:UIControlStateNormal];
        if (ISIPHONEPLUS) {
            [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.messageLab);
                make.width.mas_offset(13);
                make.height.mas_offset(13);
                make.right.equalTo(self.view).with.offset(-55);
            }];
        }
        else
        {
            [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.messageLab);
                make.width.mas_offset(13);
                make.height.mas_offset(13);
                make.right.equalTo(self.view).with.offset(-25);
            }];
        }
        [self.chooseBtn addTarget:self action:@selector(chooseclick) forControlEvents:UIControlEventTouchUpInside];
        self.messageLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseclick)];
        [self.messageLab addGestureRecognizer:singleTap];

    }else{
        self.navigationItem.title = @"会员中心";
        self.headView.layer.cornerRadius = 35;
        self.headView.clipsToBounds = YES;
        self.giveView.hidden = YES;
        [self createInfoData];
        [self createRightButton];
    }
    
//    _shopArray = @[@"pay7",@"pay8",@"pay9",@"pay10"];
//
//    _svipArray = @[@"pay11",@"pay12",@"pay13",@"pay14"];
    
    _shopArray = @[@"vip1",@"vip2",@"vip3",@"vip8"];
    
    _svipArray = @[@"svip1",@"svip2",@"svip3",@"svip4"];
    
    
    _index = 1;
    
    //验证会员的购买凭证
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"会员凭证"] length] != 0) {
    
        [self zaiciyanzhengpingzheng];
        
   }
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    //获取头部的头像
    [self createHeadViewData];
    
    //生成翻页控制器
    [self createPageViewController];
    
    [LDBillPresenter savewakketNum];
    [self iscanexchange];
    [self isshowbuttons];
//    [self newcreatButton];
    [self isshowapplepay];
}

#pragma mark - 广告

-(void)isshowapplepay
{
    NSString *url = [PICHEADURL stringByAppendingString:@"api/power/appleInnerPayState"];
    [NetManager afPostRequest:url parms:nil finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSDictionary *data = [responseObj objectForKey:@"data"];
            NSString *state = [NSString stringWithFormat:@"%@",[data objectForKey:@"state"]];
            if ([state intValue]==1) {
                //创建购买的按钮
                [self createBuyButton];
                self.exchangebtn.frame = CGRectMake(0, [self getIsIphoneX:ISIPHONEX]-90, WIDTH, 44);
            }
            else
            {
                self.exchangebtn.frame = CGRectMake(0, [self getIsIphoneX:ISIPHONEX]-50, WIDTH, 44);
            }
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)isshowbuttons
{
    NSString *url = [PICHEADURL stringByAppendingString:@"api/power/applePayState"];
    
    [NetManager afPostRequest:url parms:nil finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSDictionary *data = [responseObj objectForKey:@"data"];
            NSString *state = [NSString stringWithFormat:@"%@",data[@"state"]];
            if ([state intValue]==1) {
                self.isshowadvertising = YES;
                
//                UIButton *buybtn = [[UIButton alloc] initWithFrame:CGRectMake(0, [self getIsIphoneX:ISIPHONEX]-90-46, WIDTH, 44)];
//                [buybtn setTitleColor:[UIColor whiteColor] forState:normal];
//                [buybtn setBackgroundColor:MainColor];
//                [buybtn setTitle:@"官方充值" forState:normal];
//                [buybtn addTarget:self action:@selector(shengmobuyClick) forControlEvents:UIControlEventTouchUpInside];
//                [self.view addSubview:buybtn];
                
//
//                self.exchangebtn = [[UIButton alloc] initWithFrame:CGRectMake(0, [self getIsIphoneX:ISIPHONEX] - 90, WIDTH, 44)];
//                [self.exchangebtn setTitleColor:[UIColor whiteColor] forState:normal];
//                [self.exchangebtn setBackgroundColor:MainColor];
//                [self.exchangebtn setTitle:@"魔豆兑换" forState:normal];
//                [self.exchangebtn addTarget:self action:@selector(exchangeButtonClick) forControlEvents:UIControlEventTouchUpInside];
//                [self.view addSubview:self.exchangebtn];
            }
            else
            {
                self.isshowadvertising = NO;
            }
            self.buyUrl = [data objectForKey:@"url"];
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)shengmobuyClick
{
    LDBulletinViewController *bvc = [[LDBulletinViewController alloc] init];
    NSString *newURL = [NSString stringWithFormat:@"%@?uid=%@",self.buyUrl,self.userID];
    bvc.url = newURL;
    bvc.title = @"官方充值";
    [self.navigationController pushViewController:bvc animated:YES];
}

-(void)iscanexchange
{
    NSString *url = [PICHEADURL stringByAppendingString:getSlideMoreUrl];
    NSDictionary *params = @{@"type":@"10"};
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {

            NSArray *data = [NSArray yy_modelArrayWithClass:[advertisingModel class] json:responseObj[@"data"]];
            [self.slideArray addObjectsFromArray:data];
            
            NSMutableArray *pathArray = [NSMutableArray array];
            for (NSDictionary *dic in responseObj[@"data"]) {
                [pathArray addObject:dic[@"path"]];
            }
            self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, ADVERTISEMENT) delegate:self placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
            self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            self.cycleScrollView.imageURLStringsGroup = pathArray;
            self.cycleScrollView.autoScrollTimeInterval = 3.0;
            [self.view addSubview:self.cycleScrollView];
            self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 25, 5, 20, 20)];
            [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"删除按钮"] forState:UIControlStateNormal];
            [self.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.deleteButton];
            
            self.buyView.frame = CGRectMake(0, ADVERTISEMENT, WIDTH, 98);
            self.giveView.frame = CGRectMake(0, ADVERTISEMENT, WIDTH, 98);
            self.topView.frame = CGRectMake(0, ADVERTISEMENT+98+4, WIDTH, 50);
            self.pageViewController.view.frame = CGRectMake(0, 148+4+ADVERTISEMENT, self.view.frame.size.width, self.view.frame.size.height-ADVERTISEMENT-200);
            
        }
        else
        {
            
            self.buyView.frame = CGRectMake(0, 0, WIDTH, 98);
            self.giveView.frame = CGRectMake(0, 0, WIDTH, 98);
            self.topView.frame = CGRectMake(0, 0+98+4, WIDTH, 50);
            self.pageViewController.view.frame = CGRectMake(0, 148+4, self.view.frame.size.width, self.view.frame.size.height-148-100);
            self.isshow = YES;
        }
    } failed:^(NSString *errorMsg) {

        self.buyView.frame = CGRectMake(0, 0, WIDTH, 98);
        self.giveView.frame = CGRectMake(0, 0, WIDTH, 98);
        self.topView.frame = CGRectMake(0, 0+98+4, WIDTH, 50);
        self.pageViewController.view.frame = CGRectMake(0, 148+4, self.view.frame.size.width, self.view.frame.size.height-50);
    }];
}

-(void)deleteButtonClick
{
    [self.cycleScrollView removeFromSuperview];
    [self.deleteButton removeFromSuperview];

    self.buyView.frame = CGRectMake(0, 0, WIDTH, 98);
    self.giveView.frame = CGRectMake(0, 0, WIDTH, 98);
    self.topView.frame = CGRectMake(0, 0+98+4, WIDTH, 50);
    self.pageViewController.view.frame = CGRectMake(0, 148+4, self.view.frame.size.width, self.view.frame.size.height-50);
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    advertisingModel *model = self.slideArray[index];
    if ([model.link_type intValue]==0) {
       NSString *newURL = [NSString stringWithFormat:@"%@?uid=%@",self.slideArray[index][@"url"],[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
        LDWebVC *webVC = [[LDWebVC alloc] initWithURLString:newURL];
        webVC.title = self.slideArray[index][@"title"];
        [self.navigationController pushViewController:webVC animated:YES];
        
    }
    if ([model.link_type intValue]==1) {
        HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
        tvc.tid = [NSString stringWithFormat:@"%@",model.link_id];
        [self.navigationController pushViewController:tvc animated:YES];
        
    }
    if ([model.link_type intValue]==2) {
        LDDynamicDetailViewController *vc = [LDDynamicDetailViewController new];
        vc.did = [NSString stringWithFormat:@"%@",model.link_id];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if ([model.link_type intValue]==3) {
        LDOwnInformationViewController *VC = [LDOwnInformationViewController new];
        VC.userID = [NSString stringWithFormat:@"%@",model.link_id];
        [self.navigationController pushViewController:VC animated:YES];
    }
}



-(void)chooseclick
{
    self.isChoose = !self.isChoose;
    if (self.isChoose) {
         [self.chooseBtn setBackgroundImage:[UIImage imageNamed:@"shiguanzhu"] forState:UIControlStateNormal];
    }
    else
    {
         [self.chooseBtn setBackgroundImage:[UIImage imageNamed:@"kongguanzhu"] forState:UIControlStateNormal];
    }
}

#pragma mark - 魔豆兑换

-(void)newcreatButton
{
    //右侧下拉列表
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightButton setTitle:@"魔豆兑换" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(newrightButtonOnClic) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}


-(void)newrightButtonOnClic
{
    NSString *numStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"walletNum"];
    
    //会员明细 兑换 SVIP 和 vip
    UIAlertController *control = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"金魔豆兑换VIP" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *newStr = @"";
        if (numStr.length==0) {
            newStr = @"0";
        }
        else
        {
            newStr = numStr;
        }
        NSArray *VIPArray = @[[NSString stringWithFormat:@"%@%@%@",@"(剩余",newStr,@"金魔豆)"],@"1个月/300金魔豆", @"3个月/880金魔豆(优惠3%)", @"6个月/1680金魔豆(优惠7%)", @"12个月/2980金魔豆(优惠18%)"];
        
        UIAlertController *VIPAlert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (int i = 0; i < VIPArray.count; i++) {
            
            UIAlertAction *month = [UIAlertAction actionWithTitle:VIPArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *dalaba = [NSString new];
                if (self.isChoose) {
                    dalaba = @"1";
                }
                else
                {
                    dalaba = @"2";
                }

                if (i!=0) {
                    NSString *urlString = [NSString stringWithFormat:@"%@%@",PICHEADURL,vip_beansUrl];
                    NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"viptype":[NSString stringWithFormat:@"%d",i], @"beanstype":@"0",@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID,@"dalaba":dalaba};
                    [self startExchangeWithUrl:urlString parameters:parameters];
                    
                };
            }];
            
            [VIPAlert addAction:month];
            
            if (PHONEVERSION.doubleValue >= 8.3&&i!=0) {
                [month setValue:MainColor forKey:@"_titleTextColor"];
            }
            if (PHONEVERSION.doubleValue >= 8.3&&i==0) {
                [month setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
            }
        }
        
        [self cancelActionWithAlert:VIPAlert];
        
        [self presentViewController:VIPAlert animated:YES completion:nil];
        
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"金魔豆兑换SVIP" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *newStr = @"";
        if (numStr.length==0) {
            newStr = @"0";
        }
        else
        {
            newStr = numStr;
        }
        NSArray *SVIPArray = @[@"1个月/1280金魔豆", @"3个月/3480金魔豆(优惠9%)", @"8个月/8980金魔豆(优惠13%)", @"12个月/12980金魔豆(优惠16%)"];
        NSMutableArray *arrs = [NSMutableArray new];
        [arrs addObject:[NSString stringWithFormat:@"%@%@%@",@"(剩余",newStr,@"金魔豆)"]];
        [arrs addObjectsFromArray:SVIPArray];
        
        UIAlertController *SVIPAlert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (int i = 0; i < arrs.count; i++) {
            UIAlertAction *month = [UIAlertAction actionWithTitle:arrs[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          
                if (i!=0) {
                    
                    NSString *dalaba = [NSString new];
                    if (self.isChoose) {
                        dalaba = @"1";
                    }
                    else
                    {
                        dalaba = @"2";
                    }
                    
                    NSString *urlString = [NSString stringWithFormat:@"%@%@",PICHEADURL,svip_beansUrl];
                    NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"subject":[NSString stringWithFormat:@"%d",i], @"channel":@"1",@"vuid":self.userID,@"dalaba":dalaba};
                    [self startExchangeWithUrl:urlString parameters:parameters];
                }
            }];
            
            [SVIPAlert addAction:month];
            if (PHONEVERSION.doubleValue >= 8.3&&i!=0) {
                [month setValue:MainColor forKey:@"_titleTextColor"];
            }
            if (PHONEVERSION.doubleValue >= 8.3&&i==0) {
                [month setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
            }
        }
        [self cancelActionWithAlert:SVIPAlert];
        [self presentViewController:SVIPAlert animated:YES completion:nil];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        [action0 setValue:MainColor forKey:@"_titleTextColor"];
        [action1 setValue:MainColor forKey:@"_titleTextColor"];
        [action2 setValue:MainColor forKey:@"_titleTextColor"];
    }
    
    [control addAction:action0];
    [control addAction:action1];
    [control addAction:action2];
    [self presentViewController:control animated:YES completion:^{
        
    }];
}


//创建取消的按钮
-(void)cancelActionWithAlert:(UIAlertController *)alert{
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
    [alert addAction:cancelAction];
    if (PHONEVERSION.doubleValue >= 8.3) {
        [cancelAction setValue:MainColor forKey:@"_titleTextColor"];
    }
}


#pragma mark - 明细列表

-(void)createRightButton{
    //右侧下拉列表
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightButton setTitle:@"明细" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonOnClic) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}


-(void)rightButtonOnClic
{
    LDBillPageViewController *vc = [LDBillPageViewController new];
    vc.isfromVip = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 * 创建购买的按钮
 */
-(void)createBuyButton{
    
    UIButton *buyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, [self getIsIphoneX:ISIPHONEX] - 44, WIDTH, 44)];
    [buyButton setBackgroundColor:MainColor];
    [buyButton setTitle:@"苹果内购" forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(buyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:buyButton];
    
}


/**
 魔豆兑换方法
 */
-(void)exchangeButtonClick
{
    NSString *numStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"walletNum"];
    NSString *titleStr = [NSString stringWithFormat:@"%@%@%@",@"(剩余",numStr,@"金魔豆)"];
    UIAlertController *control = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSArray *arr0 = @[@"1个月/300金魔豆",@"3个月/880金魔豆(优惠3%)",@"6个月/1680金魔豆(优惠7%)",@"12个月/2980金魔豆(优惠18%)"];
    NSArray *arr1 = @[@"1个月/1280金魔豆",@"3个月/3480金魔豆(优惠9%)",@"8个月/8980金魔豆(优惠13%)",@"12个月/12980金魔豆(优惠16%)"];
    
    LDMemberPageViewController *member = [self viewControllerAtIndex:self.index];
    
    NSString *titleStr1 = [NSString new];
    NSString *viptype = [NSString new];
    if (_index==0) {
        titleStr1 = [arr0 objectAtIndex:member.vipNum];
        viptype = [NSString stringWithFormat:@"%ld",(long)member.vipNum+1];
    }
    else
    {
        titleStr1 = [arr1 objectAtIndex:member.svipNum];
        viptype = [NSString stringWithFormat:@"%ld",(long)member.svipNum+1];
    }
    
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:titleStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *newURL = [NSString stringWithFormat:@"%@?uid=%@",self.buyUrl,self.userID];
        JXBWebViewController *webVC = [[JXBWebViewController alloc] initWithURLString:newURL];
        webVC.title = @"官方充值";
        [self.navigationController pushViewController:webVC animated:YES];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:titleStr1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        NSString *dalaba = @"0";
        if (self.isChoose) {
            dalaba = @"1";
        }
        else
        {
            dalaba = @"2";
        }
        
        NSDictionary *parameters = [NSDictionary new];
        
        NSString *urlString = [NSString new];
        
        if (_index==0) {
            urlString = [NSString stringWithFormat:@"%@%@",PICHEADURL,vip_beansUrl];
            parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"viptype":viptype, @"beanstype":@"0",@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID,@"dalaba":dalaba};
        }
        else
        {
            urlString = [NSString stringWithFormat:@"%@%@",PICHEADURL,svip_beansUrl];
            parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"subject":viptype, @"channel":@"1",@"vuid":self.userID,@"dalaba":dalaba};
        }
       
        [self startExchangeWithUrl:urlString parameters:parameters];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [control addAction:action0];
    [control addAction:action1];
    [control addAction:action2];
    if (PHONEVERSION.doubleValue >= 8.3) {
        [action0 setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        [action1 setValue:MainColor forKey:@"_titleTextColor"];
        [action2 setValue:MainColor forKey:@"_titleTextColor"];
    }
    [self presentViewController:control animated:YES completion:^{
        
    }];
}

- (void)startExchangeWithUrl:(NSString *)url parameters:(NSDictionary *)parameters{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    [LDAFManager postDataWithDictionary:parameters andUrlString:url success:^(NSString *msg) {
        
        hud.labelText = msg;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        
    } fail:^(NSString *errorMsg){
        
        hud.labelText = errorMsg;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        
    }];
}


/**
 * 点击确认支付按钮
 */
-(void)buyButtonClick{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"会员凭证"] length] != 0) {
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您有支付凭证验证失败,暂时不能购买会员,请退出页面后重新进入验证或联系客服"];
        
    }else{
        
        //1.创建网络状态监测管理者
        AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
        //开启监听，记得开启，不然不走block
        [manger startMonitoring];
        //2.监听改变
        [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            /*
             AFNetworkReachabilityStatusUnknown = -1,
             AFNetworkReachabilityStatusNotReachable = 0,
             AFNetworkReachabilityStatusReachableViaWWAN = 1,
             AFNetworkReachabilityStatusReachableViaWiFi = 2,
             */
            
            if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
                
                if([SKPaymentQueue canMakePayments]){
                    
                    LDMemberPageViewController *member = [self viewControllerAtIndex:self.index];
                    
                    if (self.index == 0) {
                        self.buttonString = [NSString stringWithFormat:@"%@",_shopArray[member.vipNum]];
                    }else{
                        self.buttonString = [NSString stringWithFormat:@"%@",_svipArray[member.svipNum]];
                    }
//                    NSLog(@"%@",_buttonString);
                    [self requestProductData:self.buttonString];
                }else{
//                    NSLog(@"不允许程序内付费");
                    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的手机没有打开程序内付费购买" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"关闭",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [control addAction:action];
                    [self presentViewController:control animated:YES completion:^{
                        
                    }];
                    
                }
                
            }else{
                UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的手机网络状况不佳,请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"关闭",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [control addAction:action];
                [self presentViewController:control animated:YES completion:^{
                    
                }];
            }
            
        }];
        
    }
}

/**
 * 生成翻页控制器
 */
-(void)createPageViewController{
    
    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(1)};
    //    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options:options];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    LDMemberPageViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = CGRectMake(0, 148+4, self.view.frame.size.width, self.view.frame.size.height);
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    //
    UIButton *svipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    svipButton.tag = 21;
    [self topButtonClick:svipButton];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDMemberPageViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(LDMemberPageViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.pageContentArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

//翻页视图控制器将要翻页时执行的方法
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    _memberPageViewController = (LDMemberPageViewController *)pendingViewControllers[0];
}

//翻页动画执行完成后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (finished) {
        if (completed) {
            NSInteger index = [self.pageContentArray indexOfObject:_memberPageViewController];
            _index = index;
            [self changeLineHidden:index];
        }else{
            NSInteger index = [self.pageContentArray indexOfObject:previousViewControllers[0]];
            _index = index;
            [self changeLineHidden:index];
        }
    }
}

#pragma mark - 根据index得到对应的UIViewController

- (LDMemberPageViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        
        return nil;
    }
    LDMemberPageViewController *contentVC = self.pageContentArray[index];
    contentVC.isshow = self.isshow;
    contentVC.content = [NSString stringWithFormat:@"%lu",index];
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(LDMemberPageViewController *)viewController {
    return [viewController.content integerValue];
}

//按钮点击时间切换页面
- (IBAction)topButtonClick:(UIButton *)sender {
    
    [self changeLineHidden:sender.tag - 20];
    LDMemberPageViewController *initialViewController = [self viewControllerAtIndex:sender.tag - 20];// 得到对应页
    _index = sender.tag - 20;
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

//改变文字下细线的显示隐藏
-(void)changeLineHidden:(NSInteger)index{
    
    if (index==0) {
        [self.messageLab setHidden:YES];
        [self.chooseBtn setHidden:YES];
    }
    else
    {
        [self.messageLab setHidden:NO];
        [self.chooseBtn setHidden:NO];
    }
    
    for (int i = 0; i < _pageContentArray.count; i++) {
        
        UIView *view = (UIView *)[self.topView viewWithTag:i + 10];
        
        if (view.tag == index + 10) {
            
            view.hidden = NO;
            
        }else{
            
            view.hidden = YES;
        }
    }
}

//如果有凭证未验证则再次验证
-(void)zaiciyanzhengpingzheng{
    
    _receipt = [[NSUserDefaults standardUserDefaults] objectForKey:@"会员凭证"];
    _order_no = [[NSUserDefaults standardUserDefaults] objectForKey:@"会员订单"];
    _VIPIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"VIPIndex"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"会员凭证"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"会员订单"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"VIPIndex"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在验证,请耐心等待!";
    
    NSString *url;
    
    if ([_VIPIndex intValue] == 0) {
        
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Ping/vip_ioshooks"];
        
    }else{
        
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Ping/svip_ioshooks"];
    }
    
    NSDictionary *parameters;
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"赠送会员"] length] != 0){
        
        NSString *dalaba = [NSString new];
        
        if (self.isChoose) {
            dalaba = @"1";
        }
        else
        {
            dalaba = @"2";
        }
        
        if ([_VIPIndex intValue] == 0) {
            
            parameters = @{@"receipt":_receipt,@"order_no":_order_no,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"赠送会员"],@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"dalaba":dalaba};
            
        }else{
            
            parameters = @{@"receipt":_receipt,@"order_no":_order_no,@"vuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"赠送会员"],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"dalaba":dalaba};
        }
        
    }else{
        
        if ([_VIPIndex intValue] == 0) {
            
            parameters = @{@"receipt":_receipt,@"order_no":_order_no,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
        }else{
            
            parameters = @{@"receipt":_receipt,@"order_no":_order_no,@"vuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        }
    }
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            if ([self.VIPIndex intValue] == 0) {
                
                if (integer == 4000 && [responseObj[@"data"] intValue] == 5000) {
                    //存储失败的订单
                    [[NSUserDefaults standardUserDefaults] setObject:self.receipt forKey:@"会员凭证"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:self.order_no forKey:@"会员订单"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:self.VIPIndex forKey:@"VIPIndex"];
                }
                
            }else{
                
                if (integer == 4000 || integer == 4001) {
                    //存储失败的订单
                    [[NSUserDefaults standardUserDefaults] setObject:self.receipt forKey:@"会员凭证"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:self.order_no forKey:@"会员订单"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:self.VIPIndex forKey:@"VIPIndex"];
                    
                }
            }
            
            hud.labelText = @"验证失败";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:3];
            
        }else{
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"赠送会员"] length] != 0){
                
                hud.labelText = @"赠送成功";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:3];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"赠送会员"];
                
            }else{
                
                hud.labelText = @"购买成功";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:3];
                
                if ([self.VIPIndex intValue] == 0) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"vip"];
                    
                }else{
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"vip"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"svip"];
                }
                
                [self createInfoData];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"会员凭证"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"会员订单"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"VIPIndex"];
            
        }
    } failed:^(NSString *errorMsg) {
        hud.labelText = @"网络请求超时";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:3];
        
    }];
    
}

-(void)createHeadViewData{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getHeadAndNicknameUrl];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            
            if ([self.type isEqualToString:@"give"]) {
                
                [self.giveHeadView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
                self.giveHeadView.contentMode = UIViewContentModeScaleAspectFill;
            }else{
                
                [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
                self.headView.contentMode = UIViewContentModeScaleAspectFill;
            }
        }
    } failed:^(NSString *errorMsg) {
        
    }];

}

/**
 * 获取会员的到期时间
 */
-(void)createInfoData{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Vip/getVipOverTimeNew"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};

    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"获取会员到期时间失败~"];
            
        }else{
            
            CGRect showFrame = self.showLabel.frame;
            CGRect memberFrame = self.memberLabel.frame;
            
            if ([responseObj[@"data"][@"svip"] intValue] == 0 && [responseObj[@"data"][@"vip"] intValue] == 0) {
                
                showFrame.origin.y = 24;
                self.showLabel.frame = showFrame;
                
                memberFrame.origin.y = 58;
                self.memberLabel.frame = memberFrame;
                
                self.vipMemberLabel.hidden = YES;
                
                self.memberLabel.text = @"点亮身份标识";
                
            }else if([responseObj[@"data"][@"svip"] intValue] != 0 && [responseObj[@"data"][@"vip"] intValue] == 0){
                
                showFrame.origin.y = 24;
                self.showLabel.frame = showFrame;
                
                memberFrame.origin.y = 58;
                self.memberLabel.frame = memberFrame;
                
                self.vipMemberLabel.hidden = YES;
                
                self.memberLabel.text = [NSString stringWithFormat:@"SVIP到期时间 : %@",responseObj[@"data"][@"svipovertime"]];
                
            }else if ([responseObj[@"data"][@"svip"] intValue] == 0 && [responseObj[@"data"][@"vip"] intValue] != 0){
                
                showFrame.origin.y = 24;
                self.showLabel.frame = showFrame;
                
                memberFrame.origin.y = 58;
                self.memberLabel.frame = memberFrame;
                
                self.vipMemberLabel.hidden = YES;
                
                self.memberLabel.text = [NSString stringWithFormat:@"VIP到期时间 : %@",responseObj[@"data"][@"vipovertime"]];
                
            }else{
                
                showFrame.origin.y = 17;
                self.showLabel.frame = showFrame;
                
                memberFrame.origin.y = 65;
                self.memberLabel.frame = memberFrame;
                
                self.vipMemberLabel.hidden = NO;
                
                self.vipMemberLabel.text = [NSString stringWithFormat:@"VIP到期时间 : %@",responseObj[@"data"][@"vipovertime"]];
                self.memberLabel.text = [NSString stringWithFormat:@"SVIP到期时间 : %@",responseObj[@"data"][@"svipovertime"]];
            }
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

//请求商品
- (void)requestProductData:(NSString *)type{
    
    NSLog(@"-------------请求对应的产品信息----------------");
    
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"正在请求商品信息";
    
    NSArray *product = [[NSArray alloc] initWithObjects:type, nil];
    
    NSSet *nsset = [NSSet setWithArray:product];
    
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    
    request.delegate = self;
    
    [request start];
    
}

//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    
    if([product count] == 0){
        
        NSLog(@"--------------没有商品------------------");
        
        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有商品" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"关闭",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [control addAction:action];
        [self presentViewController:control animated:YES completion:^{
            
        }];
        
        [HUD removeFromSuperview];
        
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    //    NSLog(@"产品付费数量:%d",[product count]);
    
    SKProduct *p = nil;
    
    for (SKProduct *pro in product) {
        
        NSLog(@"%@", [pro description]);
        
        NSLog(@"%@", [pro localizedTitle]);
        
        NSLog(@"%@", [pro localizedDescription]);
        
        NSLog(@"%@", [pro price]);
        
        NSLog(@"%@", [pro productIdentifier]);
        
        if([pro.productIdentifier isEqualToString:_buttonString]){
            
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    
    HUD.labelText = @"";
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    HUD.labelText = @"请求失败";
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:3];
    
    NSLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request{
    
    NSLog(@"------------反馈信息结束-----------------");
}


//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    
    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
                
            case SKPaymentTransactionStatePurchased:
                //NSLog(@"交易完成");
                HUD.labelText = @"正在验证,请耐心等待!";
                [self completeTransaction:tran];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                
                NSLog(@"交易失败");
                [self failExchange:tran];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                
                break;
                
            default:
                break;
        }
    }
}

//交易失败
-(void)failExchange:(SKPaymentTransaction *)transaction{
    
    [HUD hide:YES];
    
    switch (transaction.error.code) {
            
        case SKErrorUnknown:
            
            NSLog(@"SKErrorUnknown");
            
            [self warning:transaction];
            
            break;
            
        case SKErrorClientInvalid:
            
            NSLog(@"SKErrorClientInvalid");
            [self warning:transaction];
            
            break;
            
        case SKErrorPaymentCancelled:
            
            NSLog(@"SKErrorPaymentCancelled");
            
            break;
            
        case SKErrorPaymentInvalid:
            
            NSLog(@"SKErrorPaymentInvalid");
            
            [self warning:transaction];
            
            break;
            
        case SKErrorPaymentNotAllowed:
            
            NSLog(@"SKErrorPaymentNotAllowed");
            
            [self warning:transaction];
            
            break;
            
        default:
            
            NSLog(@"No Match Found for error");
            
            [self warning:transaction];
            
            break;
    }
}

-(void)warning:(SKPaymentTransaction *)transaction{
    NSString *str = transaction.error.userInfo[@"NSLocalizedDescription"];
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"关闭",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [control addAction:action];
    [self presentViewController:control animated:YES completion:^{
        
    }];
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    
    //[SVProgressHUD dismiss];
    
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    
    NSString * productIdentifier = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
        
        NSString *url;
        
        if (_index == 0) {
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Ping/vip_ioshooks"];
            
        }else{
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Ping/svip_ioshooks"];
        }
        
        NSDictionary *parameters;
        
        if ([self.type isEqualToString:@"give"]){
            
            if (_index == 0) {
                
                parameters = @{@"receipt":productIdentifier,@"order_no":transaction.transactionIdentifier,@"uid":self.userID,@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                
            }else{
                
                parameters = @{@"receipt":productIdentifier,@"order_no":transaction.transactionIdentifier,@"vuid":self.userID,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            }

        }else{
            
            if (_index == 0) {
                
                parameters = @{@"receipt":productIdentifier,@"order_no":transaction.transactionIdentifier,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                
            }else{
                
                parameters = @{@"receipt":productIdentifier,@"order_no":transaction.transactionIdentifier,@"vuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            }
            
        }
        
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
            
            if (integer != 2000) {
                
                if (self.index == 0) {
                    
                    if (integer == 4000 && [responseObj[@"data"] intValue] == 5000) {
                        //存储失败的订单
                        [self cunchudingdan:transaction];
                    }
                    
                }else{
                    
                    if (integer == 4000 || integer == 4001) {
                        //存储失败的订单
                        [self cunchudingdan:transaction];
                    }
                }
                
                HUD.labelText = @"购买失败";
                HUD.removeFromSuperViewOnHide = YES;
                [HUD hide:YES afterDelay:3];
                
            }else{
                
                if ([self.type isEqualToString:@"give"]){
                    
                    self->HUD.labelText = @"赠送成功";
                    self->HUD.removeFromSuperViewOnHide = YES;
                    [self->HUD hide:YES afterDelay:3];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"赠送会员"];
                    
                }else{
                    
                    HUD.labelText = @"购买成功";
                    HUD.removeFromSuperViewOnHide = YES;
                    [HUD hide:YES afterDelay:3];
                    
                    if (_index == 0) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"vip"];
                    }else{
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"svip"];
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"vip"];
                    }
                    [self createInfoData];
                }
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"会员凭证"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"会员订单"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"VIPIndex"];
            }
        } failed:^(NSString *errorMsg) {
            HUD.labelText = @"网络异常,购买失败";
            HUD.removeFromSuperViewOnHide = YES;
            [HUD hide:YES afterDelay:3];
        }];
    }
}

//存储失败的订单
-(void)cunchudingdan:(SKPaymentTransaction *)transaction{
    
    if ([self.type isEqualToString:@"give"]){
        [[NSUserDefaults standardUserDefaults] setObject:self.userID forKey:@"赠送会员"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"赠送会员"];
    }
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    NSString * productIdentifier = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    [[NSUserDefaults standardUserDefaults] setObject:productIdentifier forKey:@"会员凭证"];
    [[NSUserDefaults standardUserDefaults] setObject:transaction.transactionIdentifier forKey:@"会员订单"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",_index] forKey:@"VIPIndex"];
}

- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (IBAction)giveHeadClick:(id)sender {
    
    LDOwnInformationViewController *fvc = [[LDOwnInformationViewController alloc] init];
    fvc.userID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
    [self.navigationController pushViewController:fvc animated:YES];
}

- (IBAction)givedHeadClick:(id)sender {
    
    LDOwnInformationViewController *fvc = [[LDOwnInformationViewController alloc] init];
    fvc.userID = [NSString stringWithFormat:@"%@",self.userID];
    [self.navigationController pushViewController:fvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
