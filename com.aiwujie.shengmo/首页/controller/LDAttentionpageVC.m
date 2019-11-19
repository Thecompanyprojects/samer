//
//  LDAttentionpageVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/8.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDAttentionpageVC.h"
#import "LDAttentionListViewController.h"
#import "LDAttentionnewpageVC.h"
#import "LDAttentionsetVC.h"
#import "LDAttentionsearchVC.h"
#import "LDAttentiongroupModel.h"


@interface LDAttentionpageVC ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UITextFieldDelegate,UIScrollViewDelegate>
//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDAttentionnewpageVC *memberPageViewController;

@property (nonatomic,strong) UIView *navView;
@property (nonatomic,strong) UIButton *nearButton;
@property (nonatomic,strong) UIButton *hotButton;
@property (nonatomic,strong) UIButton *friendButton;
@property (nonatomic,strong) UIView *nearView;
@property (nonatomic,strong) UIView *hotView;
@property (nonatomic,strong) UIView *friendView;
@property (nonatomic,strong) UIButton *tagsBtn;
@property (nonatomic,strong) UIView *tagsView;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) UIScrollView *topicView;
@property (nonatomic,assign) NSInteger topicIndex;

@property (nonatomic,strong) NSMutableArray *tagsArray;
@property (nonatomic,strong) UITextField *search;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) NSMutableArray *groupArray;

@property (nonatomic,assign) BOOL isfromset;

@property (nonatomic,assign) BOOL iswithQiao;
@end

@implementation LDAttentionpageVC

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.groupArray = [NSMutableArray array];
    [self getgroupDatafromweb];
    [self createNavButtn];

    [self createTopTopic];
    [self rightbtns];
    
    if (self.isMine) {
        self.search = [[UITextField alloc] initWithFrame:CGRectMake(6, 6, WIDTH-12, 32)];
        self.search.layer.masksToBounds = YES;
        self.search.layer.cornerRadius = 12;
        [self.view addSubview:self.search];
        self.search.backgroundColor = [UIColor colorWithHexString:@"EDEEF0" alpha:1];
        self.search.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *leftPhoneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (self.search.frame.size.height - 20)*0.5, 30, 13)];
        leftPhoneImgView.image = [UIImage imageNamed:@"搜索用户"];
        leftPhoneImgView.contentMode = UIViewContentModeScaleAspectFit;
        self.search.leftView = leftPhoneImgView;
        self.search.placeholder = @"搜索";
        self.search.returnKeyType = UIReturnKeySearch;
        self.search.delegate = self;
        self.search.clearButtonMode=UITextFieldViewModeWhileEditing;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:@"qiaoqiaoguanzhu" object:nil];

}

