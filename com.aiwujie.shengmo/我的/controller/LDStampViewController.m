//
//  LDStampViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDStampViewController.h"
#import "LDDetailPageViewController.h"
#import "LDDynamicViewController.h"
#import "LDSetViewController.h"
#import "LDShareView.h"
#import "StampCell.h"
#import <StoreKit/StoreKit.h>
#import <AFNetworkReachabilityManager.h>
#import "AppDelegate.h"
#import "LDMemberViewController.h"
#import "LDCertificateViewController.h"
#import "LDBillPresenter.h"

@interface LDStampViewController ()<UITableViewDelegate,UITableViewDataSource,SKPaymentTransactionObserver,SKProductsRequestDelegate,SKStoreProductViewControllerDelegate,SDCycleScrollViewDelegate>{
    
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UIView *headView;

@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic,strong)  NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIView *fourView;
@property (weak, nonatomic) IBOutlet UIView *fiveView;
@property (weak, nonatomic) IBOutlet UIView *sixView;
@property (weak, nonatomic) IBOutlet UIView *sevenView;
@property (weak, nonatomic) IBOutlet UIView *eightView;
@property (weak, nonatomic) IBOutlet UIView *nineView;

//选择了哪个充值选项,用来存储内购
@property (nonatomic,strong)  NSArray *shopArray;
@property (nonatomic,copy) NSString *subject;

//选择了哪个充值选项,用来存储魔豆购买
@property (nonatomic,strong)  NSArray *numArray;
@property (nonatomic,copy) NSString *num;

@property (weak, nonatomic) IBOutlet UILabel *walletLabel;
//获赠邮票的label
@property (weak, nonatomic) IBOutlet UILabel *getFreeStampLabel;

//男票,女票,CD票
@property (nonatomic,copy) NSString *basicstampX;
@property (weak, nonatomic) IBOutlet UILabel *basicstampXLabel;
@property (nonatomic,copy) NSString *basicstampY;
@property (weak, nonatomic) IBOutlet UILabel *basicstampYLabel;
@property (nonatomic,copy) NSString *basicstampZ;
@property (weak, nonatomic) IBOutlet UILabel *basicstampZLabel;

//发布动态数
@property (nonatomic,copy) NSString *senddynamic;
//评论动态数
@property (nonatomic,copy) NSString *commentdynamic;
//点赞动态数
@property (nonatomic,copy) NSString *lauddynamic;
//分享动态数
@property (nonatomic,copy) NSString *shareapp;
//送礼物魔豆数
@property (nonatomic,copy) NSString *rewarddynamic;
//appstore好评
@property (nonatomic,copy) NSString *commentappstate;
//绑定手机号
@property (nonatomic,copy) NSString *mobile;
//普通用户每日的领取状态
@property (nonatomic,copy) NSString *narmaluser;
//会员用户的每日领取状态
@property (nonatomic,copy) NSString *vipuser;
@property (nonatomic,assign) NSInteger index;

//是否显示广告
@property (nonatomic,assign) BOOL isshowadvertising;
//广告展示的数组数据
@property (nonatomic,strong) NSMutableArray *slideArray;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,copy) NSString *buyUrl;
@property (nonatomic,assign) BOOL isshowapplePay;
@end

@implementation LDStampViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _dataArray = @[@[@"认证用户每日可领取3张邮票",@"VIP会员每日可领取3张邮票"],@[@"每日动态点赞20个赠3张邮票",@"每日动态评论5条赠3张邮票",@"每日发布2篇动态赠3张邮票",@"每日分享APP一次赠3张邮票",@"每日送礼物单次满100魔豆赠3张邮票"],@[@"绑定手机号赠9张邮票",@"应用商店好评赠9张邮票"],@[]];
    self.slideArray = [NSMutableArray array];
    _dataArray = @[@[@"认证用户每日可领取3张邮票",@"VIP会员每日可领取3张邮票"],@[@"每日动态点赞20个赠3张邮票",@"每日分享APP一次赠3张邮票",@"每日送礼物单次满100魔豆赠3张邮票"],@[@"绑定手机号赠9张邮票",@"应用商店好评赠9张邮票"],@[]];
    
