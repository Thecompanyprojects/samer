//
//  LDGroupSpuareViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/14.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGroupSpuareViewController.h"
#import "LDGroupSearchSignViewController.h"
#import "LDCreateGroupViewController.h"
#import "LDGroupSpuarePageViewController.h"
#import "LDCreateGroupFailViewController.h"
#import "UITabBar+badge.h"
#import "ChatroomVC.h"

@interface LDGroupSpuareViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UISearchBarDelegate>
//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDGroupSpuarePageViewController *groupSpuarePageViewController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic,strong) UIButton *nearButton;
@property (nonatomic,strong) UIButton *hotButton;
@property (nonatomic,strong) UIButton *friendButton;
@property (nonatomic,strong) UIButton *newestButton;

@property (nonatomic,strong) UIView *nearView;
@property (nonatomic,strong) UIView *hotView;
@property (nonatomic,strong) UIView *friendView;
@property (nonatomic,strong) UIView *newestView;
@property (nonatomic,strong) UIView *navView;

//最新右上角的红点
@property (nonatomic,strong) UILabel *newestDogLabel;

//搜索背景
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,assign) BOOL isSelect;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

//查看全部
@property (nonatomic,strong) UILabel *searchLabel1;
//根据我的性取向展示感兴趣的人
@property (nonatomic,strong) UILabel *searchLabel2;

@end

@implementation LDGroupSpuareViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createNavButtn];
    
    [self createButton];
    
    [self createPageViewController];
    
    //创建筛选页面
    [self createSearchView];
    
    //判定群组筛选是否开启
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"群组筛选"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"群组筛选"] intValue] == 0) {
        
        [self.selectButton setImage:[UIImage imageNamed:@"条件筛选"] forState:UIControlStateNormal];
        
        _searchLabel1.textColor = MainColor;
        
        
    }else{
        
        [self.selectButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
        
        _searchLabel2.textColor = MainColor;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteGroupNew) name:@"groupNewDelete" object:nil];
    if (@available(iOS 13.0, *)) {
        self.searchBar.frame = CGRectMake(0, 0, WIDTH-40, 50);
    }
}

- (NSArray *)pageContentArray {
    if (!_pageContentArray) {
        
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        
        LDGroupSpuarePageViewController *v1 = [[LDGroupSpuarePageViewController alloc] init];
        LDGroupSpuarePageViewController *v2 = [[LDGroupSpuarePageViewController alloc] init];
        
        [arrayM addObject:v1];
        [arrayM addObject:v2];
        
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
        
    }
    return _pageContentArray;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _navView.hidden = NO;
    
    //判断是不是有新建的群
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"groupBadge"] length] == 0) {
        
        _newestDogLabel.hidden = YES;
        
    }else{
        
        _newestDogLabel.hidden = NO;
        
        _newestDogLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"groupBadge"]];
    }

}


//删除新群的红点
-(void)deleteGroupNew{

     [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"groupBadge"];
    
    _newestDogLabel.hidden = YES;
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
    
    LDGroupSpuarePageViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDGroupSpuarePageViewController *)viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

#pragma mark 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDGroupSpuarePageViewController *)viewController];
    
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
    
    _groupSpuarePageViewController = (LDGroupSpuarePageViewController *)pendingViewControllers[0];
    
}
//翻页动画执行完成后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (finished) {
        
        if (completed) {
            
            NSInteger index = [self.pageContentArray indexOfObject:_groupSpuarePageViewController];
            
            
            [self changeNavButtonColor:index];
            
        }else{
            
            NSInteger index = [self.pageContentArray indexOfObject:previousViewControllers[0]];
            
            [self changeNavButtonColor:index];
        }
        
    }
}

#pragma mark - 根据index得到对应的UIViewController

- (LDGroupSpuarePageViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        
        return nil;
    }
    
//    NSLog(@"%ld",index);
    
    LDGroupSpuarePageViewController *contentVC = self.pageContentArray[index];
    
    
    if (index == 0) {
        
        contentVC.content = @"0";
        
    }else if(index == 1){
        
        contentVC.content = @"2";
        
    }
    
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(LDGroupSpuarePageViewController *)viewController {

    
    if ([viewController.content intValue] == 0) {
        
        return [viewController.content integerValue];
        
    }
    
    return 1;
    
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
    
    //推荐
    _nearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, [self getIsIphoneXNAV:ISIPHONEX], _navView.frame.size.width/2, 30)];
    [_nearButton setTitle:@"热推" forState:UIControlStateNormal];
    [_nearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _nearButton.tag = 100;
    [_nearButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _nearButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_navView addSubview:_nearButton];
    
    _nearView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/4 - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    _nearView.backgroundColor = [UIColor blackColor];
    _nearView.tag = 200;
    _nearView.layer.cornerRadius = spotH/2;
    _nearView.hidden = NO;
    _nearView.clipsToBounds = YES;
    [_navView addSubview:_nearView];

    
    //我的
    _friendButton = [[UIButton alloc] initWithFrame:CGRectMake(_navView.frame.size.width/2, [self getIsIphoneXNAV:ISIPHONEX],_navView.frame.size.width/2, 30)];
    [_friendButton setTitle:@"我的" forState:UIControlStateNormal];
    _friendButton.tag = 101;
    _friendButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_friendButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_friendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_navView addSubview:_friendButton];
    
    _friendView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/2 + _navView.frame.size.width/4 - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    _friendView.backgroundColor = [UIColor blackColor];
    _friendView.tag = 201;
    _friendView.layer.cornerRadius = spotH/2;
    _friendView.hidden = YES;
    _friendView.clipsToBounds = YES;
    [_navView addSubview:_friendView];
}

