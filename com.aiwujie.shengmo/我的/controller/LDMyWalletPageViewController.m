//
//  LDMyWalletPageViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDMyWalletPageViewController.h"
#import "LDChargeCenterViewController.h"
#import "LDMyReceiveGifViewController.h"
#import "LDDetailPageViewController.h"
#import "LDBillPageViewController.h"
#import "LDStampViewController.h"

@interface LDMyWalletPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) UIViewController *walletViewController;

@property (nonatomic,strong) UIButton *chargeButton;
@property (nonatomic,strong) UIButton *gifButton;

@property (nonatomic,strong) UIView *chargeView;
@property (nonatomic,strong) UIView *gifView;
@property (nonatomic,strong) UIView *navView;

@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,assign) int index;
@property (nonatomic,copy) NSString *num0;
@property (nonatomic,copy) NSString *num1;
@end

@implementation LDMyWalletPageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavView];
    [self createButton];
    //生成翻页控制器
    [self createPageViewController];
}

#pragma mark - Lazy Load

- (NSArray *)pageContentArray {
    if (!_pageContentArray) {
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        
        LDChargeCenterViewController *v1 = [[LDChargeCenterViewController alloc] init];
        LDMyReceiveGifViewController *v2 = [[LDMyReceiveGifViewController alloc] init];
        v2.returnValueBlock = ^(NSString *numStr) {
            self.num1 = numStr;
        };
        [arrayM addObject:v1];
        [arrayM addObject:v2];
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
    }
    return _pageContentArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _navView.hidden = NO;
}

-(void)createButton{
    
    //右侧下拉列表
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_rightButton setTitle:@"明细" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)rightButtonOnClick:(UIButton *)button{

    if (_index == 0) {
        
        LDBillPageViewController *pvc = [[LDBillPageViewController alloc] init];
        
        [self.navigationController pushViewController:pvc animated:YES];
        
    }else{
    
        LDDetailPageViewController *pvc = [[LDDetailPageViewController alloc] init];
        pvc.numStr = self.num1;
        pvc.index = _index;
        [self.navigationController pushViewController:pvc animated:YES];
    }
}

//生成翻页控制器
-(void)createPageViewController{
    
    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(1)};

    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options:options];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    if ([self.type intValue] == 1) {
        
        _index = 1;
        
        [self changeNavButtonColor:1];
        
        UIViewController *initialViewController = [self viewControllerAtIndex:1];// 得到第二页
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
        
    }else{
        
        _index = 0;
    
        UIViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = self.view.frame;
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(UIViewController *)viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(UIViewController *)viewController];
    
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
    
    _walletViewController = (UIViewController *)pendingViewControllers[0];
    
}
//翻页动画执行完成后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (finished) {
        
        if (completed) {
            
            NSInteger index = [self.pageContentArray indexOfObject:_walletViewController];
            
            _index = (int)index;
            
            [self changeNavButtonColor:index];
            
        }else{
            
            NSInteger index = [self.pageContentArray indexOfObject:previousViewControllers[0]];
            
            [self changeNavButtonColor:index];
        }
    }
}

#pragma mark - 根据index得到对应的UIViewController

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        
        return nil;
    }
    
    UIViewController *contentVC = self.pageContentArray[index];
    
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(UIViewController *)viewController {
    
    if ([viewController isKindOfClass:[LDChargeCenterViewController class]]) {
        
        return 0;
        
    }else if ([viewController isKindOfClass:[LDMyReceiveGifViewController class]]){
        
        return 1;
        
    }
    
    return 0;
    
}


-(void)createNavView{

    if (ISIPHONEX) {
         _navView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, WIDTH - 120, 88)];
    }else{
         _navView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, WIDTH - 120, 64)];
    }
    _navView.backgroundColor = [UIColor clearColor];
    [self.navigationController.view addSubview:_navView];
    CGFloat spotW = 38;
    CGFloat spotH = 2;
    _chargeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, [self getIsIphoneXNAV:ISIPHONEX], _navView.frame.size.width/2, 30)];
    [_chargeButton setTitle:@"充值" forState:UIControlStateNormal];
    [_chargeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _chargeButton.tag = 100;
    [_chargeButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _chargeButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_navView addSubview:_chargeButton];
    _chargeView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/4 - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    _chargeView.backgroundColor = [UIColor blackColor];
    _chargeView.layer.cornerRadius = spotH/2;
    _chargeView.tag = 200;
    _chargeView.hidden = NO;
    _chargeView.clipsToBounds = YES;
    [_navView addSubview:_chargeView];
    _gifButton = [[UIButton alloc] initWithFrame:CGRectMake(_navView.frame.size.width/2, [self getIsIphoneXNAV:ISIPHONEX],_navView.frame.size.width/2, 30)];
    [_gifButton setTitle:@"礼物" forState:UIControlStateNormal];
    _gifButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _gifButton.tag = 101;
    [_gifButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_gifButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_navView addSubview:_gifButton];
    _gifView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/2 + _navView.frame.size.width/4 - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    _gifView.backgroundColor = [UIColor blackColor];
    _gifView.layer.cornerRadius = spotH/2;
    _gifView.hidden = YES;
    _gifView.tag = 201;
    _gifView.clipsToBounds = YES;
    [_navView addSubview:_gifView];

}

//点击导航栏处的按钮
-(void)navButtonClick:(UIButton *)button{
    
    UIViewController *initialViewController = [self viewControllerAtIndex:button.tag - 100];// 得到对应页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    _index = (int)(button.tag - 100);
    
    [self changeNavButtonColor:button.tag - 100];
}


//改变导航栏上按钮的颜色
-(void)changeNavButtonColor:(NSInteger)index{
    
    UIButton *button = (UIButton *)[self.navView viewWithTag:index + 100];
    
    for (int i = 100; i < 102; i++) {
        
        UIButton *btn = (UIButton *)[self.navView viewWithTag:i];
        
        UIView *view = (UIView *)[self.navView viewWithTag:i + 100];
        
        if (button.tag == btn.tag) {
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            view.hidden = NO;
            
        }else{
            
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            view.hidden = YES;
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    _navView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