//    _shopArray = @[@"stamp1",@"stamp2",@"stamp3",@"stamp4",@"stamp5",@"stamp6",@"stamp7",@"stamp8",@"stamp9"];
    _shopArray = @[@"you1",@"you2",@"you3",@"you4",@"you5",@"you6",@"you7",@"you8",@"you9"];
    
    _numArray = @[@"3",@"7",@"11",@"23",@"38",@"65",@"105",@"200",@"385"];
    
    self.title = @"消息邮票";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createRightButton];
    
    [self createTableView];
    
    //有凭证未验证则再次验证
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"邮票凭证"] length] != 0) {
        [self zaiciyanzhengpingzheng];
    }
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    for (int i = 0; i < 9; i++) {
        
        UIButton *button = (UIButton *)[self.view viewWithTag:30 + i];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1].CGColor;
        button.layer.cornerRadius = 2;
        button.clipsToBounds = YES;
        
        UILabel *priceLabel = (UILabel *)[self.view viewWithTag:i + 10];
        
        priceLabel.textColor = [UIColor blackColor];
        
        UILabel *label = (UILabel *)[self.view viewWithTag:i + 20];
        
        label.textColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1];
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self iscanexchange];
    [self isshowbuttons];
    [self isshowapplepayClick];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self createData];
    [LDBillPresenter savewakketNum];
}

-(void)isshowapplepayClick
{
    NSString *url = [PICHEADURL stringByAppendingString:@"api/power/appleInnerPayState"];
    [NetManager afPostRequest:url parms:nil finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSDictionary *data = [responseObj objectForKey:@"data"];
            NSString *state = [NSString stringWithFormat:@"%@",[data objectForKey:@"state"]];
            if ([state intValue]==1) {
                self.isshowapplePay = YES;
            }
            else
            {
                self.isshowapplePay = NO;
            }
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)createData{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getStampPageInfoUrl];
    NSDictionary *parameters;
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
        }else{
            
            _walletLabel.text = [NSString stringWithFormat:@"共购买 %@ 张通用邮票(永久有效)",responseObj[@"data"][@"wallet_stamp"]];
            [self changeWordColorTitle:_walletLabel.text andLoc:4 andLen:[responseObj[@"data"][@"wallet_stamp"] length] andLabel:_walletLabel];
            
            _basicstampX = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"basicstampX"]];
            _basicstampY = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"basicstampY"]];
            _basicstampZ = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"basicstampZ"]];
            _getFreeStampLabel.text = [NSString stringWithFormat:@"共获赠 %d 张任务邮票(当日有效)",[_basicstampX intValue] + [_basicstampY intValue] + [_basicstampZ intValue]];
            [self changeWordColorTitle:_getFreeStampLabel.text andLoc:4 andLen:[[NSString stringWithFormat:@"%d",[_basicstampX intValue] + [_basicstampY intValue] + [_basicstampZ intValue]] length] andLabel:_getFreeStampLabel];
            
            _basicstampXLabel.text = [NSString stringWithFormat:@"男票 %@ 张",responseObj[@"data"][@"basicstampX"]];
            _basicstampYLabel.text = [NSString stringWithFormat:@"女票 %@ 张",responseObj[@"data"][@"basicstampY"]];
            _basicstampZLabel.text = [NSString stringWithFormat:@"CDTS票 %@ 张",responseObj[@"data"][@"basicstampZ"]];
            [self changeWordColorTitle:_basicstampXLabel.text andLoc:3 andLen:_basicstampX.length andLabel:_basicstampXLabel];
            [self changeWordColorTitle:_basicstampYLabel.text andLoc:3 andLen:_basicstampY.length andLabel:_basicstampYLabel];
            [self changeWordColorTitle:_basicstampZLabel.text andLoc:6 andLen:_basicstampZ.length andLabel:_basicstampZLabel];
            
            _lauddynamic = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"lauddynamic"]];
            _commentdynamic = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"commentdynamic"]];
            _senddynamic = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"senddynamic"]];
            _shareapp = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"shareapp"]];
            _rewarddynamic = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"rewarddynamic"]];
            
            _commentappstate = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"commentappstate"]];
            _mobile = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"mobile"]];
            
            _narmaluser = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"narmaluser"]];
            _vipuser = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"vipuser"]];
            
            [self.tableView reloadData];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
    
}

