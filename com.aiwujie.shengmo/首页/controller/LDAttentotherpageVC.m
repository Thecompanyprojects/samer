//
//  LDAttentotherpageVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/12.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDAttentotherpageVC.h"
#import "LDAttentOtherViewController.h"

@interface LDAttentotherpageVC ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDAttentOtherViewController *memberPageViewController;
@property (nonatomic,strong) UIButton *nearButton;
@property (nonatomic,strong) UIButton *hotButton;
@property (nonatomic,strong) UIView *nearView;
@property (nonatomic,strong) UIView *hotView;
@property (nonatomic,strong) UIView *navView;

@property (nonatomic,copy) NSString *type;
@end

@implementation LDAttentotherpageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavButtn];
    [self createPageViewController];
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
    
    [_nearButton setTitle:@"关注" forState:UIControlStateNormal];
    
    [_nearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [_nearButton addTarget:self action:@selector(nearButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _nearButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [_navView addSubview:_nearButton];
    
    _nearView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/4 - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    
    _nearView.backgroundColor = [UIColor blackColor];
    
    _nearView.layer.cornerRadius = spotH/2;
    
    _nearView.hidden = YES;
    
    _nearView.clipsToBounds = YES;
    
    [_navView addSubview:_nearView];
    
    
    _hotButton = [[UIButton alloc] initWithFrame:CGRectMake(_navView.frame.size.width/2, [self getIsIphoneXNAV:ISIPHONEX],_navView.frame.size.width/2, 30)];
    
    [_hotButton setTitle:@"粉丝" forState:UIControlStateNormal];
    
    _hotButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [_hotButton addTarget:self action:@selector(hotButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_hotButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [_navView addSubview:_hotButton];
    
    _hotView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/2 + _navView.frame.size.width/4 - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    
    _hotView.backgroundColor = [UIColor blackColor];
    
    _hotView.layer.cornerRadius = spotH/2;
    
    _hotView.hidden = YES;
    
    _hotView.clipsToBounds = YES;
    
    [_navView addSubview:_hotView];
    
}


-(void)nearButtonClick{
    
    self.type = @"0";
    
    [_nearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _nearView.hidden = NO;
    
    [_hotButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _hotView.hidden = YES;
    
}

-(void)hotButtonClick{
    
    self.type = @"1";
    
    [_hotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _hotView.hidden = NO;
    
    [_nearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _nearView.hidden = YES;
    
}


- (NSArray *)pageContentArray {
    
    if (!_pageContentArray) {
        
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        
        LDAttentOtherViewController *v1 = [[LDAttentOtherViewController alloc] init];
        LDAttentOtherViewController *v2 = [[LDAttentOtherViewController alloc] init];
    
        [arrayM addObject:v1];
        [arrayM addObject:v2];
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
    }
    return _pageContentArray;
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
    LDAttentOtherViewController *initialViewController = (LDAttentOtherViewController*)[self viewControllerAtIndex:0];// 得到第一页
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = CGRectMake(0,0, WIDTH, self.view.frame.size.height);
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];

}


#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(LDAttentOtherViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

#pragma mark 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDAttentOtherViewController *)viewController];
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
    
    _memberPageViewController = (LDAttentOtherViewController *)pendingViewControllers[0];
    
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

-(LDBaseViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        return nil;
    }
    LDAttentOtherViewController *contentVC = self.pageContentArray[index];
    contentVC.type = [NSString stringWithFormat:@"%lu",index];
    contentVC.userID = self.userID;
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

-(NSUInteger)indexOfViewController:(LDAttentOtherViewController *)viewController {
    return [viewController.type integerValue];
}


#pragma mark - 点击事件

//按钮点击时间切换页面
- (void)topButtonClick:(UIButton *)sender {
    [self changeLineHidden:sender.tag - 20];
    LDAttentOtherViewController *initialViewController = (LDAttentOtherViewController*)[self viewControllerAtIndex:sender.tag - 20];// 得到对应页
//    _index = sender.tag - 20;
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

//改变文字下细线的显示隐藏
-(void)changeLineHidden:(NSInteger)index{
 
    if (index==0) {
        
    }
    if (index==1) {
        
    }
    
}

@end
