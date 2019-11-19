//
//  LDSharepageVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/30.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDSharepageVC.h"
#import "LDSharefriendVC.h"


@interface LDSharepageVC ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDSharefriendVC *memberPageViewController;

@property (strong, nonatomic)  UIView *topView;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;

@property (nonatomic,strong) UIButton *btn0;
@property (nonatomic,strong) UIButton *btn1;
@property (nonatomic,strong) UIButton *btn2;
@property (nonatomic,strong) UIButton *btn3;

@property (nonatomic,strong) UIView *line0;
@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;
@property (nonatomic,strong) UIView *line3;


//显示目前在哪个界面
@property (nonatomic,assign) NSInteger index;

@end

@implementation LDSharepageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分享";
    _index = 0;
    [self.view addSubview:self.topView];
    [self createPageViewController];
}

-(UIView *)topView
{
    if(!_topView)
    {
        _topView = [[UIView alloc] init];
        _topView.frame = CGRectMake(0, 0, WIDTH, 44);
        
        [_topView addSubview:self.btn0];
        [_topView addSubview:self.btn1];
        [_topView addSubview:self.btn2];
        [_topView addSubview:self.btn3];
        [_topView addSubview:self.line0];
        [_topView addSubview:self.line1];
        [_topView addSubview:self.line2];
        [_topView addSubview:self.line3];

    }
    return _topView;
}

-(UIButton *)btn0
{
    if(!_btn0)
    {
        _btn0 = [[UIButton alloc] init];
        _btn0.frame = CGRectMake(0, 0, WIDTH/4, 42);
        [_btn0 setTitle:@"关注(svip)" forState:normal];
        [_btn0 setTitleColor:TextCOLOR forState:normal];
        _btn0.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn0.tag = 20;
        [_btn0 addTarget:self action:@selector(btn0click) forControlEvents:UIControlEventTouchUpInside];

    }
    return _btn0;
}