//点击导航栏处的按钮
-(void)navButtonClick:(UIButton *)button{
    
    LDGroupSpuarePageViewController *initialViewController = [self viewControllerAtIndex:button.tag - 100];// 得到对应页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    [self changeNavButtonColor:button.tag - 100];
}

//改变导航栏上按钮的颜色
-(void)changeNavButtonColor:(NSInteger)index{
    UIButton *button = (UIButton *)[self.navView viewWithTag:index + 100];
    for (int i = 100; i < 100 + self.pageContentArray.count; i++) {
        UIButton *btn = (UIButton *)[self.navView viewWithTag:i];
        UIView *view = (UIView *)[self.navView viewWithTag:i + 100];
        if (button.tag == btn.tag) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            view.hidden = NO;
        }else{
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            view.hidden = YES;
        }
    }
}

-(void)createButton{
    //暂时关闭创建功能
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue]==1) {
        UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        [rightButton setTitle:@"创建" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightButton addTarget:self action:@selector(createGroupButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItems = @[rightBarButtonItem];
    }
}

//筛选按钮点击
- (IBAction)selectButtonClick:(id)sender {
    
    if (_isSelect == NO) {
        _backgroundView.alpha = 1;
        _isSelect = YES;
    }else{
        _backgroundView.alpha = 0;
        _isSelect = NO;
    }
}

//创建动态筛选按钮下拉列表
-(void)createSearchView{
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, WIDTH, HEIGHT)];
    
    _isSelect = NO;
    
    _backgroundView.alpha = 0;
    
    _backgroundView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_backgroundView];
    
    UIView *backgroundShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 2 * 44 - 1, WIDTH, HEIGHT - 2 * 44 + 1)];
    
    backgroundShadowView.backgroundColor = [UIColor blackColor];
    
    backgroundShadowView.alpha = 0.3;
    
    [_backgroundView addSubview:backgroundShadowView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    
    [_backgroundView addGestureRecognizer:tap];
    
    NSArray *imageArray = @[@"查看全部",@"查看全部"];
    
    NSArray *titleArray = @[@"查看全部群组",@"根据性取向展示感兴趣的群组"];
    
    for (int i = 0; i < imageArray.count; i++) {
        
        //没条的view
        UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, i * 44, WIDTH, 44)];
        
        searchView.backgroundColor = [UIColor whiteColor];
        
        [_backgroundView addSubview:searchView];
        
    
        //图片
        UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 17, 17)];
        
        searchImage.image = [UIImage imageNamed:imageArray[i]];
        
        [searchView addSubview:searchImage];
        
        //标题
        UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 9, 250, 24)];
        
        if (i == 0) {
            
            _searchLabel1 = searchLabel;
            
        }else if (i == 1){
        
            _searchLabel2 = searchLabel;
        }
        
        searchLabel.text = titleArray[i];
        
        searchLabel.font = [UIFont systemFontOfSize:15];
        
        searchLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
        
        [searchView addSubview:searchLabel];
        
        //点击事件
        UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        
        [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        searchButton.tag = 10 + i;
        
        [searchView addSubview:searchButton];
        
        //中间线
        UIView *searchLine = [[UIView alloc] initWithFrame:CGRectMake(12, i * 44, WIDTH, 1)];
        
        searchLine.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
        
        [_backgroundView addSubview:searchLine];
            
        //箭头
        UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - 20, 15, 7, 13)];
        
        rightArrow.image = [UIImage imageNamed:@"youjiantou"];
        
        [searchView addSubview:rightArrow];
        
    }
}

-(void)tapClick{
    
    if (_isSelect) {
        
        _backgroundView.alpha = 0;
        
        _isSelect = NO;
        
    }
}

-(void)searchButtonClick:(UIButton *)button{
    
    if(button.tag == 11){
        
        _searchLabel2.textColor = MainColor;
        
        _searchLabel1.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSex"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSexual"] length] == 0) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请退出软件重新登陆后使用此功能~"];
                        
        }else{
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"群组筛选"];
            
            
            [self.selectButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
            
            _isSelect = NO;
            
            self.backgroundView.alpha = 0;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"确定群组筛选" object:nil];
            
        }
    }else{
        
        _searchLabel1.textColor = MainColor;
        
        _searchLabel2.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"群组筛选"];
        
        _isSelect = NO;
        
        self.backgroundView.alpha = 0;
        
        [self.selectButton setImage:[UIImage imageNamed:@"条件筛选"] forState:UIControlStateNormal];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"确定群组筛选" object:nil];
        
    }
}

//创建群组按钮
-(void)createGroupButtonOnClick{
    
   if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1) {
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/addGroup"];
        
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
            if (integer == 4002 || integer == 4001 || integer == 5000) {
                LDCreateGroupFailViewController *gvc = [[LDCreateGroupFailViewController alloc] init];
                [self.navigationController pushViewController:gvc animated:YES];
            }else{
                LDCreateGroupViewController *gvc = [[LDCreateGroupViewController alloc] init];
                [self.navigationController pushViewController:gvc animated:YES];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }else{
        LDCreateGroupFailViewController *gvc = [[LDCreateGroupFailViewController alloc] init];
        [self.navigationController pushViewController:gvc animated:YES];
    }
    
    
}
- (IBAction)searchButtonClickToSearchSign:(id)sender {
    
    LDGroupSearchSignViewController *svc = [[LDGroupSearchSignViewController alloc] init];
    
    [self.navigationController pushViewController:svc animated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    _navView.hidden = YES;
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
