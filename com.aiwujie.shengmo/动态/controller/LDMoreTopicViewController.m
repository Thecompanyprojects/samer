//
//  LDMoreTopicViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/24.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDMoreTopicViewController.h"
#import "LDMyTopicViewController.h"
#import "LDMoreTopicPageViewController.h"

@interface LDMoreTopicViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDMoreTopicPageViewController *topicPageViewController;
@end

@implementation LDMoreTopicViewController

- (NSArray *)pageContentArray {
    if (!_pageContentArray) {
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        
        LDMoreTopicPageViewController *v1 = [[LDMoreTopicPageViewController alloc] init];
        LDMoreTopicPageViewController *v2 = [[LDMoreTopicPageViewController alloc] init];
        LDMoreTopicPageViewController *v3 = [[LDMoreTopicPageViewController alloc] init];
        LDMoreTopicPageViewController *v4 = [[LDMoreTopicPageViewController alloc] init];
        LDMoreTopicPageViewController *v5 = [[LDMoreTopicPageViewController alloc] init];
        LDMoreTopicPageViewController *v6 = [[LDMoreTopicPageViewController alloc] init];
        LDMoreTopicPageViewController *v7 = [[LDMoreTopicPageViewController alloc] init];
        LDMoreTopicPageViewController *v8 = [[LDMoreTopicPageViewController alloc] init];
   
        [arrayM addObject:v1];
        [arrayM addObject:v2];
        [arrayM addObject:v3];
        [arrayM addObject:v4];
        [arrayM addObject:v5];
        [arrayM addObject:v6];
        [arrayM addObject:v7];
        [arrayM addObject:v8];
        
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
        
    }
    return _pageContentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"话题分类";
    self.view.backgroundColor = [UIColor whiteColor];
    //生成翻页控制器
    [self createPageViewController];
    
    //创建话题button
    [self createTopTopic];
    
    [self createButton];
}

-(void)createTopTopic{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    NSArray *array = @[@"推荐",@"杂谈",@"兴趣",@"爆照",@"交友",@"生活",@"情感",@"官方"];
    
//    CGFloat btnX = 10;
    
    for (int i = 0; i < array.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(5 + i * (WIDTH - 10)/8, 0, (WIDTH - 10)/8, 40);
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        //计算btn上的文字的cgsize
        CGSize titleSize = [array[i] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize]}];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((btn.frame.size.width - titleSize.width)/2 , 36, titleSize.width , 2)];
        
        view.backgroundColor = [UIColor colorWithHexString:@"#333333" alpha:1];
        
        view.tag = 200 + i;
        
        if (i == 0) {
            
            view.hidden = NO;
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }else{
            
            view.hidden = YES;
            
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        
        [btn setTitle:array[i] forState:UIControlStateNormal];
        
        btn.tag = 100 + i;
        
        [btn addTarget:self action:@selector(btnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //重要的是下面这部分哦！
//        CGSize titleSize = [array[i] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize]}];
//        
//        titleSize.height = 20;
//        titleSize.width += 20;
        
//        btn.frame = CGRectMake(btnX, 10, titleSize.width, titleSize.height);
        
//        btnX = btnX + titleSize.width;
        
        //        btn.backgroundColor = [UIColor blackColor];
        
//        if (i == 7) {
        
        scrollView.contentSize = CGSizeMake(WIDTH, 0);
//        }
        
        [btn addSubview:view];
        
        [scrollView addSubview:btn];
    }
    
    [self.view addSubview:scrollView];
    
}

-(void)btnButtonClick:(UIButton *)sender{
    
    LDMoreTopicPageViewController *initialViewController = [self viewControllerAtIndex:sender.tag - 100];// 得到对应页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    [self changeNavButtonColor:sender.tag - 100];
}


//生成翻页控制器
-(void)createPageViewController{
    
    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(1)};
    //    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options:options];
    _pageViewController.view.backgroundColor = [UIColor whiteColor];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    LDMoreTopicPageViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    //    _index = 0;
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height);
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDMoreTopicPageViewController *)viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDMoreTopicPageViewController *)viewController];
    
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
    
    _topicPageViewController = (LDMoreTopicPageViewController *)pendingViewControllers[0];
    
}
//翻页动画执行完成后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (finished) {
        
        if (completed) {
            
            NSInteger index = [self.pageContentArray indexOfObject:_topicPageViewController];
            
            //            _index = index;
            
            [self changeNavButtonColor:index];
            
        }else{
            
            NSInteger index = [self.pageContentArray indexOfObject:previousViewControllers[0]];
            
            //            _index = index;
            
            [self changeNavButtonColor:index];
        }
    }
}

#pragma mark - 根据index得到对应的UIViewController

- (LDMoreTopicPageViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        
        return nil;
    }
    
    LDMoreTopicPageViewController *contentVC = self.pageContentArray[index];
    
    contentVC.content = [NSString stringWithFormat:@"%ld",(long)index];
    
    contentVC.type = @"MoreTopic";
    
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(LDMoreTopicPageViewController *)viewController {
    
    return [viewController.content integerValue];
    
}

//改变导航栏上按钮的颜色
-(void)changeNavButtonColor:(NSInteger)index{
    
    UIButton *button = (UIButton *)[self.view viewWithTag:index + 100];
    
    //    _index = index;
    
    for (int i = 100; i < 108; i++) {
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        
        UIView *view = (UIView *)[self.view viewWithTag:100 + i];
        
        if (btn.tag == button.tag) {
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            view.hidden = NO;
            
            
        }else{
            
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            view.hidden = YES;
        }
    }
}


-(void)createButton{

    UIButton * publishTopicButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [publishTopicButton setBackgroundImage:[UIImage imageNamed:@"发布话题"] forState:UIControlStateNormal];
    [publishTopicButton addTarget:self action:@selector(publishButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:publishTopicButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)publishButtonOnClick{
    
    LDMyTopicViewController *tvc = [[LDMyTopicViewController alloc] init];
    
    tvc.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    
    tvc.state = @"发布的话题";
    
    [self.navigationController pushViewController:tvc animated:YES];
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