-(void)notice:(NSNotification *)sender{
    NSLog(@"%@",sender);
    NSString *str = sender.object;
    if ([str intValue]==1) {
        self.iswithQiao = YES;
    }
    else
    {
        self.iswithQiao = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    LDAttentionsearchVC *searchVC = [[LDAttentionsearchVC alloc] init];
    searchVC.name = textField.text;
//    if ([self.type intValue]==0&&self.iswithQiao) {
//        searchVC.type = @"3";
//    }
//    else
//    {
        searchVC.type = self.type.mutableCopy;
//    }
    [self.navigationController pushViewController:searchVC animated:YES];
    return YES;
}

-(void)createNavButtn{
    
    if (ISIPHONEX) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, WIDTH - 160, 88)];
    }else{
        _navView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, WIDTH - 160, 64)];
    }
    _navView.backgroundColor = [UIColor clearColor];
    [self.navigationController.view addSubview:_navView];
    
    CGFloat spotH = 2;
    CGFloat spotW = 38;
    
    _nearButton = [[UIButton alloc] init];
    if (self.isMine) {
        _nearButton.frame = CGRectMake(0, [self getIsIphoneXNAV:ISIPHONEX], _navView.frame.size.width/4, 30);
    }
    else
    {
        _nearButton.frame = CGRectMake(0, [self getIsIphoneXNAV:ISIPHONEX], _navView.frame.size.width/3, 30);
    }
    [_nearButton setTitle:@"关注" forState:UIControlStateNormal];
    [_nearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_nearButton addTarget:self action:@selector(nearButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _nearButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _nearButton.tag = 20;
    [_navView addSubview:_nearButton];
    
    _nearView = [[UIView alloc] init];
    if (self.isMine) {
        _nearView.frame = CGRectMake(_navView.frame.size.width/(2 * 4) - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH);
    }
    else
    {
        _nearView.frame = CGRectMake(_navView.frame.size.width/6 - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH);
    }
    _nearView.backgroundColor = MainColor;
    _nearView.layer.cornerRadius = spotH/2;
    _nearView.hidden = YES;
    _nearView.clipsToBounds = YES;
    [_navView addSubview:_nearView];
    
    _hotButton = [[UIButton alloc] init];
    if (self.isMine) {
        _hotButton.frame = CGRectMake(_navView.frame.size.width/4, [self getIsIphoneXNAV:ISIPHONEX],_navView.frame.size.width/4, 30);
    }
    else
    {
        _hotButton.frame = CGRectMake(_navView.frame.size.width/3, [self getIsIphoneXNAV:ISIPHONEX],_navView.frame.size.width/3, 30);
    }
    [_hotButton setTitle:@"粉丝" forState:UIControlStateNormal];
    _hotButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_hotButton addTarget:self action:@selector(hotButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_hotButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _hotButton.tag = 21;
    [_navView addSubview:_hotButton];
    
    _hotView = [[UIView alloc] init];
    if (self.isMine) {
        self.hotView.frame = CGRectMake(_navView.frame.size.width/4 + _navView.frame.size.width/(2 * 4) - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH);
    }
    else
    {
        self.hotView.frame = CGRectMake(_navView.frame.size.width/3 + _navView.frame.size.width/6 - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH);
    }
    _hotView.backgroundColor = MainColor;
    _hotView.layer.cornerRadius = spotH/2;
    _hotView.hidden = YES;
    _hotView.clipsToBounds = YES;
    [_navView addSubview:_hotView];
    
    _friendButton = [[UIButton alloc] init];
    if (self.isMine) {
        self.friendButton.frame = CGRectMake(_navView.frame.size.width/4 * 2, [self getIsIphoneXNAV:ISIPHONEX],_navView.frame.size.width/4, 30);
    }
    else
    {
        self.friendButton.frame = CGRectMake(_navView.frame.size.width/3 * 2, [self getIsIphoneXNAV:ISIPHONEX],_navView.frame.size.width/3, 30);
    }
    [_friendButton setTitle:@"好友" forState:UIControlStateNormal];
    _friendButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_friendButton addTarget:self action:@selector(friendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_friendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _friendButton.tag = 22;
    [_navView addSubview:_friendButton];
    
    _friendView = [[UIView alloc] init];
    if (self.isMine) {
        self.friendView.frame = CGRectMake(_navView.frame.size.width/4 * 2 + _navView.frame.size.width/(2 * 4) - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH);
    }
    else
    {
        self.friendView.frame = CGRectMake(_navView.frame.size.width/3 * 2 + _navView.frame.size.width/6 - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH);
    }
    _friendView.backgroundColor = MainColor;
    _friendView.layer.cornerRadius = spotH/2;
    _friendView.hidden = YES;
    _friendView.clipsToBounds = YES;
    [_navView addSubview:_friendView];

    
    if (self.isMine) {
        _tagsBtn = [[UIButton alloc] initWithFrame:CGRectMake(_navView.frame.size.width/4 * 3, [self getIsIphoneXNAV:ISIPHONEX],_navView.frame.size.width/4, 30)];
        [_tagsBtn setTitle:@"分组" forState:normal];
        _tagsBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_tagsBtn setTitleColor:[UIColor lightGrayColor] forState:normal];
        _tagsBtn.tag = 23;
        [_tagsBtn addTarget:self action:@selector(tagsButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_tagsBtn];

        _tagsView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/4 * 3 + _navView.frame.size.width/(2 * 4) - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
        _tagsView.backgroundColor = MainColor;
        _tagsView.layer.cornerRadius = spotH/2;
        _tagsView.hidden = YES;
        _tagsView.clipsToBounds = YES;
        [_navView addSubview:_tagsView];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _navView.hidden = NO;
    [self vhl_setNavBarShadowImageHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navView.hidden = YES;
    [self vhl_setNavBarShadowImageHidden:NO];
}

/**
 * 生成翻页控制器
 */
-(void)createPageViewController{
    // 设置UIPageViewController的配置项
    
    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    
    LDAttentionListViewController *v1 = [[LDAttentionListViewController alloc] init];
    LDAttentionListViewController *v2 = [[LDAttentionListViewController alloc] init];
    LDAttentionListViewController *v3 = [[LDAttentionListViewController alloc] init];
    
    LDAttentionnewpageVC *newVC = [[LDAttentionnewpageVC alloc] init];
    if (self.isMine) {
        [arrayM addObject:newVC];
    }
    [arrayM addObject:v1];
    [arrayM addObject:v2];
    [arrayM addObject:v3];
    
    if (self.groupArray.count!=0) {
        for (int i = 0; i < self.groupArray.count-1; i++) {
            LDAttentionListViewController *v = [[LDAttentionListViewController alloc] init];
            [arrayM addObject:v];
        }
    }
    
    _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
    
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(1)};
    
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options:options];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    LDAttentionnewpageVC *initialViewController = (LDAttentionnewpageVC*)[self viewControllerAtIndex:0];// 得到第一页
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    // 设置UIPageViewController 尺寸
    if (self.isMine) {
         _pageViewController.view.frame = CGRectMake(0,44, WIDTH, self.view.frame.size.height-44);
    }
    else
    {
         _pageViewController.view.frame = CGRectMake(0,0, WIDTH, self.view.frame.size.height);
    }
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    if (self.isfromset) {
        [self topButtonClick:self.tagsBtn];
    }
    else
    {
        if (self.isguanzhu) {
            [self topButtonClick:self.nearButton];
        }
        else
        {
            [self topButtonClick:self.hotButton];
        }
    }
}

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(LDAttentionnewpageVC *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

#pragma mark 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(LDAttentionnewpageVC *)viewController];
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
    _memberPageViewController = (LDAttentionnewpageVC *)pendingViewControllers[0];
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
    LDAttentionnewpageVC *contentVC = self.pageContentArray[index];
    contentVC.type = [NSString stringWithFormat:@"%lu",index];
    contentVC.userID = self.userID;
    if (index>=3) {
        if (self.groupArray.count!=0) {
            LDAttentiongroupModel *model = [self.groupArray objectAtIndex:index-3];
            contentVC.fgid = model.Newid;
        }
    }
    contentVC.isfromGuanzhu = self.isfromGuanzhu;
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

-(NSUInteger)indexOfViewController:(LDAttentionnewpageVC *)viewController {
    return [viewController.type integerValue];
}

#pragma mark - 点击事件

//按钮点击时间切换页面
- (void)topButtonClick:(UIButton *)sender {
    [self changeLineHidden:sender.tag - 20];
    LDAttentionnewpageVC *initialViewController = (LDAttentionnewpageVC*)[self viewControllerAtIndex:sender.tag - 20];// 得到对应页
    _index = sender.tag - 20;
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

//改变文字下细线的显示隐藏
-(void)changeLineHidden:(NSInteger)index{
    
    if (index==0) {
        [self.nearButton setTitleColor:MainColor forState:normal];
        [self.hotButton setTitleColor:TextCOLOR forState:normal];
        [self.friendButton setTitleColor:TextCOLOR forState:normal];
        [self.tagsBtn setTitleColor:TextCOLOR forState:normal];
        self.nearView.hidden = NO;
        self.hotView.hidden = YES;
        self.friendView.hidden = YES;
        self.tagsView.hidden = YES;
        self.topicView.hidden = YES;
    }
    if (index==1) {
        [self.nearButton setTitleColor:TextCOLOR forState:normal];
        [self.hotButton setTitleColor:MainColor forState:normal];
        [self.friendButton setTitleColor:TextCOLOR forState:normal];
        [self.tagsBtn setTitleColor:TextCOLOR forState:normal];
        self.nearView.hidden = YES;
        self.hotView.hidden = NO;
        self.friendView.hidden = YES;
        self.tagsView.hidden = YES;
        self.topicView.hidden = YES;
    }
    if (index==2) {
        [self.nearButton setTitleColor:TextCOLOR forState:normal];
        [self.hotButton setTitleColor:TextCOLOR forState:normal];
        [self.friendButton setTitleColor:MainColor forState:normal];
        [self.tagsBtn setTitleColor:TextCOLOR forState:normal];
        self.nearView.hidden = YES;
        self.hotView.hidden = YES;
        self.friendView.hidden = NO;
        self.tagsView.hidden = YES;
        self.topicView.hidden = YES;
    }
    if (index==3) {
        [self.nearButton setTitleColor:TextCOLOR forState:normal];
        [self.hotButton setTitleColor:TextCOLOR forState:normal];
        [self.friendButton setTitleColor:TextCOLOR forState:normal];
        [self.tagsBtn setTitleColor:MainColor forState:normal];
        self.nearView.hidden = YES;
        self.hotView.hidden = YES;
        self.friendView.hidden = YES;
        self.tagsView.hidden = NO;
        self.topicView.hidden = YES;
    }
    if (index>=3) {
        
        [self.topicView setHidden:NO];
        [self.search setHidden:YES];
        [self.rightBtn setHidden:NO];
    }
    else
    {

        [self.rightBtn setHidden:YES];
        [self.topicView setHidden:YES];
        [self.search setHidden:NO];
     
    }
    if (index>=3) {
        
        UIButton *button = (UIButton *)[self.topicView viewWithTag:index - 3 + 300];
        for (int j = 300; j < 300+self.groupArray.count; j++) {
            UIButton *btn = (UIButton *)[self.topicView viewWithTag:j];
            UIView *view = (UIView *)[self.topicView viewWithTag:j + 100];
            if (button.tag == btn.tag) {
                btn.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                view.hidden = NO;
                if (btn.tag>=303) {
                    CGFloat width = ((WIDTH - 10)/6);
                    [self.topicView setContentOffset:CGPointMake(width*(btn.tag-302), 0) animated:YES];
                    self.topicView.bouncesZoom = NO;
                }
                else
                {
                    [self.topicView setContentOffset:CGPointMake(0, 0) animated:YES];
                    self.topicView.bouncesZoom = NO;
                }
            }else{
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                view.hidden = YES;
            }
        }
    }
}

//关注
-(void)nearButtonClick
{
    [self topButtonClick:self.nearButton];
}

//粉丝
-(void)hotButtonClick
{
    [self topButtonClick:self.hotButton];
}

//好友
-(void)friendButtonClick
{
    [self topButtonClick:self.friendButton];
}

//标签
-(void)tagsButtonClick
{
    [self topButtonClick:self.tagsBtn];
}

/**
 * 创建第四页话题页
 */
-(void)createTopTopic{
//    if (!self.topicView) {
        self.topicView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 48)];
        self.topicView.backgroundColor = [UIColor whiteColor];
        self.topicView.hidden = YES;
        self.topicView.contentSize = CGSizeMake(WIDTH+240, 48);
        self.topicView.delegate = self;
        if (self.topicView.superview == nil) {
             [self.view addSubview:self.topicView];
        }
    
//    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    

}
/**
 * 话题处的按钮点击事件
 */
-(void)btnButtonClick:(UIButton *)button{
    self.topicIndex = button.tag + 3 - 300;
    LDAttentionnewpageVC *initialVC = (LDAttentionnewpageVC *)[self viewControllerAtIndex:button.tag + 3 - 300];// 得到对应页
    NSArray *viewControllers = [NSArray arrayWithObject:initialVC];
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    [self changeLineHidden:button.tag + 3 - 300];
}

-(void)rightbtns
{
    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [self.rightBtn setTitle:@"设置" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:TextCOLOR forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightBtn setHidden:YES];
    [self.rightBtn addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)rightButtonOnClick
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue]==1) {
        LDAttentionsetVC *setVC = [[LDAttentionsetVC alloc] init];
        setVC.Returnback = ^{
            __weak typeof (self) weakSelf = self;
            weakSelf.isfromset = YES;
            [weakSelf getgroupDatafromweb];
            weakSelf.isfromGuanzhu = YES;
        };
        [self.navigationController pushViewController:setVC animated:YES];
    }
    else
    {
        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"分组设置限SVIP可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
            [self.navigationController pushViewController:mvc animated:YES];
        }];
        [control addAction:action0];
        [control addAction:action1];
        [self presentViewController:control animated:YES completion:nil];
    }
}

