//
//  LDGiveGifListViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGiveGifListViewController.h"
#import "LDGiveGifListPageViewController.h"

@interface LDGiveGifListViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDGiveGifListPageViewController *GiveGifListPageViewController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLineW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLineW;
@property (weak, nonatomic) IBOutlet UIButton *Button0;
@property (weak, nonatomic) IBOutlet UIButton *Button1;
@property (weak, nonatomic) IBOutlet UIButton *Button2;
@property (nonatomic, weak) UIView *navLine;

@property (nonatomic,strong) UILabel *numLab0;
@property (nonatomic,strong) UILabel *numLab1;
@property (nonatomic,strong) UILabel *numLab2;

@end

@implementation LDGiveGifListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"大喇叭";
    //生成翻页控制器
    [self createPageViewController];
    [self.view addSubview:self.numLab0];
    [self.view addSubview:self.numLab1];
    [self.view addSubview:self.numLab2];
    [self setuplayout];
    [self showredsNum];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delloudspeakersClick) name:@"delloudspeakers" object:nil];
}

-(void)showredsNum
{
    NSString *redgiftnum = [[NSUserDefaults standardUserDefaults] objectForKey:@"redgiftnum"];
    NSString *redvipnum = [[NSUserDefaults standardUserDefaults] objectForKey:@"redvipnum"];
    NSString *topcardnum = [[NSUserDefaults standardUserDefaults] objectForKey:@"redtopcardnum"];

    __weak typeof (self) weakSelf = self;
    if ([redgiftnum intValue]==0||redgiftnum.length==0) {
        [self.numLab0 setHidden:YES];
    }
    else
    {
        [self.numLab0 setHidden:NO];
        self.numLab0.text = redgiftnum?:@"";
        
        if (redgiftnum.length>2) {
            CGFloat flowidth = [self clwidth:redgiftnum];
            [weakSelf.numLab0 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.Button0);
                make.right.equalTo(weakSelf.Button0).with.offset(-2);
                make.width.mas_offset(flowidth+6);
                make.height.mas_offset(16);
            }];
        }
        
    }
    
    if ([redvipnum intValue]==0||redvipnum.length==0) {
        [self.numLab1 setHidden:YES];
    }
    else
    {
        [self.numLab1 setHidden:NO];
        self.numLab1.text = redvipnum?:@"";
        if (redvipnum.length>2) {
            CGFloat flowidth = [self clwidth:redvipnum];
            [weakSelf.numLab1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.numLab0);
                make.right.equalTo(weakSelf.Button1).with.offset(-2);
                make.width.mas_offset(flowidth+6);
                make.height.mas_offset(16);
            }];
            
        }
    }
    
    if ([topcardnum intValue]==0||topcardnum.length==0) {
        [self.numLab2 setHidden:YES];
    }
    else
    {
        [self.numLab2 setHidden:NO];
        self.numLab2.text = topcardnum?:@"";
        
        if (topcardnum.length>2) {
            CGFloat flowidth = [self clwidth:topcardnum];
            [weakSelf.numLab2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.numLab0);
                make.right.equalTo(weakSelf.Button2).with.offset(-10);
                make.width.mas_offset(flowidth+6);
                make.height.mas_offset(16);
            }];
        }
    }
}

-(void)delloudspeakersClick
{
    [self showredsNum];
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
        NSLog(@"页面pop成功了");
        
        if (self.returnBack) {
            //将自己的值传出去，完成传值
            self.returnBack();
        }
    }
}

-(CGFloat)clwidth:(NSString*)string
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 10) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.numLab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.Button0);
        make.right.equalTo(weakSelf.Button0).with.offset(-2);
        make.width.mas_offset(16);
        make.height.mas_offset(16);
    }];
    [weakSelf.numLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.numLab0);
        make.right.equalTo(weakSelf.Button1).with.offset(-2);
        make.width.mas_offset(16);
        make.height.mas_offset(16);
    }];
    [weakSelf.numLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.numLab0);
        make.right.equalTo(weakSelf.Button2).with.offset(-10);
        make.width.mas_offset(16);
        make.height.mas_offset(16);
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self vhl_setNavBarBackgroundColor:[UIColor whiteColor]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self vhl_setNavBarShadowImageHidden:YES];
    [self vhl_setNavBarBackgroundColor:[UIColor colorWithHexString:@"B73ACB" alpha:1]];
}

