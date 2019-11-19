//
//  LDSelectpersonpageVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/26.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDSelectpersonpageVC.h"
#import "LDSelectAtPersonViewController.h"

@interface LDSelectpersonpageVC ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDSelectAtPersonViewController *memberPageViewController;

@property (strong, nonatomic) UIView *topView;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UIButton *btn3;
@property (nonatomic,strong) UIView *line0;
@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;

@property (nonatomic,strong) NSMutableArray * selectArray;
@property (nonatomic,strong) NSMutableArray * nameArray;
@property (nonatomic,strong) NSMutableArray * selectArray2;
@property (nonatomic,strong) NSMutableArray * nameArray2;
@property (nonatomic,strong) NSMutableArray * liaoselectArray;
@property (nonatomic,strong) NSMutableArray * liaonameArray;
//显示目前在哪个界面
@property (nonatomic,assign) NSInteger index;
@end

@implementation LDSelectpersonpageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isfromGroup) {
        self.title = @"添加成员";
    }
    else
    {
        self.title = @"提醒谁看";
    }

    self.selectArray = [NSMutableArray array];
    self.nameArray = [NSMutableArray array];
    self.selectArray2 = [NSMutableArray array];
    self.nameArray2 = [NSMutableArray array];
    self.liaoselectArray = [NSMutableArray array];
    self.liaonameArray = [NSMutableArray array];
    [self createButton];
    [self.view addSubview:self.topView];
    [self createPageViewController];
    self.index = 0;
    [self leftcreateButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticename:) name:@"addselectname" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeuid:) name:@"addselectuid" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticename2:) name:@"addselectname2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeuid2:) name:@"addselectuid2" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticename3:) name:@"addselectname3" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeuid3:) name:@"addselectuid3" object:nil];
}