#pragma mark - 分组

-(void)getgroupDatafromweb
{
    self.groupArray = [NSMutableArray array];
    NSString *url = [PICHEADURL stringByAppendingString:getfriendgrouplistUrl];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSDictionary *params = @{@"uid":uid};
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
        
            NSArray *data = [NSArray yy_modelArrayWithClass:[LDAttentiongroupModel class] json:responseObj[@"data"]];
            [self.groupArray addObjectsFromArray:data];
            [self.topicView  removeFromSuperview];
            [self createTopTopic];
            NSMutableArray *array = [NSMutableArray new];
            for (int i = 0; i<self.groupArray.count; i++) {
                LDAttentiongroupModel *model = [self.groupArray objectAtIndex:i];
                NSString *name = model.fgname;
                [array addObject:name];
            }
            
            [self createPageViewController];
        
            if (self.groupArray.count>6) {
                CGFloat width = ((WIDTH - 10)/6)*(self.groupArray.count-6);
                self.topicView.contentSize = CGSizeMake(WIDTH+width, 48);
            }
            else
            {
                self.topicView.contentSize = CGSizeMake(WIDTH, 48);
            }
        
            for (int i = 0; i < array.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(5 + i * (WIDTH - 10)/6, 11, (WIDTH - 10)/6, 28);
                btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 13;
                
                if (i == 0) {
                    btn.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }else{
                    
                    btn.backgroundColor = [UIColor whiteColor];
                    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                }
                [btn setTitle:array[i] forState:UIControlStateNormal];
                btn.tag = 300 + i;
                [btn addTarget:self action:@selector(btnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.topicView addSubview:btn];
            }
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

@end

