//
//  LDDynamicPageVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/17.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDDynamicPageVC.h"
#import "LDDynamicPageViewController.h"

@interface LDDynamicPageVC()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

//翻页控制器
@property (nonatomic, strong)  UIPageViewController *pageViewController;
@property (nonatomic, strong)  NSArray *pageContentArray;
@property (nonatomic, strong)  LDDynamicPageViewController *memberPageViewController;

@property (strong, nonatomic)  UIView *topView;
@property (nonatomic,strong)   UIButton *leftBtn;
@property (nonatomic,strong)   UIButton *rightBtn;

@property (nonatomic,strong)   UILabel *leftLab;
@property (nonatomic,strong)   UILabel *rightLab;

//显示目前在哪个界面
@property (nonatomic,assign)   NSInteger index;
@property (nonatomic,  copy)   NSString *dyTopNumStr;
@property (nonatomic,  copy)   NSString *dyRecommendNumStr;

@end

@implementation LDDynamicPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"精选";
    [self.view addSubview:self.topView];
    _index = 0;
    [self createPageViewController];
    
    self.dyRecommendNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"dyRecommendNum"];
    self.dyTopNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"dyTopNum"];
    
    [self showredclick];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dyTopNum) name:@"dyTopNum" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NewdynamicBadge) name:@"dynamicBadge" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showheadView:) name:@"showheadView" object:nil];
}

-(void)dyTopNum
{
    self.dyTopNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"dyTopNum"];
    [self showredclick];
}

-(void)NewdynamicBadge
{
    self.dyRecommendNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"dyRecommendNum"];
    [self showredclick];
}

