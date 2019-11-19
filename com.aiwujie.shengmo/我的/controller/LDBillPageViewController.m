//
//  LDBillPageViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/24.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDBillPageViewController.h"
#import "LDBillViewController.h"

@interface LDBillPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDBillViewController *billViewController;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@end

@implementation LDBillPageViewController

#pragma mark - Lazy Load

- (NSArray *)pageContentArray {
    if (!_pageContentArray) {
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        
        LDBillViewController *v1 = [[LDBillViewController alloc] init];
        LDBillViewController *v2 = [[LDBillViewController alloc] init];
        v1.isfromVip = self.isfromVip;
        v2.isfromVip = self.isfromVip;
        [arrayM addObject:v1];
        [arrayM addObject:v2];
        
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
        
    }
    return _pageContentArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.isfromVip) {
        self.navigationItem.title = @"会员明细";
        [self.rightBtn setTitle:@"获赠记录" forState:normal];
        [self.leftBtn setTitle:@"购买记录" forState:normal];
    }
    else
    {
        self.navigationItem.title = @"充值明细";
    }
    //生成翻页控制器
    [self createPageViewController];
    
    //创建兑换的按钮
   // [self createButton];
}

-(void)createButton{
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [rightButton setImage:[UIImage imageNamed: @"其他"] forState:UIControlStateNormal];
    [rightButton setTitle:@"兑换" forState:normal];
    [rightButton setTitleColor:TextCOLOR forState:normal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightButton addTarget:self action:@selector(backButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)backButtonOnClick{
    
    NSString *numStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"walletNum"];
    
    if (self.isfromVip) {
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
                    
                    if (i!=0) {
                        NSString *urlString = [NSString stringWithFormat:@"%@%@",PICHEADURL,vip_beansUrl];
                        NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"viptype":[NSString stringWithFormat:@"%d",i], @"beanstype":@"0",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
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
                        NSString *urlString = [NSString stringWithFormat:@"%@%@",PICHEADURL,svip_beansUrl];
                        NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"subject":[NSString stringWithFormat:@"%d",i], @"channel":@"1",@"vuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
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
    else
    {
        //兑换VIP和SVIP
        NSString *numStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"walletNum"];
        [AlertTool alertWithViewController:self type:@"金魔豆" num:numStr andAlertDidSelectItem:^(int index, NSString *viptype) {
            __block NSString *urlString;
            __block NSDictionary *parameters;
            
            if ([viptype isEqualToString:@"VIP"]) {
                if (index!=0) {
                    urlString = [NSString stringWithFormat:@"%@%@",PICHEADURL,vip_beansUrl];
                    parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"viptype":[NSString stringWithFormat:@"%d",index], @"beanstype":@"0",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                    [self startExchangeWithUrl:urlString parameters:parameters];
                }
            }
            if ([viptype isEqualToString:@"SVIP"]){
                if (index!=0) {
                    urlString = [NSString stringWithFormat:@"%@%@",PICHEADURL,svip_beansUrl];
                    
                    parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"subject":[NSString stringWithFormat:@"%d",index], @"channel":@"1",@"vuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                    
                    [self startExchangeWithUrl:urlString parameters:parameters];
                }
            }
            if ([viptype isEqualToString:@"YOUPIAO"]){
                
                //兑换邮票
                
                if (index!=0) {
                    NSArray *array = @[@"3",@"10",@"30",@"50",@"100",@"300"];
                    NSArray *beansarray = @[@"60",@"200",@"600",@"1000",@"2000",@"6000"];
                    urlString = [NSString stringWithFormat:@"%@%@",PICHEADURL,stamp_baansUrl];
                    __block NSString *beans = @"";
                    __block NSString *numStr = @"";
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        if (idx==index) {
                            numStr=[array objectAtIndex:idx-1];
                            beans = [beansarray objectAtIndex:idx-1];
                            *stop = YES;
                        }
                    }];
                    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"num":numStr, @"channel":@"0",@"beans":beans?:@""};
                    [self startExchangeWithUrl:urlString parameters:parameters];
                }
            }
            if ([viptype isEqualToString:@"TOPCARD"])
            {
                //兑换推顶卡 channel 充值为0
                if (index!=0) {
                    NSString *urlString = [PICHEADURL stringByAppendingString:topcard_baansUrl];
                    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
                    NSArray *array = @[@"1",@"3",@"10",@"30",@"90",@"270"];
                    __block NSString *numStr = @"";
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        if (idx==index) {
                            numStr=[array objectAtIndex:idx-1];
                            *stop = YES;
                        }
                    }];
                    NSDictionary *parameters = @{@"uid":uid,@"num":numStr,@"channel":@"0"};
                    [self startExchangeWithUrl:urlString parameters:parameters];
                }
            }
        }];

    }
    
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

//生成翻页控制器
-(void)createPageViewController{
    
    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(1)};
    //    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options:options];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    LDBillViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame =  CGRectMake(0, 52, self.view.frame.size.width, self.view.frame.size.height);
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDBillViewController *)viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDBillViewController *)viewController];
    
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
    
    _billViewController = (LDBillViewController *)pendingViewControllers[0];
    
}
//翻页动画执行完成后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (finished) {
        
        if (completed) {
            
            NSInteger index = [self.pageContentArray indexOfObject:_billViewController];
            
            //            _index = index;
            
            [self changeNavButtonColor:index];
            
        }else{
            
            NSInteger index = [self.pageContentArray indexOfObject:previousViewControllers[0]];
            
            [self changeNavButtonColor:index];
        }
    }
}

#pragma mark - 根据index得到对应的UIViewController

- (LDBillViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        
        return nil;
    }
    
    LDBillViewController *contentVC = self.pageContentArray[index];
    
    contentVC.content = [NSString stringWithFormat:@"%lu",(unsigned long)index];
    
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(LDBillViewController *)viewController {
    
    return [viewController.content integerValue];
    
}

- (IBAction)billButtonClick:(UIButton *)sender {
    
    LDBillViewController *initialViewController = [self viewControllerAtIndex:sender.tag - 100];// 得到对应页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    [self changeNavButtonColor:sender.tag - 100];
}


//改变导航栏上按钮的颜色
-(void)changeNavButtonColor:(NSInteger)index{
    
    UIButton *button = (UIButton *)[self.view viewWithTag:index + 100];
    
    for (int i = 100; i < 102; i++) {
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        
        UIView *view = (UIView *)[self.view viewWithTag:i + 100];
        
        if (button.tag == btn.tag) {
            
            [button setTitleColor:MainColor forState:UIControlStateNormal];
            
            view.hidden = NO;
            
        }else{
            
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            view.hidden = YES;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
