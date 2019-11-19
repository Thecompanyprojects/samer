//
//  LDtotopViewController.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/10.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDtotopViewController.h"
#import "LdtotopCell.h"
#import "LdtopHeaderView.h"
#import "LDDetailPageViewController.h"
#import "YQInAppPurchaseTool.h"
#import "LDBillPresenter.h"


@interface LDtotopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,YQInAppPurchaseToolDelegate,SDCycleScrollViewDelegate>
{
    MBProgressHUD *hud;
}
@property (nonatomic,strong)  UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *shopArray;
@property (nonatomic,copy) NSString *numberStr;
@property (nonatomic,strong) LdtopHeaderView *headView;
@property (nonatomic,strong) UILabel *messageLab;

//是否显示广告
@property (nonatomic,assign) BOOL isshowadvertising;
//广告展示的数组数据
@property (nonatomic,strong) NSMutableArray *slideArray;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,copy) NSString *buyUrl;
@property (nonatomic,assign) BOOL isshowapplePay;
@end

static NSString *ldtopidentfid = @"ldtopidentfid";

static float AD_height = 180;//头部高度

#define W_screen [UIScreen mainScreen].bounds.size.width/375.0

@implementation LDtotopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动态推顶";
//    self.shopArray = [NSMutableArray arrayWithObjects:@"topcard10",@"topcard12",@"topcard13",@"topcard14",@"topcard5",@"topcard6", nil];

    self.shopArray = [NSMutableArray arrayWithObjects:@"tui1",@"tui2",@"tui3",@"tui4",@"tui5",@"tui6", nil];
    
    //获取单例
    YQInAppPurchaseTool *IAPTool = [YQInAppPurchaseTool defaultTool];
    //设置代理
    IAPTool.delegate = self;
    //购买后，向苹果服务器验证一下购买结果。默认为YES。不建议关闭
    IAPTool.CheckAfterPay = NO;
    //向苹果询问哪些商品能够购买
    [IAPTool requestProductsWithProductArray:self.shopArray];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.messageLab];
    [self createRightButton];
    [self createData];
    [LDBillPresenter savewakketNum];
    self.slideArray = [NSMutableArray array];
    [self iscanexchange];
    [self isshowbuttons];
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
            self.collectionView.frame = CGRectMake(0, ADVERTISEMENT, WIDTH, [self getIsIphoneX:ISIPHONEX]-ADVERTISEMENT);
            
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
            
            if (ISIPHONEX) {
                self.messageLab.frame = CGRectMake(20, HEIGHT-34-240-IPHONEXTOPH+ADVERTISEMENT, WIDTH-40, 32);
            }
            else
            {
                self.messageLab.frame = CGRectMake(20, HEIGHT-64-180*W_screen+ADVERTISEMENT, WIDTH-40, 32);
            }
        }
        else
        {
  
            self.collectionView.frame = CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]);
        }
    } failed:^(NSString *errorMsg) {

        self.collectionView.frame = CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]);
    }];
}

-(void)deleteButtonClick
{
    [self.cycleScrollView removeFromSuperview];
    [self.deleteButton removeFromSuperview];
    self.collectionView.frame = CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]);
    if (ISIPHONEX) {
        self.messageLab.frame = CGRectMake(20, HEIGHT-34-240-IPHONEXTOPH, WIDTH-40, 32);
    }
    else
    {
        self.messageLab.frame = CGRectMake(20, HEIGHT-64-180*W_screen, WIDTH-40, 32);
    }
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

-(void)createData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *url = [PICHEADURL stringByAppendingString:getTopcardPageInfo];
    NSDictionary *para = @{@"uid":uid?:@""};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSDictionary *data = [responseObj objectForKey:@"data"];
            self.numberStr = [data objectForKey:@"wallet_topcard"];
           
        }
        [self.headView setTextFromurl:self.numberStr?:@"0"];
        [self.collectionView reloadData];
 
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)createRightButton{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightButton setTitle:@"明细" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonOnClic) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

