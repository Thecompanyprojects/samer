//
//  LDPopularityRankingViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/12.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDPopularityRankingViewController.h"
#import "LDRewardRankingPageViewController.h"

@interface LDPopularityRankingViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDRewardRankingPageViewController *rewardRankingPageViewController;


@property (nonatomic, assign) NSUInteger commentIndex;
@property (nonatomic, assign) NSUInteger zanIndex;
@property (nonatomic, assign) NSUInteger recommendIndex;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UIView *zanView;
@property (weak, nonatomic) IBOutlet UIButton *recommendButton;
@property (weak, nonatomic) IBOutlet UIView *recommendView;

@property (weak, nonatomic) IBOutlet UIButton *dayButton;
@property (weak, nonatomic) IBOutlet UIButton *weekButton;
@property (weak, nonatomic) IBOutlet UIButton *monthButton;
@property (weak, nonatomic) IBOutlet UIButton *allButton;

@end

@implementation LDPopularityRankingViewController

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
        LDRewardRankingPageViewController *v7 = [[LDRewardRankingPageViewController alloc] init];
        LDRewardRankingPageViewController *v8 = [[LDRewardRankingPageViewController alloc] init];
        
        LDRewardRankingPageViewController *v9 = [[LDRewardRankingPageViewController alloc] init];
        LDRewardRankingPageViewController *v10 = [[LDRewardRankingPageViewController alloc] init];
        LDRewardRankingPageViewController *v11 = [[LDRewardRankingPageViewController alloc] init];
        LDRewardRankingPageViewController *v12 = [[LDRewardRankingPageViewController alloc] init];
        
        [arrayM addObject:v1];
        [arrayM addObject:v2];
        [arrayM addObject:v3];
        [arrayM addObject:v4];
 
        [arrayM addObject:v5];
        [arrayM addObject:v6];
        [arrayM addObject:v7];
        [arrayM addObject:v8];
        
        [arrayM addObject:v9];
        [arrayM addObject:v10];
        [arrayM addObject:v11];
        [arrayM addObject:v12];
        
      
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
        
    }
    return _pageContentArray;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [self vhl_setNavBarBackgroundColor:[UIColor colorWithHexString:@"B73ACB" alpha:1]];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];

    [self vhl_setNavBarBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.commentView.layer.cornerRadius = 2;
    self.commentView.clipsToBounds = YES;
    
    self.zanView.layer.cornerRadius = 2;
    self.zanView.clipsToBounds = YES;
    
    self.recommendView.layer.cornerRadius = 2;
    self.recommendView.clipsToBounds = YES;
    
    if ([self.rankType isEqualToString:@"popularity"]) {
        
        self.navigationItem.title = @"人气榜";
        [self.commentButton setTitle:@"热评榜" forState:UIControlStateNormal];
        [self.zanButton setTitle:@"热赞榜" forState:UIControlStateNormal];
        [self.recommendButton setTitle:@"热推榜" forState:UIControlStateNormal];
        
    }else if ([self.rankType isEqualToString:@"diligence"]){
        
        self.navigationItem.title = @"活跃榜";
        [self.commentButton setTitle:@"点评榜" forState:UIControlStateNormal];
        [self.zanButton setTitle:@"点赞榜" forState:UIControlStateNormal];
        [self.recommendButton setTitle:@"动态榜" forState:UIControlStateNormal];

    }
    
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
    
    _commentIndex = 0;
    
    _zanIndex = 4;
    
    _recommendIndex = 8;
    
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
            
            if (index > 3 && index < 8) {
                
                self.commentView.hidden = YES;
                
                self.zanView.hidden = NO;
                
                self.recommendView.hidden = YES;
                
                _zanIndex = index;
                
                [self changeButtonClick:index - 4];
                
            }else if(index > 7 && index <12){
                
                self.commentView.hidden = YES;
                
                self.zanView.hidden = YES;
                
                self.recommendView.hidden = NO;
                
                _recommendIndex = index;
                
                [self changeButtonClick:index - 8];
                
            }else{
            
                //评论榜单
                self.commentView.hidden = NO;
                
                self.zanView.hidden = YES;
                
                self.recommendView.hidden = YES;
                
                _recommendIndex = index;
                
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
    
    for (int i = 14; i < 18; i++) {
        
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
    if ([self.rankType isEqualToString:@"popularity"]) {
        contentVC.type = @"popularity";
    }else if ([self.rankType isEqualToString:@"diligence"]){
        contentVC.type = @"diligence";
    }
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(LDRewardRankingPageViewController *)viewController {
    
    return [viewController.content integerValue];
    
}

- (IBAction)commentButtonClick:(id)sender {
    
    self.commentView.hidden = NO;
    self.zanView.hidden = YES;
    self.recommendView.hidden = YES;
    
    [self changeButtonClick:_commentIndex];
    
    LDRewardRankingPageViewController *initialViewController = [self viewControllerAtIndex:_commentIndex];// 得到当前页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

- (IBAction)zanButtonClick:(id)sender {
    
    [self changeButtonClick:_zanIndex - 4];
    
    LDRewardRankingPageViewController *initialViewController = [self viewControllerAtIndex:_zanIndex];// 得到当前页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    if (_commentView.hidden == NO) {
        
        [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
    }else{
    
        [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    
    self.commentView.hidden = YES;
    self.zanView.hidden = NO;
    self.recommendView.hidden = YES;
}

- (IBAction)recommendButtonClick:(id)sender {
    
    self.commentView.hidden = YES;
    self.zanView.hidden = YES;
    self.recommendView.hidden = NO;
    
    [self changeButtonClick:_recommendIndex - 8];
    
    LDRewardRankingPageViewController *initialViewController = [self viewControllerAtIndex:_recommendIndex];// 得到当前页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (IBAction)buttonClick:(UIButton *)sender {
    
    if (self.commentView.hidden == NO) {
        
        LDRewardRankingPageViewController *initialViewController = [self viewControllerAtIndex:sender.tag - 14];// 得到当前页
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        if (_commentIndex + 14 > sender.tag) {
            
            [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
            
        }else{
            
            [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
        
        _commentIndex = sender.tag - 14;
        
        [self changeButtonClick:sender.tag - 14];
        
    }else if(self.zanView.hidden == NO){
        
        LDRewardRankingPageViewController *initialViewController = [self viewControllerAtIndex:sender.tag - 10];// 得到当前页
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        if (_zanIndex + 10 > sender.tag) {
            
            [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
            
        }else{
            
            [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
        
        _zanIndex = sender.tag - 10;
        
        [self changeButtonClick:sender.tag - 14];
        
    }else{
    
        LDRewardRankingPageViewController *initialViewController = [self viewControllerAtIndex:sender.tag - 6];// 得到当前页
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        if (_recommendIndex + 6 > sender.tag) {
            
            [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
            
        }else{
            
            [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
        
        _recommendIndex = sender.tag - 6;
        
        [self changeButtonClick:sender.tag - 14];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