-(void)leftcreateButton{
    UIButton * areaButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 36, 10, 14)];
    if (@available(iOS 11.0, *)) {
        [areaButton setImage:[UIImage imageNamed:@"back-11"] forState:UIControlStateNormal];
    }else{
        [areaButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    [areaButton addTarget:self action:@selector(backButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaButton];
    if (@available(iOS 11.0, *)) {
        leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 44);
    }
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
-(void)backButtonOnClick
{
    if (self.returnblock) {
        self.returnblock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
        NSLog(@"页面pop成功了");
        if (self.returnblock) {
            self.returnblock();
        }
    }
}

-(void)noticename:(NSNotification *)sender{
    self.nameArray = sender.object;
}

-(void)noticeuid:(NSNotification *)sender{
    NSLog(@"%@",sender);
    self.selectArray = sender.object;
}

-(void)noticename2:(NSNotification *)sender{
    self.nameArray2 = sender.object;
}

-(void)noticeuid2:(NSNotification *)sender{
    NSLog(@"%@",sender);
    self.selectArray2 = sender.object;
}

-(void)noticename3:(NSNotification *)sender{
    self.liaonameArray = sender.object;
}

-(void)noticeuid3:(NSNotification *)sender{
    NSLog(@"%@",sender);
    self.liaoselectArray = sender.object;
}

-(void)createButton{
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(completeButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)completeButtonOnClick
{
    if (self.newblock) {
        NSMutableArray *names = [NSMutableArray new];
        [names addObjectsFromArray:self.nameArray];
        [names addObjectsFromArray:self.nameArray2];
        [names addObjectsFromArray:self.liaonameArray];
        
        NSMutableArray *uidarray = [NSMutableArray array];
        [uidarray addObjectsFromArray:self.selectArray];
        [uidarray addObjectsFromArray:self.selectArray2];
        [uidarray addObjectsFromArray:self.liaoselectArray];
        
        self.newblock(uidarray,names, 0);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
        [_topView addSubview:self.btn3];
        [_topView addSubview:self.line2];
    }
    return _topView;
}

-(UIButton *)leftBtn
{
    if(!_leftBtn)
    {
        _leftBtn = [[UIButton alloc] init];
        _leftBtn.frame = CGRectMake(0, 0, WIDTH/3, 42);
        [_leftBtn setTitle:@"聊天" forState:normal];
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
        _rightBtn.frame = CGRectMake(WIDTH/3, 0, WIDTH/3, 42);
        [_rightBtn setTitleColor:TextCOLOR forState:normal];
        [_rightBtn setTitle:@"关注" forState:normal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _rightBtn.tag = 21;
        [_rightBtn addTarget:self action:@selector(rightclick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _rightBtn;
}

-(UIButton *)btn3
{
    if(!_btn3)
    {
        _btn3 = [[UIButton alloc] init];
        _btn3.frame = CGRectMake(WIDTH/3*2, 0, WIDTH/3, 42);
        [_btn3 setTitleColor:TextCOLOR forState:normal];
        [_btn3 setTitle:@"粉丝" forState:normal];
        _btn3.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn3.tag = 22;
        [_btn3 addTarget:self action:@selector(btn3click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn3;
}


-(UIView *)line0
{
    if(!_line0)
    {
        _line0 = [[UIView alloc] init];
        _line0.frame = CGRectMake(15, 42, WIDTH/3-30, 1);
        _line0.backgroundColor = MainColor;
    }
    return _line0;
}

-(UIView *)line1
{
    if(!_line1)
    {
        _line1 = [[UIView alloc] init];
        _line1.frame = CGRectMake(WIDTH/3+15, 42, WIDTH/3-30, 1);
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
        _line2.frame = CGRectMake(WIDTH/3*2+15, 42, WIDTH/3-30, 1);
        _line2.backgroundColor = MainColor;
        [_line2 setHidden:YES];
    }
    return _line2;
}

- (NSArray *)pageContentArray {
    
    if (!_pageContentArray) {
        
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        
        LDSelectAtPersonViewController *v1 = [[LDSelectAtPersonViewController alloc] init];
        LDSelectAtPersonViewController *v2 = [[LDSelectAtPersonViewController alloc] init];
        LDSelectAtPersonViewController *v3 = [[LDSelectAtPersonViewController alloc] init];
        
        v1.selectArray = [NSMutableArray array];
        v1.nameArray = [NSMutableArray array];
        v2.selectArray2 = [NSMutableArray array];
        v2.nameArray2 = [NSMutableArray array];
        v3.liaoselectArray = [NSMutableArray array];
        v3.liaonameArray = [NSMutableArray array];
        
        [arrayM addObject:v1];
        [arrayM addObject:v2];
        [arrayM addObject:v3];
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
    
    LDSelectAtPersonViewController *initialViewController = (LDSelectAtPersonViewController*)[self viewControllerAtIndex:0];// 得到第一页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = CGRectMake(0,43, WIDTH, self.view.frame.size.height-43);
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
 
        [self topButtonClick:self.leftBtn];

}

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(LDSelectAtPersonViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

#pragma mark 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDSelectAtPersonViewController *)viewController];
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
    
    _memberPageViewController = (LDSelectAtPersonViewController *)pendingViewControllers[0];
    
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

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        return nil;
    }
    LDSelectAtPersonViewController *contentVC = self.pageContentArray[index];
    contentVC.content = [NSString stringWithFormat:@"%lu",index];
    contentVC.uidArray = self.uidArray;
    contentVC.isfromGroup = self.isfromGroup;
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(LDSelectAtPersonViewController *)viewController {
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

-(void)btn3click
{
    [self topButtonClick:self.btn3];
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
        [self.btn3 setTitleColor:TextCOLOR forState:normal];
        [self.line0 setHidden:NO];
        [self.line1 setHidden:YES];
        [self.line2 setHidden:YES];
    }
    if (index==1) {
        [self.leftBtn setTitleColor:TextCOLOR forState:normal];
        [self.rightBtn setTitleColor:MainColor forState:normal];
        [self.btn3 setTitleColor:TextCOLOR forState:normal];
        [self.line0 setHidden:YES];
        [self.line1 setHidden:NO];
        [self.line2 setHidden:YES];
    }
    if (index==2) {
        [self.leftBtn setTitleColor:TextCOLOR forState:normal];
        [self.rightBtn setTitleColor:TextCOLOR forState:normal];
        [self.btn3 setTitleColor:MainColor forState:normal];
        [self.line0 setHidden:YES];
        [self.line1 setHidden:YES];
        [self.line2 setHidden:NO];
    }

}

@end