-(UIButton *)btn1
{
    if(!_btn1)
    {
        _btn1 = [[UIButton alloc] init];
        _btn1.frame = CGRectMake(WIDTH/4, 0, WIDTH/4, 42);
        [_btn1 setTitle:@"粉丝(svip)" forState:normal];
        [_btn1 setTitleColor:TextCOLOR forState:normal];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn1.tag = 21;
        [_btn1 addTarget:self action:@selector(btn1click) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _btn1;
}

-(UIButton *)btn2
{
    if(!_btn2)
    {
        _btn2 = [[UIButton alloc] init];
        _btn2.frame = CGRectMake(WIDTH/2, 0, WIDTH/4, 42);
        [_btn2 setTitle:@"好友" forState:normal];
        [_btn2 setTitleColor:MainColor forState:normal];
        _btn2.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn2.tag = 22;
        [_btn2 addTarget:self action:@selector(btn2click) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _btn2;
}

-(UIButton *)btn3
{
    if(!_btn3)
    {
        _btn3 = [[UIButton alloc] init];
        _btn3.frame = CGRectMake(WIDTH/4*3, 0, WIDTH/4, 42);
        [_btn3 setTitle:@"群组" forState:normal];
        [_btn3 setTitleColor:TextCOLOR forState:normal];
        _btn3.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn3.tag = 23;
        [_btn3 addTarget:self action:@selector(btn3click) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _btn3;
}


-(UIView *)line0
{
    if(!_line0)
    {
        _line0 = [[UIView alloc] init];
        _line0.frame = CGRectMake(0, 42, WIDTH/4, 1);
        _line0.backgroundColor = MainColor;
        [_line0 setHidden:YES];
    }
    return _line0;
}

-(UIView *)line1
{
    if(!_line1)
    {
        _line1 = [[UIView alloc] init];
        _line1.frame = CGRectMake(WIDTH/4, 42, WIDTH/4, 1);
        _line1.backgroundColor = MainColor;
        [_line1 setHidden:YES];
    }
    return _line1;
}

-(UIView *)line2
{
    if(!_line2)
    {
        _line2 = [[UIView alloc] init];
        _line2.frame = CGRectMake(WIDTH/2, 42, WIDTH/4, 1);
        _line2.backgroundColor = MainColor;
        [_line2 setHidden:NO];
    }
    return _line2;
}

-(UIView *)line3
{
    if(!_line3)
    {
        _line3 = [[UIView alloc] init];
        _line3.frame = CGRectMake(WIDTH/4*3, 42, WIDTH/4, 1);
        _line3.backgroundColor = MainColor;
        [_line3 setHidden:YES];
    }
    return _line3;
}


- (NSArray *)pageContentArray {
    
    if (!_pageContentArray) {
        
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        
        LDSharefriendVC *v1 = [[LDSharefriendVC alloc] init];
        LDSharefriendVC *v2 = [[LDSharefriendVC alloc] init];
        LDSharefriendVC *v3 = [[LDSharefriendVC alloc] init];
        LDSharefriendVC *v4 = [[LDSharefriendVC alloc] init];
        [arrayM addObject:v1];
        [arrayM addObject:v2];
        [arrayM addObject:v3];
        [arrayM addObject:v4];
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
    LDSharefriendVC *initialViewController = (LDSharefriendVC*)[self viewControllerAtIndex:0];// 得到第一页
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = CGRectMake(0,44, WIDTH, self.view.frame.size.height-44);
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self topButtonClick:self.btn2];
}

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(LDSharefriendVC *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

#pragma mark 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDSharefriendVC *)viewController];
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
    
    _memberPageViewController = (LDSharefriendVC *)pendingViewControllers[0];
    
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
    LDSharefriendVC *contentVC = self.pageContentArray[index];
    contentVC.indexStr = [NSString stringWithFormat:@"%lu",index];
    contentVC.content = self.content;
    contentVC.typeStr = self.typeStr;
    contentVC.pic = self.pic;
    contentVC.did = self.did;
    contentVC.userid = self.userid;
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

-(NSUInteger)indexOfViewController:(LDSharefriendVC *)viewController {
    return [viewController.indexStr integerValue];
}

-(void)btn0click
{
    [self topButtonClick:self.btn0];
}


-(void)btn1click
{
    [self topButtonClick:self.btn1];
}


-(void)btn2click
{
    [self topButtonClick:self.btn2];
}


-(void)btn3click
{
    [self topButtonClick:self.btn3];
}

//按钮点击时间切换页面
- (void)topButtonClick:(UIButton *)sender {
    [self changeLineHidden:sender.tag - 20];
    LDSharefriendVC *initialViewController = (LDSharefriendVC*)[self viewControllerAtIndex:sender.tag - 20];// 得到对应页
    _index = sender.tag - 20;
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

//改变文字下细线的显示隐藏
-(void)changeLineHidden:(NSInteger)index{
    
    if (index==0) {
        [self.btn0 setTitleColor:MainColor forState:normal];
        [self.btn1 setTitleColor:TextCOLOR forState:normal];
        [self.btn2 setTitleColor:TextCOLOR forState:normal];
        [self.btn3 setTitleColor:TextCOLOR forState:normal];
        [self.line0 setHidden:NO];
        [self.line1 setHidden:YES];
        [self.line2 setHidden:YES];
        [self.line3 setHidden:YES];
    }
    if (index==1)
    {
        [self.btn0 setTitleColor:TextCOLOR forState:normal];
        [self.btn1 setTitleColor:MainColor forState:normal];
        [self.btn2 setTitleColor:TextCOLOR forState:normal];
        [self.btn3 setTitleColor:TextCOLOR forState:normal];
        [self.line0 setHidden:YES];
        [self.line1 setHidden:NO];
        [self.line2 setHidden:YES];
        [self.line3 setHidden:YES];
    }
    if (index==2)
    {
        [self.btn0 setTitleColor:TextCOLOR forState:normal];
        [self.btn1 setTitleColor:TextCOLOR forState:normal];
        [self.btn2 setTitleColor:MainColor forState:normal];
        [self.btn3 setTitleColor:TextCOLOR forState:normal];
        [self.line0 setHidden:YES];
        [self.line1 setHidden:YES];
        [self.line2 setHidden:NO];
        [self.line3 setHidden:YES];
    }
    if (index==3)
    {
        [self.btn0 setTitleColor:TextCOLOR forState:normal];
        [self.btn1 setTitleColor:TextCOLOR forState:normal];
        [self.btn2 setTitleColor:TextCOLOR forState:normal];
        [self.btn3 setTitleColor:MainColor forState:normal];
        [self.line0 setHidden:YES];
        [self.line1 setHidden:YES];
        [self.line2 setHidden:YES];
        [self.line3 setHidden:NO];
    }
}


@end