//更改某个字体的颜色
-(void)changeWordColorTitle:(NSString *)str andLoc:(NSUInteger)loc andLen:(NSUInteger)len andLabel:(UILabel *)attributedLabel{
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:157/255.0 blue:0/255.0 alpha:1] range:NSMakeRange(loc,len)];
    attributedLabel.attributedText = attributedStr;
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
    NSString *newURL = [NSString stringWithFormat:@"%@?uid=%@",self.buyUrl,[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"]];
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
            self.tableView.frame = CGRectMake(0, ADVERTISEMENT, WIDTH, [self getIsIphoneX:ISIPHONEX]-ADVERTISEMENT);
            
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
            
        }
        else
        {
   
            self.tableView.frame = CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]);
        }
    } failed:^(NSString *errorMsg) {

        self.tableView.frame = CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]);
    }];
}

-(void)deleteButtonClick
{
    [self.cycleScrollView removeFromSuperview];
    [self.deleteButton removeFromSuperview];
    self.tableView.frame = CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]);
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

-(void)rightButtonOnClic{
    LDDetailPageViewController *pvc = [[LDDetailPageViewController alloc] init];
    pvc.index = 2;
    [self.navigationController pushViewController:pvc animated:YES];
}

//如果有凭证未验证则再次验证
-(void)zaiciyanzhengpingzheng{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在验证,请耐心等待!";
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,stamp_ioshooks];
    
    NSDictionary *parameters = @{@"receipt":[[NSUserDefaults standardUserDefaults] objectForKey:@"邮票凭证"],@"order_no":[[NSUserDefaults standardUserDefaults] objectForKey:@"邮票订单"],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            hud.labelText = @"验证失败";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:3];
            
        }else{
            
            hud.labelText = @"购买成功";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:3];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"邮票凭证"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"邮票订单"];
            [self createData];
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}


-(void)buttonClick:(UIButton *)button{
    
    for (int i = 0; i < 9; i++) {
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:30 + i];
        
        if (btn.tag == button.tag) {
            
            button.layer.borderWidth = 1;
            button.layer.borderColor = MainColor.CGColor;
            button.layer.cornerRadius = 2;
            button.clipsToBounds = YES;
            
            UILabel *priceLabel = (UILabel *)[self.view viewWithTag:button.tag - 20];
            
            priceLabel.textColor = MainColor;
            
            UILabel *label = (UILabel *)[self.view viewWithTag:button.tag - 10];
            
            label.textColor = MainColor;
            
            _subject = _shopArray[i];
            
            _num = _numArray[i];
            self.index = i;
        }else{
            
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1].CGColor;
            btn.layer.cornerRadius = 2;
            btn.clipsToBounds = YES;
            
            UILabel *priceLabel = (UILabel *)[self.view viewWithTag:i + 10];
            
            priceLabel.textColor = [UIColor blackColor];
            
            UILabel *label = (UILabel *)[self.view viewWithTag:i + 20];
            
            label.textColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1];
        }
    }
    [self createAlertViewController];
}

-(void)createAlertViewController{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction * action = [UIAlertAction actionWithTitle:@"苹果内购" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"邮票凭证"] length] != 0) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您有支付凭证验证失败,暂时不能购买邮票,请退出本页面后重新进入验证或联系客服"];
            
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
                        
                        [self requestProductData:self.subject];
                        
                    }else{
                        
                        NSLog(@"不允许程序内付费");
            
                        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的手机没有打开程序内付费购买" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        [control addAction:cancelAction];
                        [self presentViewController:control animated:YES completion:^{
                            
                        }];
                    }
                    
                }else{
                    
                    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的手机网络状况不佳,请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [control addAction:cancelAction];
                    [self presentViewController:control animated:YES completion:^{
                        
                    }];
                }
                
            }];
            
        }

        
    }];
    