#pragma mark - 创建collectionView并设置代理

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        
        CGFloat naviBottom = HEIGHT;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.headerReferenceSize = CGSizeMake(WIDTH, AD_height);//头部大小
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, naviBottom - 50) collectionViewLayout:flowLayout];
        _collectionView.scrollEnabled = YES;
        flowLayout.itemSize = CGSizeMake(106*W_screen, 100*W_screen); 
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumLineSpacing = 14;
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(12, 16*W_screen, 2, 16*W_screen);//上左下右
        //注册cell和ReusableView（相当于头部）
        [_collectionView registerClass:[LdtotopCell class] forCellWithReuseIdentifier:ldtopidentfid];
        [_collectionView registerClass:[LdtopHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //背景颜色
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5" alpha:1];
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

#pragma mark 每个UICollectionView展示的内容

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LdtotopCell *cell = (LdtotopCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ldtopidentfid forIndexPath:indexPath];
    [cell sizeToFit];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [cell setDatafromIndex:indexPath.item];
    return cell;
}

#pragma mark 头部显示的内容

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    self.headView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                        UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
    self.headView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5" alpha:1];
    return self.headView;
}

#pragma mark UICollectionView被选中时调用的方法

//点击选定
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LdtotopCell *cell = (LdtotopCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = MainColor.CGColor;
    NSLog(@"第%ld区，第%ld个",(long)indexPath.section,(long)indexPath.row);
    UIAlertController *control = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"苹果内购" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *shopId = [self.shopArray objectAtIndex:indexPath.item];
        
        [[YQInAppPurchaseTool defaultTool]buyProduct:shopId];

        hud = [MBProgressHUD showActivityMessage:@"购买中..."];
        
    }];
    NSString *numStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"walletNum"];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"魔豆兑换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        NSString *newStr = @"";
        if (numStr.length==0) {
            newStr = @"0";
        }
        else
        {
            newStr = numStr;
        }
        NSArray *TopcardArray = @[@"1张/300金魔豆", @"3张/860金魔豆(9.5折)", @"10张/2700金魔豆(9.1折)", @"30张/7650金魔豆(8.6折)", @"90张/21600金魔豆(8折)", @"270张/60750金魔豆(7.5折)"];
        
        NSString *titleStr0 = [NSString stringWithFormat:@"%@%@%@",@"(剩余",newStr,@"金魔豆)"];
        NSString *titlestr1 = [TopcardArray objectAtIndex:indexPath.item];
        NSArray *array = @[@"1",@"3",@"10",@"30",@"90",@"270"];
        NSString *numStr = [array objectAtIndex:indexPath.item];
        
        UIAlertController *VIPAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

        UIAlertAction *titleAction = [UIAlertAction actionWithTitle:titleStr0 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *newURL = [NSString stringWithFormat:@"%@?uid=%@",self.buyUrl,[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
            JXBWebViewController *webVC = [[JXBWebViewController alloc] initWithURLString:newURL];
            webVC.title = @"官方充值";
            [self.navigationController pushViewController:webVC animated:YES];
        }];

        UIAlertAction *buyAction = [UIAlertAction actionWithTitle:titlestr1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *urlString = [PICHEADURL stringByAppendingString:topcard_baansUrl];
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            NSDictionary *parameters = @{@"uid":uid,@"num":numStr,@"channel":@"0"};
            [self startExchangeWithUrl:urlString parameters:parameters];
        }];
        
        [VIPAlert addAction:titleAction];
        [VIPAlert addAction:buyAction];
        [self cancelActionWithAlert:VIPAlert];
        if (PHONEVERSION.doubleValue >= 8.3) {
            [titleAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
            [buyAction setValue:MainColor forKey:@"_titleTextColor"];
        }
        [self presentViewController:VIPAlert animated:YES completion:nil];
    }];
    
//    UIAlertAction *shengmoBuy = [UIAlertAction actionWithTitle:@"官方充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self shengmobuyClick];
//    }];
    
    [control addAction:action0];
    if (self.isshowadvertising) {
       // [control addAction:shengmoBuy];
        [control addAction:action2];
    }
    if (self.isshowapplePay) {
        [control addAction:action1];
    }
    if (PHONEVERSION.doubleValue >= 8.3) {
        [action0 setValue:MainColor forKey:@"_titleTextColor"];
        [action1 setValue:MainColor forKey:@"_titleTextColor"];
        [action2 setValue:MainColor forKey:@"_titleTextColor"];
       // [shengmoBuy setValue:MainColor forKey:@"_titleTextColor"];
    }
    [self presentViewController:control animated:YES completion:nil];
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


