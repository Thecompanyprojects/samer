//
//  LDRewardRankingViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/11.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDRewardRankingViewController.h"
#import "LDRewardRankingPageViewController.h"


@interface LDRewardRankingViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>


//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDRewardRankingPageViewController *rewardRankingPageViewController;

@property (nonatomic, assign) NSUInteger moneyIndex;
@property (nonatomic, assign) NSUInteger vulgarIndex;

@property (weak, nonatomic) IBOutlet UIButton *moneyButton;
@property (weak, nonatomic) IBOutlet UIView *moneyView;
@property (weak, nonatomic) IBOutlet UIButton *VulgarButton;
@property (weak, nonatomic) IBOutlet UIView *VulgarView;
@property (weak, nonatomic) IBOutlet UIButton *dayButton;
@property (weak, nonatomic) IBOutlet UIButton *weekButton;
@property (weak, nonatomic) IBOutlet UIButton *monthButton;

@end

@implementation LDRewardRankingViewController

#pragma mark - Lazy Load

- (NSArray *)pageContentArray {
    if (!_pageContentArray) {
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        
        LDRewardRankingPageViewController *v1 = [[LDRewardRankingPageViewController alloc] init];
        LDRewardRankingPageViewController *v2 = [[LDRewardRankingPageViewController alloc] init];
        LDRewardRankingPageViewController *v3 = [[LDRewardRankingPageViewController alloc] init];
        LDRewardRankingPageViewController *v4 = [[LDRewardRankingPageViewController alloc] init];
        LDRewardRankingPageViewController *v5 = [[LDRewardRankingPageViewController alloc] init];
        LDRewardRankingPageViewController *v6 = [[LDRewardRankingPageViewController alloc] init];
        
        [arrayM addObject:v1];
        [arrayM addObject:v2];
        [arrayM addObject:v3];
        [arrayM addObject:v4];
        [arrayM addObject:v5];
        [arrayM addObject:v6];
        
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
        
    }
    return _pageContentArray;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
//    UINavigationBar *navigationBar = self.navigationController.navigationBar;
//    // bg.png为自己ps出来的想要的背景颜色。
//    [navigationBar setBackgroundImage:[UIImage imageNamed:@"导航背景"]
//                       forBarPosition:UIBarPositionAny
//                           barMetrics:UIBarMetricsDefault];
//    [navigationBar setShadowImage:[UIImage new]];
     [self vhl_setNavBarBackgroundColor:[UIColor colorWithHexString:@"B73ACB" alpha:1]];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
//    UINavigationBar *navigationBar = self.navigationController.navigationBar;
//    // bg.png为自己ps出来的想要的背景颜色。
//    [navigationBar setBackgroundImage:nil
//                       forBarPosition:UIBarPositionAny
//                           barMetrics:UIBarMetricsDefault];
//    [navigationBar setShadowImage:nil];
    [self vhl_setNavBarBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"打赏榜";
    
    self.moneyView.layer.cornerRadius = 2;
    self.moneyView.clipsToBounds = YES;
    
    self.VulgarView.layer.cornerRadius = 2;
    self.VulgarView.clipsToBounds = YES;
    
    [self createPageViewController];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
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
    
    LDRewardRankingPageViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    _moneyIndex = 0;
    
    _vulgarIndex = 3;
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = CGRectMake(0, 90, self.view.frame.size.width, self.view.frame.size.height);
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDRewardRankingPageViewController *)viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDRewardRankingPageViewController *)viewController];
    
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
    
    _rewardRankingPageViewController = (LDRewardRankingPageViewController *)pendingViewControllers[0];
    
}
//翻页动画执行完成后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (finished) {
        
        if (completed) {
            
            NSInteger index = [self.pageContentArray indexOfObject:_rewardRankingPageViewController];
            
            if (index > 2) {
                
                self.moneyView.hidden = YES;
                
                self.VulgarView.hidden = NO;
                
                _vulgarIndex = index;
                
                [self changeButtonClick:index - 3];
                
            }else{
            
                self.moneyView.hidden = NO;
                
                self.VulgarView.hidden = YES;
                
                _moneyIndex = index;
                
                [self changeButtonClick:index];
                
            }
            
            
        }else{
            
//            NSInteger index = [self.pageContentArray indexOfObject:previousViewControllers[0]];
            
//            _index = index;
            
//            [self changeNavButtonColor:index];
        }
        
    }
}

//改变日榜,周榜,月榜的颜色
-(void)changeButtonClick:(NSInteger)index{
    
    for (int i = 14; i < 17; i++) {
        
       UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        
        if (index + 14 == btn.tag) {
            
            [btn setTitleColor:MainColor forState:UIControlStateNormal];
            
        }else{
            
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
    }
    
}

#pragma mark - 根据index得到对应的UIViewController

- (LDRewardRankingPageViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        
        return nil;
    }
    
    LDRewardRankingPageViewController *contentVC = self.pageContentArray[index];
    
    contentVC.content = [NSString stringWithFormat:@"%ld",(long)index];
    
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(LDRewardRankingPageViewController *)viewController {
    
    return [viewController.content integerValue];
    
}
- (IBAction)moneyButtonClick:(id)sender {
    
    self.moneyView.hidden = NO;
    self.VulgarView.hidden = YES;
    
    [self changeButtonClick:_moneyIndex];
    
    LDRewardRankingPageViewController *initialViewController = [self viewControllerAtIndex:_moneyIndex];// 得到当前页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];

}
- (IBAction)vulgarButtonClick:(id)sender {
    
    self.moneyView.hidden = YES;
    self.VulgarView.hidden = NO;
    
//    NSLog(@"%ld,%ld",_vulgarIndex,_vulgarIndex - 3);
    
    [self changeButtonClick:_vulgarIndex - 3];
    
    LDRewardRankingPageViewController *initialViewController = [self viewControllerAtIndex:_vulgarIndex];// 得到当前页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}
- (IBAction)buttonClick:(UIButton *)sender {
    
    if (self.moneyView.hidden == NO) {
        
        LDRewardRankingPageViewController *initialViewController = [self viewControllerAtIndex:sender.tag - 14];// 得到当前页
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        if (_moneyIndex + 14 > sender.tag) {
            
             [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
            
        }else{
        
             [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
        
        _moneyIndex = sender.tag - 14;
        
        [self changeButtonClick:sender.tag - 14];
        
    }else{
    
        LDRewardRankingPageViewController *initialViewController = [self viewControllerAtIndex:sender.tag - 11];// 得到当前页
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        if (_vulgarIndex + 11 > sender.tag) {
            
            [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
            
        }else{
            
            [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }

        _vulgarIndex = sender.tag - 11;
        
        [self changeButtonClick:sender.tag - 14];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
