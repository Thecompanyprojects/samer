//
//  LDLookOrBeLookViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/1.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDLookOrBeLookViewController.h"
#import "LDLookOrBeLookPageViewController.h"

@interface LDLookOrBeLookViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDLookOrBeLookPageViewController *LookOrBeLookPageViewController;

@property (nonatomic,strong) UIButton *nearButton;
@property (nonatomic,strong) UIButton *hotButton;

@property (nonatomic,strong) UIView *nearView;
@property (nonatomic,strong) UIView *hotView;
@property (nonatomic,strong) UIView *navView;

@end

@implementation LDLookOrBeLookViewController

#pragma mark - Lazy Load

- (NSArray *)pageContentArray {
    
    if (!_pageContentArray) {
        
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        
        LDLookOrBeLookPageViewController *v1 = [[LDLookOrBeLookPageViewController alloc] init];
        LDLookOrBeLookPageViewController *v2 = [[LDLookOrBeLookPageViewController alloc] init];
        
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavButtn];
    
    //生成翻页控制器
    [self createPageViewController];
    
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
    
    LDLookOrBeLookPageViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = self.view.frame;
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDLookOrBeLookPageViewController *)viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDLookOrBeLookPageViewController *)viewController];
    
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
    
    _LookOrBeLookPageViewController = (LDLookOrBeLookPageViewController *)pendingViewControllers[0];
    
}
//翻页动画执行完成后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (finished) {
        
        if (completed) {
            
            NSInteger index = [self.pageContentArray indexOfObject:_LookOrBeLookPageViewController];
            
            [self changeNavButtonColor:index];
            
        }else{
            
            NSInteger index = [self.pageContentArray indexOfObject:previousViewControllers[0]];
            
            [self changeNavButtonColor:index];
        }
        
    }
}

#pragma mark - 根据index得到对应的UIViewController

- (LDLookOrBeLookPageViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        
        return nil;
    }
    
    LDLookOrBeLookPageViewController *contentVC = self.pageContentArray[index];
        
    contentVC.content = [NSString stringWithFormat:@"%ld",index];
    
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(LDLookOrBeLookPageViewController *)viewController {
    
    return [viewController.content integerValue];
    
}

-(void)createNavButtn{
    
    if (ISIPHONEX) {
        
        _navView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, WIDTH - 120, 88)];
        
    }else{
        
        _navView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, WIDTH - 120, 64)];
    }
    
    _navView.backgroundColor = [UIColor clearColor];
    [self.navigationController.view addSubview:_navView];
    
    CGFloat spotH = 2;
    CGFloat spotW = 38;
    
    _nearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, [self getIsIphoneXNAV:ISIPHONEX], _navView.frame.size.width/2, 30)];
    [_nearButton setTitle:@"来访" forState:UIControlStateNormal];
    _nearButton.tag = 100;
    [_nearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nearButton addTarget:self action:@selector(nearButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _nearButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_navView addSubview:_nearButton];
    
    _nearView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/4 - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    _nearView.backgroundColor = [UIColor blackColor];
    _nearView.tag = 200;
    _nearView.layer.cornerRadius = spotH/2;
    _nearView.hidden = NO;
    _nearView.clipsToBounds = YES;
    [_navView addSubview:_nearView];
    
    
    _hotButton = [[UIButton alloc] initWithFrame:CGRectMake(_navView.frame.size.width/2, [self getIsIphoneXNAV:ISIPHONEX],_navView.frame.size.width/2, 30)];
    [_hotButton setTitle:@"查看" forState:UIControlStateNormal];
    _hotButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _hotButton.tag = 101;
    [_hotButton addTarget:self action:@selector(hotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_hotButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_navView addSubview:_hotButton];
    
    _hotView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/2 + _navView.frame.size.width/4 - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    _hotView.backgroundColor = [UIColor blackColor];
    _hotView.tag = 201;
    _hotView.layer.cornerRadius = spotH/2;
    _hotView.hidden = YES;
    _hotView.clipsToBounds = YES;
    [_navView addSubview:_hotView];
    
}

//改变导航栏上按钮的颜色
-(void)changeNavButtonColor:(NSInteger)index{
    
    UIButton *button = (UIButton *)[self.navView viewWithTag:index + 100];
    
    for (int i = 100; i < 100 + _pageContentArray.count; i++) {
        
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

-(void)nearButtonClick:(UIButton *)button{
    
    LDLookOrBeLookPageViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
        
    [self changeNavButtonColor:button.tag - 100];
    
}

-(void)hotButtonClick:(UIButton *)button{
    
    LDLookOrBeLookPageViewController *initialViewController = [self viewControllerAtIndex:1];// 得到第一页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
        
    [self changeNavButtonColor:button.tag - 100];
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    _navView.hidden = YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