//取消选定
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    LdtotopCell *cell = (LdtotopCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    NSLog(@"1第%ld区，1第%ld个",(long)indexPath.section,(long)indexPath.row);
}

#pragma mark - RightBtn

-(void)rightButtonOnClic
{
    LDDetailPageViewController *VC = [LDDetailPageViewController new];
    VC.index = 3;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark --------YQInAppPurchaseToolDelegate
//IAP工具已获得可购买的商品
-(void)IAPToolGotProducts:(NSMutableArray *)products {
    NSLog(@"GotProducts:%@",products);
    
}

//支付失败/取消
-(void)IAPToolCanceldWithProductID:(NSString *)productID {
    NSLog(@"canceld:%@",productID);
    [hud hide:YES];
    [MBProgressHUD showMessage:@"取消购买"];
}

//支付成功了，并开始向苹果服务器进行验证（若CheckAfterPay为NO，则不会经过此步骤）
-(void)IAPToolBeginCheckingdWithProductID:(NSString *)productID {
    NSLog(@"BeginChecking:%@",productID);
    
    //[SVProgressHUD showWithStatus:@"购买成功，正在验证购买"];
    
}
//商品被重复验证了
-(void)IAPToolCheckRedundantWithProductID:(NSString *)productID {
    NSLog(@"CheckRedundant:%@",productID);
    
}
//商品完全购买成功且验证成功了。（若CheckAfterPay为NO，则会在购买成功后直接触发此方法）
-(void)IAPToolBoughtProductSuccessedWithProductID:(NSString *)productID
                                          andInfo:(NSDictionary *)infoDic {
    NSLog(@"BoughtSuccessed:%@",productID);
    NSLog(@"successedInfo:%@",infoDic);

    NSString *receipt = [infoDic objectForKey:@"receipe"];
    NSString *order = [infoDic objectForKey:@"order"];
    NSString *url = [PICHEADURL stringByAppendingString:topcard_ioshooks];

    NSDictionary *parameters = @{@"receipt":receipt?:@"",@"order_no":order?:@"",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};

    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [hud hide:YES];
            [MBProgressHUD showMessage:@"购买失败"];
        }else{
            [hud hide:YES];
            [MBProgressHUD showMessage:@"购买成功"];
            [self createData];
        }
    } failed:^(NSString *errorMsg) {
        [hud hide:YES];
        [MBProgressHUD showMessage:@"服务器验证失败"];
    }];
}

//商品购买成功了，但向苹果服务器验证失败了
//2种可能：
//1，设备越狱了，使用了插件，在虚假购买。
//2，验证的时候网络突然中断了。（一般极少出现，因为购买的时候是需要网络的）
-(void)IAPToolCheckFailedWithProductID:(NSString *)productID
                               andInfo:(NSData *)infoData {
    NSLog(@"CheckFailed:%@",productID);

    [hud hide:YES];
    [MBProgressHUD showMessage:@"服务器验证失败"];
}

//恢复了已购买的商品（仅限永久有效商品）
-(void)IAPToolRestoredProductID:(NSString *)productID {
    NSLog(@"Restored:%@",productID);
}

//内购系统错误了
-(void)IAPToolSysWrong {
    NSLog(@"SysWrong");

    [hud hide:YES];
    [MBProgressHUD showMessage:@"系统出错了"];
}

-(UILabel *)messageLab
{
    if(!_messageLab)
    {
        _messageLab = [[UILabel alloc] init];
        if (ISIPHONEX) {
            _messageLab.frame = CGRectMake(20, HEIGHT-34-240-IPHONEXTOPH, WIDTH-40, 32);
        }
        else
        {
            _messageLab.frame = CGRectMake(20, HEIGHT-64-180*W_screen, WIDTH-40, 32);
        }
        _messageLab.textColor = TextCOLOR;
        _messageLab.font = [UIFont systemFontOfSize:13];
        _messageLab.numberOfLines = 0;
        _messageLab.text = @"“推顶卡”可将动态推至最顶部，获得更多浏览、评论、点赞。同时还可以增加相应的魅力值~";
        [_messageLab sizeToFit];
    }
    return _messageLab;
}


@end
