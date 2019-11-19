//
//  LDMatchmakerViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/8/15.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDMatchmakerViewController.h"
#import "LDMatchmakerPageViewController.h"
#import "LDApplyMatchmakerViewController.h"

@interface LDMatchmakerViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDMatchmakerPageViewController *matchmakerPageViewController;

//右上角的切换按钮
@property (nonatomic, strong) UIButton *applyButton;

//底部的切换按钮
@property (nonatomic, strong) UIButton *bottomApplyButton;

@end

@implementation LDMatchmakerViewController

#pragma mark - Lazy Load

- (NSArray *)pageContentArray {
    if (!_pageContentArray) {
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        
        LDMatchmakerPageViewController *v1 = [[LDMatchmakerPageViewController alloc] init];
        LDMatchmakerPageViewController *v2 = [[LDMatchmakerPageViewController alloc] init];
        LDMatchmakerPageViewController *v3 = [[LDMatchmakerPageViewController alloc] init];
        
        [arrayM addObject:v1];
        [arrayM addObject:v2];
        [arrayM addObject:v3];
        
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
        
    }
    return _pageContentArray;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self createButtonTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"红娘牵线服务";
    
    [self createButton];
    
    //生成翻页控制器
    [self createPageViewController];
    
    //创建红娘底部按钮
    [self createBottomApplyButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideApplyDynamicButton) name:@"红娘申请按钮隐藏" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showApplyDynamicButton) name:@"红娘申请按钮显示" object:nil];
}

/**
 * 底部按钮的隐藏
 */
-(void)hideApplyDynamicButton{
    
    _bottomApplyButton.hidden = YES;
}

/**
 * 底部按钮的显示
 */
-(void)showApplyDynamicButton{
    
    _bottomApplyButton.hidden = NO;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 * 创建红娘底部按钮
 */
-(void)createBottomApplyButton{
    
    CGFloat publishW = 140;
    CGFloat publishH = 50;
    CGFloat publishBottomY = 126;
    
    if (ISIPHONEX) {
        
        _bottomApplyButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - publishW)/2, HEIGHT - publishBottomY - publishH - 34 - 24, publishW, publishH)];
        
        
    }else{
        
        if (ISIPHONEPLUS) {
            
            _bottomApplyButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - (publishW / 375) * WIDTH)/2, HEIGHT - publishBottomY - (publishH / 667) * HEIGHT, (publishW / 375) * WIDTH, (publishH / 667) * HEIGHT)];
            
        }else{
            
            _bottomApplyButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - publishW)/2, HEIGHT - publishBottomY - publishH, publishW, publishH)];
        }
    }
    
    [_bottomApplyButton setBackgroundImage:[UIImage imageNamed:@"红娘申请服务"] forState:UIControlStateNormal];
    
    [_bottomApplyButton addTarget:self action:@selector(applyButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_bottomApplyButton];
    
}

-(void)createButtonTitle{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Matchmaker/getMatchState"];
    NSDictionary *parameters = @{@"uid": [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            if ([responseObj[@"data"][@"match_state"] intValue] == 0) {
                [self.applyButton setTitle:@"申请服务" forState:UIControlStateNormal];
                
            }else{
                
                [self.applyButton setTitle:@"个人中心" forState:UIControlStateNormal];
            }
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"match_state"]] forKey:@"match_state"];
        }else{
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"获取服务状态失败~"];
            [self.applyButton setTitle:@"申请服务" forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"match_state"];
        }
    } failed:^(NSString *errorMsg) {
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"网络连接失败,请检查网络设置~"];
        [self.applyButton setTitle:@"申请服务" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"match_state"];
    }];

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
    
    LDMatchmakerPageViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height);
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDMatchmakerPageViewController *)viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDMatchmakerPageViewController *)viewController];
    
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
    
    _matchmakerPageViewController = (LDMatchmakerPageViewController *)pendingViewControllers[0];
    
}
//翻页动画执行完成后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (finished) {
        
        if (completed) {
            
            NSInteger index = [self.pageContentArray indexOfObject:_matchmakerPageViewController];
        
            [self changeNavButtonColor:index];
            
        }else{
            
            NSInteger index = [self.pageContentArray indexOfObject:previousViewControllers[0]];
            
            [self changeNavButtonColor:index];
        }
    }
}

#pragma mark - 根据index得到对应的UIViewController

- (LDMatchmakerPageViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        
        return nil;
    }
    
    LDMatchmakerPageViewController *contentVC = self.pageContentArray[index];
    
    contentVC.content = [NSString stringWithFormat:@"%ld",(long)index];
    
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(LDMatchmakerPageViewController *)viewController {
    
    return [viewController.content integerValue];
    
}
- (IBAction)navButtonClick:(UIButton *)sender {
    
    LDMatchmakerPageViewController *initialViewController = [self viewControllerAtIndex:sender.tag - 100];// 得到第一页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    [self changeNavButtonColor:sender.tag - 100];
}

//改变导航栏上按钮的颜色
-(void)changeNavButtonColor:(NSInteger)index{
    
    UIButton *button = (UIButton *)[self.view viewWithTag:index + 100];
    
    for (int i = 100; i < 103; i++) {
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        
        UIView *view = (UIView *)[self.view viewWithTag:i + 100];
        
        if (button.tag == btn.tag) {
            
            [button setTitleColor:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1] forState:UIControlStateNormal];
            view.hidden = NO;
            
        }else{
            
            [btn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
            view.hidden = YES;
        }
    }
}

-(void)createButton{
    
    self.applyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    [self.applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.applyButton setBackgroundColor:MainColor];
    self.applyButton.alpha = 0.7;
    self.applyButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.applyButton.layer.cornerRadius = 2;
    self.applyButton.clipsToBounds = YES;
    [self.applyButton addTarget:self action:@selector(applyButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.applyButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

-(void)applyButtonOnClick:(UIButton *)button{
    
    LDApplyMatchmakerViewController *mvc = [[LDApplyMatchmakerViewController alloc] init];
    
    mvc.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    
    mvc.title = self.applyButton.currentTitle;
    
    [self.navigationController pushViewController:mvc animated:YES];
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
