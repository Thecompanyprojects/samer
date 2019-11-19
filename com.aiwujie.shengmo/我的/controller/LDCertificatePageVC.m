//
//  LDCertificatePageVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/11.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDCertificatePageVC.h"
#import "LDCertificateBeforeViewController.h"


@interface LDCertificatePageVC ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDCertificateBeforeViewController *memberPageViewController;

@property (strong, nonatomic)  UIView *topView;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UIView *line0;
@property (nonatomic,strong) UIView *line1;

//显示目前在哪个界面
@property (nonatomic,assign) NSInteger index;
@end

@implementation LDCertificatePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的认证";
//    [self.view addSubview:self.topView];
    _index = 0;
    [self createPageViewController];
}

-(UIView *)topView
{
    if(!_topView)
    {
        _topView = [[UIView alloc] init];
        _topView.frame = CGRectMake(0, 0, WIDTH, 44);
        
        [_topView addSubview:self.line0];
        [_topView addSubview:self.line1];
        [_topView addSubview:self.leftBtn];
        [_topView addSubview:self.rightBtn];
        
        UILabel *newLabel = [[UILabel alloc] init];
        newLabel.text = @"new";
        newLabel.font = [UIFont italicSystemFontOfSize:13];//设置字体为斜体
        newLabel.textColor = [UIColor redColor];
        newLabel.frame = CGRectMake(WIDTH/4*3+35, 13, 30, 14);
        [_topView addSubview:newLabel];
        
    }
    return _topView;
}

-(UIButton *)leftBtn
{
    if(!_leftBtn)
    {
        _leftBtn = [[UIButton alloc] init];
        _leftBtn.frame = CGRectMake(0, 0, WIDTH/2, 42);
        [_leftBtn setTitle:@"自拍认证" forState:normal];
        [_leftBtn setTitleColor:MainColor forState:normal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _leftBtn.tag = 20;
        [_leftBtn addTarget:self action:@selector(leftclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

-(UIButton *)rightBtn
{
    if(!_rightBtn)
    {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.frame = CGRectMake(WIDTH/2, 0, WIDTH/2, 42);
        [_rightBtn setTitleColor:TextCOLOR forState:normal];
        [_rightBtn setTitle:@"身份认证" forState:normal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _rightBtn.tag = 21;
        [_rightBtn addTarget:self action:@selector(rightclick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _rightBtn;
}


-(UIView *)line0
{
    if(!_line0)
    {
        _line0 = [[UIView alloc] init];
        _line0.frame = CGRectMake(15, 42, WIDTH/2-30, 1);
        _line0.backgroundColor = MainColor;
    }
    return _line0;
}

-(UIView *)line1
{
    if(!_line1)
    {
        _line1 = [[UIView alloc] init];
        _line1.frame = CGRectMake(WIDTH/2+15, 42, WIDTH/2-30, 1);
        _line1.backgroundColor = MainColor;
        [_line1 setHidden:YES];
    }
    return _line1;
}

- (NSArray *)pageContentArray {
    
    if (!_pageContentArray) {
        
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        
        LDCertificateBeforeViewController *v1 = [[LDCertificateBeforeViewController alloc] init];
//        LDCertificateBeforeViewController *v2 = [[LDCertificateBeforeViewController alloc] init];
        
        [arrayM addObject:v1];
//        [arrayM addObject:v2];
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
    
    LDCertificateBeforeViewController *initialViewController = (LDCertificateBeforeViewController*)[self viewControllerAtIndex:0];// 得到第一页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = CGRectMake(0,0, WIDTH, self.view.frame.size.height);
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    if (self.isfromuserinfo) {
        [self topButtonClick:self.rightBtn];

    }
    else
    {
        [self topButtonClick:self.leftBtn];

    }
    
}

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(LDCertificateBeforeViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

#pragma mark 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDCertificateBeforeViewController *)viewController];
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
    
    _memberPageViewController = (LDCertificateBeforeViewController *)pendingViewControllers[0];
    
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

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        return nil;
    }
    LDCertificateViewController *contentVC = self.pageContentArray[index];
    contentVC.content = [NSString stringWithFormat:@"%lu",index];
    contentVC.type = self.status;
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

-(NSUInteger)indexOfViewController:(LDCertificateBeforeViewController *)viewController {
    return [viewController.content integerValue];
}

-(void)leftclick
{
    [self topButtonClick:self.leftBtn];
}

-(void)rightclick
{
    [self topButtonClick:self.rightBtn];
}

//按钮点击时间切换页面
- (void)topButtonClick:(UIButton *)sender {
    [self changeLineHidden:sender.tag - 20];
    LDCertificateViewController *initialViewController = (LDCertificateViewController*)[self viewControllerAtIndex:sender.tag - 20];// 得到对应页
    _index = sender.tag - 20;
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

//改变文字下细线的显示隐藏
-(void)changeLineHidden:(NSInteger)index{
    
    if (index==0) {
        [self.leftBtn setTitleColor:MainColor forState:normal];
        [self.rightBtn setTitleColor:TextCOLOR forState:normal];
        [self.line0 setHidden:NO];
        [self.line1 setHidden:YES];
    }
    else
    {
        [self.leftBtn setTitleColor:TextCOLOR forState:normal];
        [self.rightBtn setTitleColor:MainColor forState:normal];
        [self.line0 setHidden:YES];
        [self.line1 setHidden:NO];
    }
}

@end