#pragma mark - Lazy Load

- (NSArray *)pageContentArray {
    if (!_pageContentArray) {
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        LDGiveGifListPageViewController *v1 = [[LDGiveGifListPageViewController alloc] init];
        LDGiveGifListPageViewController *v2 = [[LDGiveGifListPageViewController alloc] init];
        LDGiveGifListPageViewController *v3 = [[LDGiveGifListPageViewController alloc] init];
        [arrayM addObject:v1];
        [arrayM addObject:v2];
        [arrayM addObject:v3];
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
    }
    return _pageContentArray;
}

-(UILabel *)numLab0
{
    if(!_numLab0)
    {
        _numLab0 = [[UILabel alloc] init];
        _numLab0.backgroundColor = [UIColor redColor];
        _numLab0.textAlignment = NSTextAlignmentCenter;
        _numLab0.font = [UIFont systemFontOfSize:10];
        _numLab0.textColor = [UIColor whiteColor];
        _numLab0.layer.masksToBounds = YES;
        _numLab0.layer.cornerRadius = 8;
    }
    return _numLab0;
}

-(UILabel *)numLab1
{
    if(!_numLab1)
    {
        _numLab1 = [[UILabel alloc] init];
        _numLab1.backgroundColor = [UIColor redColor];
        _numLab1.textAlignment = NSTextAlignmentCenter;
        _numLab1.font = [UIFont systemFontOfSize:10];
        _numLab1.textColor = [UIColor whiteColor];
        _numLab1.layer.masksToBounds = YES;
        _numLab1.layer.cornerRadius = 8;
    }
    return _numLab1;
}

-(UILabel *)numLab2
{
    if(!_numLab2)
    {
        _numLab2 = [[UILabel alloc] init];
        _numLab2.backgroundColor = [UIColor redColor];
        _numLab2.textAlignment = NSTextAlignmentCenter;
        _numLab2.font = [UIFont systemFontOfSize:10];
        _numLab2.textColor = [UIColor whiteColor];
        _numLab2.layer.masksToBounds = YES;
        _numLab2.layer.cornerRadius = 8;
    }
    return _numLab2;
}




//生成翻页控制器
-(void)createPageViewController{
    
    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(1)};
    //    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options:options];
    _pageViewController.view.backgroundColor = [UIColor colorWithHexString:@"#222222" alpha:1];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    LDGiveGifListPageViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
//    _index = 0;
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height);
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(LDGiveGifListPageViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDGiveGifListPageViewController *)viewController];
    
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
    
    _GiveGifListPageViewController = (LDGiveGifListPageViewController *)pendingViewControllers[0];
    
}
//翻页动画执行完成后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (finished) {
        
        if (completed) {
            NSInteger index = [self.pageContentArray indexOfObject:_GiveGifListPageViewController];
            [self changeNavButtonColor:index];
            
        }else{
            
            NSInteger index = [self.pageContentArray indexOfObject:previousViewControllers[0]];
            [self changeNavButtonColor:index];
        }
    }
}

#pragma mark - 根据index得到对应的UIViewController

- (LDGiveGifListPageViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        
        return nil;
    }
    LDGiveGifListPageViewController *contentVC = self.pageContentArray[index];
    contentVC.content = [NSString stringWithFormat:@"%ld",(long)index];
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(LDGiveGifListPageViewController *)viewController {
    
    return [viewController.content integerValue];
}

//改变导航栏上按钮的颜色
-(void)changeNavButtonColor:(NSInteger)index{
    
    UIButton *button = (UIButton *)[self.view viewWithTag:index + 100];
    for (int i = 100; i < 103; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        UIView *view = (UIView *)[self.view viewWithTag:i + 100];
        if (button.tag == btn.tag) {
            
            view.hidden = NO;
            
        }else{
            
            view.hidden = YES;
        }
    }
}

- (IBAction)buttonClick:(UIButton *)sender {
    
    LDGiveGifListPageViewController *initialViewController = [self viewControllerAtIndex:sender.tag - 100];// 得到对应页
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    if (sender.tag == 100) {
        [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    else
    {
        [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    [self changeNavButtonColor:sender.tag - 100];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