- (void)showheadView:(NSNotification *)notification{
    NSString * infostr = [notification object];
    if ([infostr intValue]==0) {
       
        [UIView animateWithDuration:0.3 animations:^{
            self.pageViewController.view.transform = CGAffineTransformIdentity;
            self.topView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        if ([infostr intValue]==1) {
            [UIView animateWithDuration:0.3 animations:^{
                self.pageViewController.view.transform = CGAffineTransformMakeTranslation(0, -48);
                self.topView.transform = CGAffineTransformMakeTranslation(0, -48);
            } completion:^(BOOL finished) {
                
            }];
        }
        if ([infostr intValue]==2) {
            [UIView animateWithDuration:0.3 animations:^{
                self.pageViewController.view.transform = CGAffineTransformMakeTranslation(0, -48);
                self.topView.transform = CGAffineTransformMakeTranslation(0, -48);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

-(void)showredclick
{
    if (self.dyTopNumStr.length==0||[self.dyTopNumStr isEqualToString:@"0"]) {
        [self.rightLab setHidden:YES];
    }
    else
    {
        [self.rightLab setHidden:NO];
        if ([self.dyTopNumStr intValue]>99) {
            
            CGFloat flowidth = [self clwidth:self.dyTopNumStr];
         
            if (ISIPHONEPLUS) {
                self.rightLab.frame = CGRectMake(163, 5, flowidth+6, 16);
            }
            else
            {
                self.rightLab.frame = CGRectMake(153, 5, flowidth+6, 16);
            }
        }
        else
        {
            if (ISIPHONEPLUS) {
                self.rightLab.frame = CGRectMake(163, 5, 16, 16);
            }
            else
            {
                self.rightLab.frame = CGRectMake(153, 5, 16, 16);
            }
            
        }
    }
    self.rightLab.text = self.dyTopNumStr?:@"";
    
    if (self.dyRecommendNumStr.length==0||[self.dyRecommendNumStr isEqualToString:@"0"]) {
        [self.leftLab setHidden:YES];
        
    }
    else
    {
        [self.leftLab setHidden:NO];
        if ([self.dyRecommendNumStr intValue]>99) {
            CGFloat flowidth = [self clwidth:self.dyRecommendNumStr];
            self.leftLab.frame = CGRectMake(73, 5, flowidth+6, 16);
        }
        else
        {
            self.leftLab.frame = CGRectMake(73, 5, 16, 16);
        }
    }
    self.leftLab.text = self.dyRecommendNumStr?:@"";
}

-(CGFloat)clwidth:(NSString*)string
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 10) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

-(UIView *)topView
{
    if(!_topView)
    {
        _topView = [[UIView alloc] init];
        _topView.frame = CGRectMake(0, 0, WIDTH, 48);
        [_topView addSubview:self.leftBtn];
        [_topView addSubview:self.rightBtn];
        [_topView addSubview:self.leftLab];
        [_topView addSubview:self.rightLab];
    }
    return _topView;
}

-(UIButton *)leftBtn
{
    if(!_leftBtn)
    {
        _leftBtn = [[UIButton alloc] init];
        _leftBtn.frame = CGRectMake(25, 10, 60, 28);
        [_leftBtn setTitle:@"推荐" forState:normal];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:normal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _leftBtn.tag = 20;
        [_leftBtn addTarget:self action:@selector(leftclick) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
        _leftBtn.layer.masksToBounds = YES;
        _leftBtn.layer.cornerRadius = 14;
    }
    return _leftBtn;
}

-(UIButton *)rightBtn
{
    if(!_rightBtn)
    {
        _rightBtn = [[UIButton alloc] init];
        if (ISIPHONEPLUS) {
            _rightBtn.frame = CGRectMake(116, 10, 60, 28);
        }else
        {
            _rightBtn.frame = CGRectMake(106, 10, 60, 28);
        }
        [_rightBtn setTitleColor:[UIColor colorWithHexString:@"B9B9B9" alpha:1] forState:normal];
        [_rightBtn setTitle:@"推顶" forState:normal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _rightBtn.tag = 21;
        [_rightBtn addTarget:self action:@selector(rightclick) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.backgroundColor = [UIColor colorWithHexString:@"B9B9B9" alpha:1];
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.layer.cornerRadius = 14;
        _rightBtn.layer.borderColor = [UIColor colorWithHexString:@"F5F5F5" alpha:1].CGColor;
        _rightBtn.layer.borderWidth = 1.5;
    
    }
    return _rightBtn;
}

-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
//        _leftLab.frame = CGRectMake(73, 5, 16, 16);
        _leftLab.layer.masksToBounds = YES;
        _leftLab.layer.cornerRadius = 8;
        _leftLab.backgroundColor = [UIColor redColor];
        _leftLab.textColor = [UIColor whiteColor];
        _leftLab.font = [UIFont systemFontOfSize:10];
        _leftLab.textAlignment = NSTextAlignmentCenter;
    }
    return _leftLab;
}

-(UILabel *)rightLab
{
    if(!_rightLab)
    {
        _rightLab = [[UILabel alloc] init];
//        if (ISIPHONEPLUS) {
//            _rightLab.frame = CGRectMake(163, 5, 16, 16);
//        }
//        else
//        {
//            _rightLab.frame = CGRectMake(153, 5, 16, 16);
//        }
        _rightLab.layer.masksToBounds = YES;
        _rightLab.layer.cornerRadius = 8;
        _rightLab.backgroundColor = [UIColor redColor];
        _rightLab.textColor = [UIColor whiteColor];
        _rightLab.font = [UIFont systemFontOfSize:10];
        _rightLab.textAlignment = NSTextAlignmentCenter;
    }
    return _rightLab;
}



- (NSArray *)pageContentArray {
    
    if (!_pageContentArray) {
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        LDDynamicPageViewController *v1 = [[LDDynamicPageViewController alloc] init];
        LDDynamicPageViewController *v2 = [[LDDynamicPageViewController alloc] init];
        v1.isLeftchoose = YES;
        v2.isLeftchoose = NO;
        v1.isfromPage = YES;
        v2.isfromPage = YES;
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
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options:options];
    // 设置UIPageViewController代理和数据源
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    LDDynamicPageViewController *initialViewController = (LDDynamicPageViewController*)[self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    // 设置UIPageViewController 尺寸
    self.pageViewController.view.frame = CGRectMake(0, 48, WIDTH, self.view.frame.size.height-48);
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self topButtonClick:self.leftBtn];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(LDDynamicPageViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

#pragma mark 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDDynamicPageViewController *)viewController];
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
     [[NSNotificationCenter defaultCenter] postNotificationName:@"showheadView" object:@"0"];
    _memberPageViewController = (LDDynamicPageViewController *)pendingViewControllers[0];
    
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

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        return nil;
    }
    LDDynamicPageViewController *contentVC = self.pageContentArray[index];
    contentVC.content = [NSString stringWithFormat:@"%lu",index];
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(LDDynamicPageViewController *)viewController {
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
        self.leftBtn.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
        self.rightBtn.backgroundColor = [UIColor whiteColor];
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:normal];
        [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"b9b9b9" alpha:1] forState:normal];
        self.leftBtn.layer.borderWidth = 0.01f;
        self.rightBtn.layer.borderWidth = 1.5;
        self.rightBtn.layer.borderColor = [UIColor colorWithHexString:@"F5F5F5" alpha:1].CGColor;
//        [self.leftBtn setTitleColor:MainColor forState:normal];
//        [self.rightBtn setTitleColor:TextCOLOR forState:normal];
//        [self.leftBtn setImage:[UIImage imageNamed:@"小推荐紫"] forState:normal];
//        [self.rightBtn setImage:[UIImage imageNamed:@"小推顶灰"] forState:normal];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isfromtop" object:@"0"];
    }
    else
    {
        self.leftBtn.backgroundColor = [UIColor whiteColor];
        self.rightBtn.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
        [self.leftBtn setTitleColor:[UIColor colorWithHexString:@"b9b9b9" alpha:1] forState:normal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:normal];
        self.rightBtn.layer.borderWidth = 0.01f;
        self.leftBtn.layer.borderWidth = 1.5;
        self.leftBtn.layer.borderColor = [UIColor colorWithHexString:@"F5F5F5" alpha:1].CGColor;
        
       
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isfromtop" object:@"1"];
        
//        [self.leftBtn setTitleColor:TextCOLOR forState:normal];
//        [self.rightBtn setTitleColor:MainColor forState:normal];
//        [self.leftBtn setImage:[UIImage imageNamed:@"小推荐灰"] forState:normal];
//        [self.rightBtn setImage:[UIImage imageNamed:@"小推顶紫"] forState:normal];
        
    }
}

@end