//    UIAlertAction *shengmoBuy = [UIAlertAction actionWithTitle:@"官方充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self shengmobuyClick];
//    }];
    
    NSString *numStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"walletNum"];
    UIAlertAction *exchange = [UIAlertAction actionWithTitle:@"魔豆兑换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *newStr = @"";
        if (numStr.length==0) {
            newStr = @"0";
        }
        else
        {
            newStr = numStr;
        }
        NSArray *TopcardArray = @[[NSString stringWithFormat:@"%@%@%@",@"(剩余",newStr,@"金魔豆)"],@"3张/60金魔豆",@"10张/200金魔豆", @"30张/600金魔豆",@"50张/1000金魔豆", @"100张/2000金魔豆", @"300张/6000金魔豆"];
        
        UIAlertController *VIPAlert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (int i = 0; i < TopcardArray.count; i++) {
            UIAlertAction *month = [UIAlertAction actionWithTitle:TopcardArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (i==0) {
           
                    NSString *newURL = [NSString stringWithFormat:@"%@?uid=%@",self.buyUrl,[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
                    JXBWebViewController *webVC = [[JXBWebViewController alloc] initWithURLString:newURL];
                    webVC.title = @"官方充值";
                    [self.navigationController pushViewController:webVC animated:YES];
                }
                
                if (i!=0) {
                    NSArray *array = @[@"3",@"10",@"30",@"50",@"100",@"300"];
                    NSArray *beansarray = @[@"60",@"200",@"600",@"1000",@"2000",@"6000"];
                    NSString *urlString = [NSString stringWithFormat:@"%@%@",PICHEADURL,stamp_baansUrl];
                    __block NSString *beans = @"";
                    __block NSString *numStr = @"";
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        if (idx==i) {
                            beans =[beansarray objectAtIndex:idx-1];
                            numStr=[array objectAtIndex:idx-1];
                            *stop = YES;
                        }
                        
                    }];
                    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"num":numStr, @"channel":@"0",@"beans":beans?:@""};
                    [self startExchangeWithUrl:urlString parameters:parameters];
                }
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
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
    
        [action setValue:MainColor forKey:@"_titleTextColor"];
        [cancel setValue:MainColor forKey:@"_titleTextColor"];
        [exchange setValue:MainColor forKey:@"_titleTextColor"];
       // [shengmoBuy setValue:MainColor forKey:@"_titleTextColor"];
    }
    
    if (self.isshowadvertising) {
        //[alert addAction:shengmoBuy];
        [alert addAction:exchange];
    }
    [alert addAction:cancel];
    if (self.isshowapplePay) {
        [alert addAction:action];
    }
    [self presentViewController:alert animated:YES completion:nil];
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
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [control addAction:cancelAction];
        [self presentViewController:control animated:YES completion:^{
            
        }];
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
        
        if([pro.productIdentifier isEqualToString:_subject]){
            
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    
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
                NSLog(@"交易完成");
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
    
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:transaction.error.userInfo[@"NSLocalizedDescription"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [control addAction:cancelAction];
    [self presentViewController:control animated:YES completion:^{
        
    }];
    
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");

    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    
    NSString * productIdentifier = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
        
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,stamp_ioshooks];
        NSDictionary *parameters = @{@"receipt":productIdentifier,@"order_no":transaction.transactionIdentifier,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
            
            if (integer != 2000) {
                
                //验证失败,存储本次购买的订单
                [self cunchudingdan:transaction];
                
                self->HUD.labelText = @"购买失败";
                self->HUD.removeFromSuperViewOnHide = YES;
                [self->HUD hide:YES afterDelay:3];
                
            }else{
                
                
                self->HUD.labelText = @"购买成功";
                self->HUD.removeFromSuperViewOnHide = YES;
                [self->HUD hide:YES afterDelay:3];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"邮票凭证"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"邮票订单"];
                
                [self createData];
                
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }
}

//验证失败,存储本次购买的订单
-(void)cunchudingdan:(SKPaymentTransaction *)transaction{
    
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    NSString * productIdentifier = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    [[NSUserDefaults standardUserDefaults] setObject:productIdentifier forKey:@"邮票凭证"];
    [[NSUserDefaults standardUserDefaults] setObject:transaction.transactionIdentifier forKey:@"邮票订单"];
}

-(void)dealloc{

    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = _headView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StampCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Stamp"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"StampCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = [NSString stringWithFormat:@"· %@",_dataArray[indexPath.section][indexPath.row]];
    if (indexPath.section == 0) {
        cell.numLabel.text = @"男/女/CDTS票各1张";
        cell.completeLabel.hidden = YES;
        if (indexPath.row == 0) {
            cell.lineView.hidden = NO;
            if ([_narmaluser intValue] == 0) {
                [self goComplete:cell andTitle:@"领取"];
            }else{
                [self didComplete:cell andTitle:@"已领取"];
            }
        }else if(indexPath.row == 1){
            cell.lineView.hidden = YES;
            if ([_vipuser intValue] == 0) {
                [self goComplete:cell andTitle:@"领取"];
            }else{
                [self didComplete:cell andTitle:@"已领取"];
            }
        }
    }else if (indexPath.section == 1) {
        cell.numLabel.text = @"男/女/CDTS票各1张";
        cell.completeLabel.hidden = NO;
        if (indexPath.row == 4) {
            cell.lineView.hidden = YES;
        }else{
            cell.lineView.hidden = NO;
        }
        if (indexPath.row == 0) {
            if ([_lauddynamic intValue] >= 20) {
                [self didComplete:cell andTitle:@"已完成"];
                cell.completeLabel.text = [NSString stringWithFormat:@"20/20"];
            }else{
                [self goComplete:cell andTitle:@"去完成"];
                cell.completeLabel.text = [NSString stringWithFormat:@"%@/20",_lauddynamic];
            }
        }
        else if (indexPath.row == 1){
            if ([_shareapp intValue] >= 1) {
                [self didComplete:cell andTitle:@"已完成"];
                cell.completeLabel.text = [NSString stringWithFormat:@"1/1"];
            }else{
               [self goComplete:cell andTitle:@"去完成"];
                cell.completeLabel.text = [NSString stringWithFormat:@"%@/1",_shareapp];
            }
        }else if (indexPath.row == 2){
            if ([_rewarddynamic intValue] >= 1) {
                [self didComplete:cell andTitle:@"已完成"];
                cell.completeLabel.text = [NSString stringWithFormat:@"1/1"];
            }else{
                [self goComplete:cell andTitle:@"去完成"];
                cell.completeLabel.text = [NSString stringWithFormat:@"%@/1",_rewarddynamic];
            }
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 1) {
            if ([_commentappstate intValue] == 0) {
                [self goComplete:cell andTitle:@"去完成"];
            }else{
                [self didComplete:cell andTitle:@"已完成"];
            }
            cell.lineView.hidden = YES;
        }else{
            if (_mobile.length == 0) {
                [self goComplete:cell andTitle:@"去完成"];
            }else{
                [self didComplete:cell andTitle:@"已完成"];
            }
            cell.lineView.hidden = NO;
        }
        cell.numLabel.text = @"男/女/CDTS票各3张";
        cell.completeLabel.hidden = YES;
    }
    [self changeWordColorTitle:cell.nameLabel.text andLoc:[cell.nameLabel.text length] - 4 andLen:2 andLabel:cell.nameLabel];
    [cell.goButton addTarget:self action:@selector(goButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
/**
 * 去完成按钮设置
 */
-(void)goComplete:(StampCell *)cell andTitle:(NSString *)buttonTitle{
    
    [cell.goButton setTitle:buttonTitle forState:UIControlStateNormal];
    [cell.goButton setTitleColor:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1] forState:UIControlStateNormal];
    cell.goButton.backgroundColor = [UIColor clearColor];
    cell.goButton.userInteractionEnabled = YES;
}
/**
 * 已完成按钮设置
 */
-(void)didComplete:(StampCell *)cell andTitle:(NSString *)buttonTitle{
    
    [cell.goButton setTitle:buttonTitle forState:UIControlStateNormal];
    [cell.goButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cell.goButton.backgroundColor = [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1];
    cell.goButton.userInteractionEnabled = NO;
}

-(void)goButtonClick:(UIButton *)button{

    StampCell *cell = (StampCell *)button.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"realname"] intValue] == 1) {
                
                //领取邮票
                [self userGetBasicStamp:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Restrict/narmalUserGetBasicStamp"]];

            }else{
                
                NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/getidstate"];
                
                NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                
                [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
                    NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
                    
                    if (integer == 2000) {
                        
                        //领取邮票
                        [self userGetBasicStamp:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Restrict/narmalUserGetBasicStamp"]];
                        
                    }else if(integer == 2001){
                        
                        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"正在审核,请耐心等待审核通过后领取~"];
                        
                        
                        
                    }else if (integer == 2002){
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"限认证用户免费领取~"    preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction * action = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                            
                            LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                            
                            cvc.where = @"4";
                            
                            [self.navigationController pushViewController:cvc animated:YES];
                            
                        }];
                        
                        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
                        
                        [alert addAction:cancelAction];
                        
                        [alert addAction:action];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                } failed:^(NSString *errorMsg) {
                    
                }];

            }

        }else if (indexPath.row == 1){
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1) {
                
                //领取邮票
                [self userGetBasicStamp:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Restrict/vipUserGetBasicStamp"]];
            
            }else{
            
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"限VIP会员免费领取~"    preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                    
                    LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                    
                    [self.navigationController pushViewController:mvc animated:YES];
                }];
                
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
                
                [alert addAction:cancelAction];
                
                [alert addAction:action];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        
    }else if (indexPath.section == 1) {
        
//        if (indexPath.row == 0  || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4) {
//
//           self.tabBarController.selectedIndex = 3;
//
//           [self.navigationController popToRootViewControllerAnimated:YES];
//
//        }else{
//
//            self.tabBarController.selectedIndex = 4;
//
//            [self.navigationController popViewControllerAnimated:YES];
//        }
        if (indexPath.row == 0 || indexPath.row == 2) {
            
            self.tabBarController.selectedIndex = 3;
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            
            self.tabBarController.selectedIndex = 4;
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if(indexPath.section == 2){
    
        if (indexPath.row == 0) {
            
            LDSetViewController *svc = [[LDSetViewController alloc] init];
            
            [self.navigationController pushViewController:svc animated:YES];
            
        }else if (indexPath.row == 1){
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
            SKStoreProductViewController *storeProductVC =[[SKStoreProductViewController alloc] init];
            storeProductVC.delegate = self;
            //第一个参数为应用标识id构成的字典。第二个参数是一个block回调。
            [storeProductVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@"1481034369"} completionBlock:^(BOOL result, NSError *error) {
                
                if (result) {
                    
                    [self presentViewController:storeProductVC animated:YES completion:^{
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];

                    }];
                    
                }else{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"跳转失败" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [control addAction:cancelAction];
                    [self presentViewController:control animated:YES completion:^{
                        
                    }];
                    
                }
            }];
        }
    }
}

/**
 * 领取邮票
 */
-(void)userGetBasicStamp:(NSString *)url{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            
            [self createData];
            
        }
        
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

//SKStoreProductViewController代理方法
-(void)productViewControllerDidFinish:(SKStoreProductViewController*)viewController

{
    //返回上一个页面
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getCMAppStamp"];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
        }else{
            [self createData];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    
    view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    
    if (section == 0) {
        
        label.text = @"    限时体验⭐️免费领邮票";
        
    }else if (section == 1) {
        
        label.text = @"    每日任务⭐️免费领邮票";
        
    }else if(section == 2){
    
        label.text = @"    单次任务⭐️免费领邮票";
    }
    
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
