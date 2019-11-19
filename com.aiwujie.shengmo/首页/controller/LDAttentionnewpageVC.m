
//
//  LDAttentionnewpageVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/8.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDAttentionnewpageVC.h"
#import "LDAttentionListViewController.h"

@interface LDAttentionnewpageVC ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDAttentionListViewController *memberPageViewController;

@property (nonatomic,strong) UIView *navView;
@property (nonatomic,strong) UIButton *nearButton;
@property (nonatomic,strong) UIButton *hotButton;
@property (nonatomic,strong) UIButton *friendButton;
@property (nonatomic,strong) UIView *nearView;
@property (nonatomic,strong) UIView *hotView;
@property (nonatomic,strong) UIView *friendView;
@property (nonatomic,strong) UIButton *tagsBtn;
@property (nonatomic,strong) UIView *tagsView;

@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@end

@implementation LDAttentionnewpageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createPageViewController];
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.rightBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getnumsfromweb];
}

- (NSArray *)pageContentArray {
    
    if (!_pageContentArray) {
        
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        
        LDAttentionListViewController *v1 = [[LDAttentionListViewController alloc] init];
        LDAttentionListViewController *v2 = [[LDAttentionListViewController alloc] init];
        
        [arrayM addObject:v1];
        [arrayM addObject:v2];
   
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
    }
    return _pageContentArray;
}

-(UIButton *)leftBtn
{
    if(!_leftBtn)
    {
        _leftBtn = [[UIButton alloc] init];
        _leftBtn.tag = 20;
        _leftBtn.frame = CGRectMake(0, 0, WIDTH/2, 42);
        [_leftBtn setTitle:@"普通关注" forState:normal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_leftBtn setTitleColor:[UIColor lightGrayColor] forState:normal];
        [_leftBtn addTarget:self action:@selector(leftbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

-(UIButton *)rightBtn
{
    if(!_rightBtn)
    {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.tag = 21;
        _rightBtn.frame = CGRectMake(WIDTH/2, 0, WIDTH/2, 42);
        [_rightBtn setTitle:@"悄悄关注(0/100)" forState:normal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rightBtn setTitleColor:[UIColor lightGrayColor] forState:normal];
        [_rightBtn addTarget:self action:@selector(rightbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

-(void)getnumsfromweb
{
    NSString *url = [PICHEADURL stringByAppendingString:getFollowCountQueitUrl];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSDictionary *params = @{@"uid":uid};
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSString *data = [responseObj objectForKey:@"data"];
            NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@",@"悄悄关注(",data,@"/",@"100",@")"];
            [self.rightBtn setTitle:str forState:normal];

        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

/**
 * 生成翻页控制器
 */
-(void)createPageViewController{
    
    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(1)};
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options:options];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    LDAttentionListViewController *initialViewController = (LDAttentionListViewController*)[self viewControllerAtIndex:0];// 得到第一页
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = CGRectMake(0,44, WIDTH, self.view.frame.size.height);
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self topButtonClick:self.leftBtn];
}

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(LDAttentionListViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

#pragma mark 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDAttentionListViewController *)viewController];
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
    
    _memberPageViewController = (LDAttentionListViewController *)pendingViewControllers[0];
    
}

//翻页动画执行完成后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (finished) {
        if (completed) {
            NSInteger index = [self.pageContentArray indexOfObject:_memberPageViewController];
            [self changeLineHidden:index];
            
        }else{
            NSInteger index = [self.pageContentArray indexOfObject:previousViewControllers[0]];
            [self changeLineHidden:index];
        }
    }
}

#pragma mark - 根据index得到对应的UIViewController

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        return nil;
    }
    LDAttentionListViewController *contentVC = self.pageContentArray[index];
    contentVC.type = [NSString stringWithFormat:@"%lu",index];
    contentVC.userID = self.userID;
    if (index==1) {
        contentVC.isquietly = YES;
    }

    if (index>3) {
        contentVC.fgid = self.fgid;
    }
    contentVC.quiteNumblock = ^(NSString *nums) {
        [self getnumsfromweb];
    };
    contentVC.isfromGuanzhu = self.isfromGuanzhu;
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

-(NSUInteger)indexOfViewController:(LDAttentionListViewController *)viewController {
    return [viewController.type integerValue];
}

#pragma mark - 点击事件

-(void)leftbtnclick
{
    [self topButtonClick:self.leftBtn];
}

-(void)rightbtnclick
{
    [self topButtonClick:self.rightBtn];
}

//按钮点击时间切换页面
- (void)topButtonClick:(UIButton *)sender {
    [self changeLineHidden:sender.tag - 20];
    LDAttentionListViewController *initialViewController = (LDAttentionListViewController*)[self viewControllerAtIndex:sender.tag - 20];// 得到对应页
    self.index = sender.tag - 20;
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

//改变文字下细线的显示隐藏
-(void)changeLineHidden:(NSInteger)index{
    if (index==0) {
        [self.leftBtn setTitleColor:MainColor forState:normal];
        [self.rightBtn setTitleColor:TextCOLOR forState:normal];
        NSNotification *notification = [NSNotification notificationWithName:@"qiaoqiaoguanzhu" object:@"0"];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    if (index==1) {
        [self.leftBtn setTitleColor:TextCOLOR forState:normal];
        [self.rightBtn setTitleColor:MainColor forState:normal];
        NSNotification *notification = [NSNotification notificationWithName:@"qiaoqiaoguanzhu" object:@"1"];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

@end
