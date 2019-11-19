//
//  LDDynamicViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/18.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDDynamicViewController.h"
#import "LDMemberViewController.h"
#import "LDBindingPhoneNumViewController.h"
#import "LDPublishDynamicViewController.h"
#import "LDGiveGifListViewController.h"
#import "LDDynamicPageViewController.h"
#import "LDMyTopicViewController.h"
#import "LDDynamicPageVC.h"

@interface LDDynamicViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDDynamicPageVC *dynamicPageViewController;
//动态的角标
@property (nonatomic, assign) NSInteger index;
//话题的角标
@property (nonatomic, assign) NSInteger topicIndex;
@property (nonatomic,strong) UIButton *nearButton;
@property (nonatomic,strong) UIButton *hotButton;
@property (nonatomic,strong) UIButton *attentButton;
@property (nonatomic,strong) UIButton *mineButton;
@property (nonatomic,strong) UIView *nearView;
@property (nonatomic,strong) UIView *hotView;
@property (nonatomic,strong) UIView *attentView;
@property (nonatomic,strong) UIView *mineView;
@property (nonatomic,strong) UIView *navView;
//话题的view
@property (nonatomic,strong) UIView *topicView;
//最新右上角的红点
@property (nonatomic,strong) UILabel *newestDogLabel;
//关注右上角的红点
@property (nonatomic,strong) UILabel *attentDogLabel;
//推荐右上角的红点
@property (nonatomic,strong) UILabel *recommendDogLabel;
//大喇叭右上角的红点
@property (nonatomic,strong) UILabel *hornDogView;
//置顶按钮
@property (nonatomic,strong) UIButton *topButton;
//发布动态按钮
@property (nonatomic,strong) UIButton *publishDynamicButton;
//是否可以发布动态
@property (nonatomic,copy) NSString *publishComment;
//动态筛选
@property (strong, nonatomic) UIButton *dynamicButton;
//搜索背景
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,assign) BOOL isSelect;
//根据我的性取向展示感兴趣的人
@property (nonatomic,strong) UILabel *searchLabel;
@property (nonatomic,assign) BOOL isfromTops;
@property (nonatomic,assign) BOOL iscanUser;
@property (nonatomic,assign) BOOL isshowhornDogView;
@end

@implementation LDDynamicViewController

#pragma mark - Lazy Load

- (NSArray *)pageContentArray {
    if (!_pageContentArray) {
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        LDDynamicPageVC *pagevc = [LDDynamicPageVC new];
        [arrayM addObject:pagevc];
        for (int i = 0; i < 10; i++) {
            LDDynamicPageViewController *v = [[LDDynamicPageViewController alloc] init];
            [arrayM addObject:v];
        }
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
    }
    return _pageContentArray;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navView.hidden = NO;
    [self vhl_setNavBarShadowImageHidden:YES];
    self.isshowhornDogView = YES;
    
    [[LDFromwebManager defaultTool] createDataLat];
    [[LDFromwebManager defaultTool] getloudspeakersRed];
    
    //请求是否能够发布动态的状态
    [self createPublishCommentData];
    [self createHornUnreadData];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"followBadge"] integerValue] > 0) {
        self.attentDogLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"followBadge"]];
        self.attentDogLabel.hidden = NO;
    }else{
        self.attentDogLabel.hidden = YES;
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicBadge"] integerValue] > 0) {
        self.newestDogLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicBadge"]];
        self.newestDogLabel.hidden = NO;
       // [self.tabBarController.tabBar showBadgeOnItemIndex:3];
    }else{
        self.newestDogLabel.hidden = YES;
        [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
    }
    
    //判定动态筛选是否开启
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"动态筛选"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"动态筛选"] intValue] == 0) {
        
        if (self.index >= 3) {
            self.dynamicButton.hidden = NO;
            [self.dynamicButton setImage:[UIImage imageNamed:@"发布话题"] forState:UIControlStateNormal];
            
        }else{
            if (self.index == 1||self.index == 0) {
                self.dynamicButton.hidden = NO;
                [self.dynamicButton setImage:[UIImage imageNamed:@"条件筛选"] forState:UIControlStateNormal];
            }else{
                self.dynamicButton.hidden = YES;
            }
        }
        UIButton *btn = (UIButton *)[_backgroundView viewWithTag:20];
        [btn setTitleColor:MainColor forState:UIControlStateNormal];
    }else{
        
        if (self.index >= 3) {
            self.dynamicButton.hidden = NO;
            [self.dynamicButton setImage:[UIImage imageNamed:@"发布话题"] forState:UIControlStateNormal];
        }else{
            if (self.index == 1||self.index == 0) {
                self.dynamicButton.hidden = NO;
                [self.dynamicButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
            }else{
                self.dynamicButton.hidden = YES;
            }
        }

        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSex"] intValue] == 1 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSexual"] intValue] == 0){
            
            UIButton *btn = (UIButton *)[_backgroundView viewWithTag:21];
            
            [btn setTitleColor:MainColor forState:UIControlStateNormal];
            
        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSex"] intValue] == 2 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSexual"] intValue] == 0){
            
            UIButton *btn = (UIButton *)[_backgroundView viewWithTag:22];
            
            [btn setTitleColor:MainColor forState:UIControlStateNormal];
            
        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSex"] intValue] == 3 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSexual"] intValue] == 0){
            
            UIButton *btn = (UIButton *)[_backgroundView viewWithTag:23];
            
            [btn setTitleColor:MainColor forState:UIControlStateNormal];
            
        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSex"] intValue] != 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSexual"] intValue] != 0){
            
            _searchLabel.textColor = MainColor;
        }
    }
}

//获取大喇叭右上角的红点是否有
-(void)createHornUnreadData{
    if (!self.isshowhornDogView) {
        return;
    }
    NSString *redallnum = [[NSUserDefaults standardUserDefaults] objectForKey:@"redallnum"];
    if ([redallnum intValue]==0||redallnum.length==0) {
        self.hornDogView.hidden = YES;
    }
    else
    {
        self.hornDogView.text = redallnum;
        if (redallnum.length>2) {
             CGFloat flowidth = [self clwidth:redallnum];
            if (ISIPHONEX) {
                self.hornDogView.frame = CGRectMake(39, 52, flowidth+6, 16);
            }else{

                self.hornDogView.frame = CGRectMake(39, 28, flowidth+6, 16);
            }
        }
        self.hornDogView.hidden = NO;
    }
}


-(CGFloat)clwidth:(NSString*)string
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 10) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavButtn];
    [self createButton];
    //生成翻页控制器
    [self createPageViewController];
    //创建置顶按钮和发布动态按钮
    [self createtopButtonAndPublishDynamicButton];
    //创建筛选界面
    [self createSearchView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearNewestDot) name:@"清除最新红点" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearfollowDot) name:@"清除关注红点" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearRecommendDot) name:@"清除推荐红点" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTopButton) name:@"隐藏置顶按钮" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTopButton) name:@"显示置顶按钮" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePublishDynamicButton) name:@"发布动态按钮隐藏" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPublishDynamicButton) name:@"发布动态按钮显示" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindPhoneNumSuccess) name:@"绑定手机号码成功" object:nil];
    
    //监听有没有新的动态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dynamicBadge) name:@"dynamicBadge" object:nil];
    
    //监听是否在推顶界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isfromtopClick:) name:@"isfromtop" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suspenshowView) name:SUPVIEWNOTIFICATION object:nil];
    
    //大喇叭红点
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loudspeakersClick) name:@"loudspeakers" object:nil];
    
    
}

/**
 * 监听有没有新的动态
 */
-(void)dynamicBadge{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"followBadge"] integerValue] > 0) {
        _attentDogLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"followBadge"]];
        _attentDogLabel.hidden = NO;
    }else{
        _attentDogLabel.hidden = YES;
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicBadge"] integerValue] > 0) {
        _newestDogLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicBadge"]];
        _newestDogLabel.hidden = NO;
    }else{
        _newestDogLabel.hidden = YES;
    }
    _recommendDogLabel.hidden = YES;
}

/**
 大喇叭红点
 */
-(void)loudspeakersClick
{
    if (!self.isshowhornDogView) {
        return;
    }
    NSString *redallnum = [[NSUserDefaults standardUserDefaults] objectForKey:@"redallnum"];
    if ([redallnum intValue]==0||redallnum.length==0) {
        self.hornDogView.hidden = YES;

    }
    else
    {
        if (redallnum.length>2) {
            CGFloat flowidth = [self clwidth:redallnum];
            if (ISIPHONEX) {
                self.hornDogView.frame = CGRectMake(39, 52, flowidth+6, 16);
            }else{

                self.hornDogView.frame = CGRectMake(39, 28, flowidth+6, 16);
            }
        }
        self.hornDogView.text = redallnum;
        self.hornDogView.hidden = NO;
    }
}

-(void)isfromtopClick:(NSNotification *)notification
{
    NSString *obj = notification.object;
    if ([obj intValue]==1) {
        [self.dynamicButton setHidden:YES];
        self.isfromTops = YES;
    }
    else
    {
        [self.dynamicButton setHidden:NO];
        self.isfromTops = NO;
    }
}

/**
 * 绑定手机号码成功的监听方法
 */
-(void)bindPhoneNumSuccess{
    
    _publishComment = @"YES";
}

//发布动态按钮隐藏
-(void)hidePublishDynamicButton{
    
    _publishDynamicButton.hidden = YES;
}

//发布动态按钮显示
-(void)showPublishDynamicButton{

    _publishDynamicButton.hidden = NO;
}

//隐藏置顶按钮
-(void)hideTopButton{
    
    _topButton.hidden = YES;
}

//显示置顶按钮
-(void)showTopButton{
    
    _topButton.hidden = NO;
}

//置顶按钮
-(void)createtopButtonAndPublishDynamicButton{
    
    CGFloat publishW = 106;
    CGFloat publishH = 44;
    CGFloat publishBottomY = 130;
    
    if (ISIPHONEX) {
        _publishDynamicButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - publishW)/2, HEIGHT - publishBottomY - publishH - 34 - 24, publishW, publishH)];

    }else{
        if (ISIPHONEPLUS) {
            _publishDynamicButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - (publishW / 375) * WIDTH)/2, HEIGHT - publishBottomY - (publishH / 667) * HEIGHT, (publishW / 375) * WIDTH, (publishH / 667) * HEIGHT)];
            
        }else{
            _publishDynamicButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - publishW)/2, HEIGHT - publishBottomY - publishH, publishW, publishH)];
        }
    }
    [_publishDynamicButton setBackgroundImage:[UIImage imageNamed:@"发布动态按钮"] forState:UIControlStateNormal];
    [_publishDynamicButton addTarget:self action:@selector(publishDynamicButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_publishDynamicButton];
    if (ISIPHONEX) {
        _topButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 45, HEIGHT - publishBottomY - publishH - 34 - 24, publishH, publishH)];
    }else{
        if (ISIPHONEPLUS) {
            _topButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 45, HEIGHT - publishBottomY - (publishH / 667) * HEIGHT, (publishH / 667) * HEIGHT, (publishH / 667) * HEIGHT)];
        }else{
            _topButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 45, HEIGHT - publishBottomY - publishH, publishH, publishH)];
        }
    }
    [_topButton setBackgroundImage:[UIImage imageNamed:@"置顶按钮"] forState:UIControlStateNormal];
    [_topButton addTarget:self action:@selector(topButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _topButton.hidden = YES;
    [self.view addSubview:_topButton];
    
}

/**
 * 获取判断是否可以发布动态的状态
 */

-(void)createPublishCommentData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,judgeDynamicNewrdUrl];
    
    NSDictionary *parameters;
    
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        
        if (integer == 4003  || integer == 4004) {
            _publishComment = [NSString stringWithFormat:@"%@",[responseObj objectForKey:@"retcode"]];
            
        }else  if(integer == 2000){
            
            _publishComment = @"YES";
            
        }else if(integer == 3001){
            
            _publishComment = @"";
        }
        else if (integer==5000)
        {
            self.iscanUser = YES;
            _publishComment = [NSString stringWithFormat:@"%@",[responseObj objectForKey:@"msg"]];
        }
    } failed:^(NSString *errorMsg) {
         _publishComment = @"NO";
    }];
}


//点击发布动态按钮
-(void)publishDynamicButtonClick{
    
    if (_publishComment.length == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"根据国家网信部《互联网跟帖评论服务管理规定》要求，需要绑定手机号后才可以发布动态~"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"立即绑定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            LDBindingPhoneNumViewController *bpnc = [[LDBindingPhoneNumViewController alloc] init];
            
            [self.navigationController pushViewController:bpnc animated:YES];
            
        }];
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
            
            [action setValue:MainColor forKey:@"_titleTextColor"];
            
            [cancel setValue:MainColor forKey:@"_titleTextColor"];
        }
        
        [alert addAction:cancel];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }else{
        
        if ([_publishComment intValue] == 4003) {
        
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您好，您因违规暂时不能发布动态,具体解封时间请查看系统通知或联系客服~"];
            
        }else if ([_publishComment intValue] == 4004) {
            
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您好，普通用户每日发布动态限10条，VIP会员每日发布动态限30条~"];
            
           
        }else if ([_publishComment isEqualToString:@"YES"]){
                
                LDPublishDynamicViewController *dvc = [[LDPublishDynamicViewController alloc] init];
                
                [self.navigationController pushViewController:dvc animated:YES];
                
        }else if (self.iscanUser)
        {
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:self.publishComment];
        }
        else{
            
             [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"发生错误,请退出软件后重试~"];
        }
    }
}

//置顶按钮点击
-(void)topButtonClick{
    
    NSDictionary *dic = @{@"index":[NSString stringWithFormat:@"%ld",(long)_index]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"置顶动态" object:nil userInfo:dic];
}

//清除推荐红点
-(void)clearRecommendDot{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"dyRecommendNum"];
    _recommendDogLabel.hidden = YES;
    [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
}

//清除最新红点
-(void)clearNewestDot{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"dynamicBadge"];
    _newestDogLabel.hidden = YES;
    [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
}

//清除关注红点
-(void)clearfollowDot{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"followBadge"];
    
    _attentDogLabel.hidden = YES;
}

//创建动态筛选按钮下拉列表
-(void)createSearchView{
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
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
    NSArray *imageArray;
    NSArray *titleArray;
    imageArray = @[@[@""],@[@"查看全部",@"只看男",@"只看女",@"只看CDTS"],@"查看全部"];
    
    titleArray = @[@[@"筛选仅对“热推/广场”生效(vip)"],@[@"所有人",@"男",@"女",@"CDTS"],@"根据我的性取向展示感兴趣的动态"];
    
    for (int i = 0; i < 3; i++) {
        
        //没条的view
        UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, i * 44, WIDTH, 44)];
        
        searchView.backgroundColor = [UIColor whiteColor];
        
        [_backgroundView addSubview:searchView];
        
        if (i == 2) {
            
            //图片
            UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 17, 17)];
            
            searchImage.image = [UIImage imageNamed:imageArray[i]];
            
            [searchView addSubview:searchImage];
            
            //标题
            UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 9, 250, 24)];
            
            _searchLabel = searchLabel;

            searchLabel.text = titleArray[i];
            
            searchLabel.font = [UIFont systemFontOfSize:15];
            
            searchLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
            
            [searchView addSubview:searchLabel];
            
            //点击事件
            UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 43)];
            
            [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            searchButton.tag = 10 + i;
            
            [searchView addSubview:searchButton];
            
            //箭头
            UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - 20, 15, 7, 13)];
            
            rightArrow.image = [UIImage imageNamed:@"youjiantou"];
            
            [searchView addSubview:rightArrow];
            
        }else if(i == 1){
            
            for (int j = 0; j < [imageArray[i] count]; j++) {
                
                //标题
                UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - 20)/4 * j + 10, 10, (WIDTH - 20)/4, 24)];
                
                [searchButton setTitle:titleArray[i][j] forState:UIControlStateNormal];
                
                [searchButton setImage:[UIImage imageNamed:imageArray[i][j]] forState:UIControlStateNormal];
                
                [searchButton setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1] forState:UIControlStateNormal];
                
                searchButton.tag = 20 + j;
                
                [searchButton addTarget:self action:@selector(singleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                
                searchButton.titleEdgeInsets = UIEdgeInsetsMake(2, 5, 0, 0);
                
                searchButton.titleLabel.font = [UIFont systemFontOfSize:15];
                
                [searchView addSubview:searchButton];
            }
            
        }else if(i == 0){
        
            UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, WIDTH - 26, 44)];
            
            showLabel.text = titleArray[i][0];
            
            showLabel.textAlignment = NSTextAlignmentCenter;
            
            showLabel.textColor = [UIColor lightGrayColor];
            
            showLabel.font = [UIFont systemFontOfSize:15];
            
            [searchView addSubview:showLabel];
        }
        
        //中间线
        UIView *searchLine = [[UIView alloc] initWithFrame:CGRectMake(12, i * 43, WIDTH, 1)];
        
        searchLine.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
        
        [_backgroundView addSubview:searchLine];

    }
}

//点击背景隐藏筛选界面
-(void)tapClick{
    
    if (_isSelect) {
        
        _backgroundView.alpha = 0;
        
        _isSelect = NO;
        
    }
}

//点击筛选的相应按钮
-(void)singleButtonClick:(UIButton *)button{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1) {
        
        //改变筛选详细的按钮颜色
        [self changeScreenColor:button];
        
        if (button.tag == 20) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"dynamicSex"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"dynamicSexual"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"动态筛选"];
            
            _isSelect = NO;
            
            self.backgroundView.alpha = 0;
            
            [self.dynamicButton setImage:[UIImage imageNamed:@"条件筛选"] forState:UIControlStateNormal];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"确定动态筛选" object:nil];
            
        }else if (button.tag == 21){
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"动态筛选"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"dynamicSex"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"dynamicSexual"];
            
            [self.dynamicButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
            
            _isSelect = NO;
            
            self.backgroundView.alpha = 0;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"确定动态筛选" object:nil];
            
        }else if (button.tag == 22){
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"动态筛选"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"dynamicSex"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"dynamicSexual"];
            
            [self.dynamicButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
            
            _isSelect = NO;
            
            self.backgroundView.alpha = 0;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"确定动态筛选" object:nil];
            
        }else if (button.tag == 23){
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"动态筛选"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"dynamicSex"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"dynamicSexual"];
            
            [self.dynamicButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
            
            _isSelect = NO;
            
            self.backgroundView.alpha = 0;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"确定动态筛选" object:nil];
        }
        
    }else{
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"动态筛选功能VIP会员可用哦~"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"开通会员" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
            [self.navigationController pushViewController:mvc animated:YES];
        }];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
        
        [alert addAction:cancelAction];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}


-(void)searchButtonClick:(UIButton *)button{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1) {
        
        if(button.tag == 12){
            //改变筛选详细的按钮颜色
            [self changeScreenColor:button];
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSex"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSexual"] length] == 0) {
                 [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请退出软件重新登陆后使用此功能~"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"动态筛选"];
                [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSexual"] forKey:@"dynamicSex"];
                [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSex"] forKey:@"dynamicSexual"];
                [self.dynamicButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
                _isSelect = NO;
                self.backgroundView.alpha = 0;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"确定动态筛选" object:nil];
            }
        }
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"动态筛选功能VIP会员可用哦~"    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"开通会员" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
            [self.navigationController pushViewController:mvc animated:YES];
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
        [alert addAction:cancelAction];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//改变筛选按钮点击后的颜色
-(void)changeScreenColor:(UIButton *)button{
    
    if (button.tag == 12) {
        _searchLabel.textColor = MainColor;
        for (int i = 20; i < 24; i++) {
            UIButton *btn = (UIButton *)[_backgroundView viewWithTag:i];
            [btn setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1] forState:UIControlStateNormal];
        }
    }else{
        for (int i = 20; i < 24; i++) {
            UIButton *btn = (UIButton *)[_backgroundView viewWithTag:i];
            if (btn.tag == button.tag) {
                [button setTitleColor:MainColor forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1] forState:UIControlStateNormal];
            }
        }
        _searchLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    }
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
    
    LDDynamicPageVC *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    _index = 0;
    
    _topicIndex = 3;
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    //创建话题button
    [self createTopTopic];
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
} 
/**
 * 创建第四页话题页
 */
-(void)createTopTopic{
    
    _topicView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 48)];
    _topicView.backgroundColor = [UIColor whiteColor];
    NSArray *array = @[@"推荐",@"杂谈",@"兴趣",@"爆照",@"交友",@"生活",@"情感",@"官方"];
    
    for (int i = 0; i < array.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(5 + i * (WIDTH - 10)/8, 11, (WIDTH - 10)/8, 28);
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 13;
        
        //计算btn上的文字的cgsize
//        CGSize titleSize = [array[i] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize]}];
        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((btn.frame.size.width - titleSize.width)/2 , 36, titleSize.width , 2)];
//
//        view.backgroundColor = [UIColor colorWithHexString:@"#333333" alpha:1];
//
//        view.tag = 400 + i;
        
        if (i == 0) {
            
//            view.hidden = NO;
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }else{
            
//            view.hidden = YES;
            
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        
        [btn setTitle:array[i] forState:UIControlStateNormal];
        
        btn.tag = 300 + i;
        
        [btn addTarget:self action:@selector(btnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
       // [btn addSubview:view];
        
        [_topicView addSubview:btn];
    }
    
    [self.view addSubview:_topicView];
    
}

/**
 * 话题处的按钮点击事件
 */
-(void)btnButtonClick:(UIButton *)button{
    _topicIndex = button.tag + 3 - 300;
    LDDynamicPageVC *initialViewController = [self viewControllerAtIndex:button.tag + 3 - 300];// 得到对应页
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    [self changeNavButtonColor:button.tag + 3 - 300];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDDynamicPageVC *)viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDDynamicPageVC *)viewController];
    
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
    
    _dynamicPageViewController = (LDDynamicPageVC *)pendingViewControllers[0];
}

//翻页动画执行完成后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (finished) {
        
        if (completed) {
            
            NSInteger index = [self.pageContentArray indexOfObject:_dynamicPageViewController];
            if (index >= 3) {
                _pageViewController.view.frame = CGRectMake(0, 48, self.view.frame.size.width, self.view.frame.size.height);
                _topicIndex = index;
            }else{
                _pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            }
            
            [self changeNavButtonColor:index];
            
        }else{
            
            NSInteger index = [self.pageContentArray indexOfObject:previousViewControllers[0]];
            
            if (index >= 3) {
                
                _pageViewController.view.frame = CGRectMake(0, 48, self.view.frame.size.width, self.view.frame.size.height);
                
                _topicIndex = index;
                
            }else{
                
                _pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                
            }
            
            [self changeNavButtonColor:index];
        }
    }
}

#pragma mark - 根据index得到对应的UIViewController

- (LDDynamicPageVC *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        return nil;
    }
    LDDynamicPageVC *contentVC = self.pageContentArray[index];
    contentVC.content = [NSString stringWithFormat:@"%ld",(long)index];
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(LDDynamicPageVC *)viewController {
    return [viewController.content integerValue];
}

-(void)createNavButtn{
    
    if (ISIPHONEX) {
         self.navView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, WIDTH - 120, 88)];
    }else{
        
         self.navView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, WIDTH - 120, 64)];
    }
    self.navView.backgroundColor = [UIColor clearColor];
    [self.navigationController.view addSubview:self.navView];
    
    int buttonNum = 4;
    CGFloat spotH = 2;
    CGFloat spotW = 38;
    
    _hotButton = [[UIButton alloc] initWithFrame:CGRectMake(0, [self getIsIphoneXNAV:ISIPHONEX], _navView.frame.size.width/buttonNum, 30)];
    _hotButton.tag = 100;
    [_hotButton setTitle:@"热推" forState:UIControlStateNormal];
    [_hotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_hotButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _hotButton.titleLabel.font = [UIFont systemFontOfSize:21];
    _hotButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    

    [_navView addSubview:_hotButton];
    
    _hotView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/(2 * buttonNum) - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    _hotView.tag = 200;
    _hotView.backgroundColor = [UIColor blackColor];
    _hotView.layer.cornerRadius = spotH/2;
    _hotView.hidden = NO;
    _hotView.clipsToBounds = YES;
    [_navView addSubview:_hotView];
    
    //推荐右上角红点
    _recommendDogLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_hotButton.frame) - _hotButton.frame.size.width/2 + 13, [self getIsIphoneXNAVRightDog:ISIPHONEX], 16, 16)];
    _recommendDogLabel.backgroundColor = [UIColor redColor];
    _recommendDogLabel.textColor = [UIColor whiteColor];
    _recommendDogLabel.textAlignment = NSTextAlignmentCenter;
    _recommendDogLabel.font = [UIFont systemFontOfSize:8];
    _recommendDogLabel.layer.cornerRadius = 8;
    _recommendDogLabel.hidden = YES;
    _recommendDogLabel.clipsToBounds = YES;
    [_navView addSubview:_recommendDogLabel];

    //最新按钮及下方紫点
    _attentButton = [[UIButton alloc] initWithFrame:CGRectMake(_navView.frame.size.width/buttonNum, [self getIsIphoneXNAV:ISIPHONEX],_navView.frame.size.width/buttonNum, 30)];
    _attentButton.tag = 101;
    [_attentButton setTitle:@"广场" forState:UIControlStateNormal];
    _attentButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_attentButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_attentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_navView addSubview:_attentButton];
    
    _attentView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/buttonNum + _navView.frame.size.width/(2 * buttonNum) - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    _attentView.tag = 201;
    _attentView.backgroundColor = [UIColor blackColor];
    _attentView.layer.cornerRadius = spotH/2;
    _attentView.hidden = YES;
    _attentView.clipsToBounds = YES;
    [_navView addSubview:_attentView];
    
    //最新按钮右上方红点
    _newestDogLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_attentButton.frame) - _attentButton.frame.size.width/2 + 13, [self getIsIphoneXNAVRightDog:ISIPHONEX], 16, 16)];
    _newestDogLabel.backgroundColor = [UIColor redColor];
    _newestDogLabel.textColor = [UIColor whiteColor];
    _newestDogLabel.textAlignment = NSTextAlignmentCenter;
    _newestDogLabel.font = [UIFont systemFontOfSize:8];
    _newestDogLabel.layer.cornerRadius = 8;
    _newestDogLabel.hidden = YES;
    _newestDogLabel.clipsToBounds = YES;
    [_navView addSubview:_newestDogLabel];
    
    //关注按钮及下方紫点
    _mineButton = [[UIButton alloc] initWithFrame:CGRectMake(_navView.frame.size.width/buttonNum * 2, [self getIsIphoneXNAV:ISIPHONEX],_navView.frame.size.width/buttonNum, 30)];
    _mineButton.tag = 102;
    [_mineButton setTitle:@"关注" forState:UIControlStateNormal];
    _mineButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_mineButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mineButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_navView addSubview:_mineButton];
    
    _mineView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/buttonNum * 2 + _navView.frame.size.width/(2 * buttonNum) - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    _mineView.tag = 202;
    _mineView.backgroundColor = [UIColor blackColor];
    _mineView.layer.cornerRadius = spotH/2;
    _mineView.hidden = YES;
    _mineView.clipsToBounds = YES;
    [_navView addSubview:_mineView];
    
    //关注按钮右上方红点
    _attentDogLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_mineButton.frame) - _mineButton.frame.size.width/2 + 13, [self getIsIphoneXNAVRightDog:ISIPHONEX], 16, 16)];
    _attentDogLabel.backgroundColor = [UIColor redColor];
    _attentDogLabel.textColor = [UIColor whiteColor];
    _attentDogLabel.textAlignment = NSTextAlignmentCenter;
    _attentDogLabel.font = [UIFont systemFontOfSize:8];
    _attentDogLabel.layer.cornerRadius = 8;
    _attentDogLabel.hidden = YES;
    _attentDogLabel.clipsToBounds = YES;
    [_navView addSubview:_attentDogLabel];
   
    _nearButton = [[UIButton alloc] initWithFrame:CGRectMake(_navView.frame.size.width/buttonNum * 3, [self getIsIphoneXNAV:ISIPHONEX],_navView.frame.size.width/buttonNum, 30)];
    _nearButton.tag = 103;
    [_nearButton setTitle:@"话题" forState:UIControlStateNormal];
    _nearButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_nearButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_nearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_navView addSubview:_nearButton];
    
    _nearView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/buttonNum * 3 + _navView.frame.size.width/(2 * buttonNum) - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    _nearView.tag = 203;
    _nearView.backgroundColor = [UIColor blackColor];
    _nearView.layer.cornerRadius = 3;
    _nearView.hidden = YES;
    _nearView.clipsToBounds = YES;
    [_navView addSubview:_nearView];
}

//点击导航栏处的按钮
-(void)navButtonClick:(UIButton *)button{
    
    if (button.tag == 103) {
        LDDynamicPageVC *initialViewController = [self viewControllerAtIndex:_topicIndex];// 得到对应页
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
        [self changeNavButtonColor:_topicIndex];
    }else{
        LDDynamicPageVC *initialViewController = [self viewControllerAtIndex:button.tag - 100];// 得到对应页
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
        [self changeNavButtonColor:button.tag - 100];
    }
}

//改变导航栏上按钮的颜色
-(void)changeNavButtonColor:(NSInteger)index{
    
    UIButton *btn0 = (UIButton *)[self.navView viewWithTag:100];
    UIButton *btn1 = (UIButton *)[self.navView viewWithTag:101];
    UIButton *btn2 = (UIButton *)[self.navView viewWithTag:102];
    UIButton *btn3 = (UIButton *)[self.navView viewWithTag:103];
    
    if (index==0) {
        btn0.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
        btn1.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
        btn2.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
        btn3.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    }
    if (index==1) {
        btn0.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
        btn1.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
        btn2.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
        btn3.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    }
    if (index==2) {
        btn0.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
        btn1.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
        btn2.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
        btn3.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    }
    if (index==3) {
        btn0.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
        btn1.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
        btn2.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
        btn3.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    }
    
    if (index >= 3) {
        _index = _topicIndex;
        self.dynamicButton.hidden = NO;
        _isSelect = NO;
        self.backgroundView.alpha = 0;
        [self.dynamicButton setImage:[UIImage imageNamed:@"发布话题"] forState:UIControlStateNormal];
        _pageViewController.view.frame = CGRectMake(0, 48, self.view.frame.size.width, self.view.frame.size.height);
        for (int i = 100; i < 104; i++) {
            UIButton *btn = (UIButton *)[self.navView viewWithTag:i];
            UIView *view = (UIView *)[self.navView viewWithTag:i + 100];
            if (btn.tag == 103) {
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                view.hidden = NO;
            }else{
                [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                view.hidden = YES;
            }
        }
        UIButton *button = (UIButton *)[_topicView viewWithTag:index - 3 + 300];
        for (int j = 300; j < 308; j++) {
            UIButton *btn = (UIButton *)[_topicView viewWithTag:j];
            UIView *view = (UIView *)[_topicView viewWithTag:j + 100];
            if (button.tag == btn.tag) {
                btn.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                view.hidden = NO;
            }else{
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                view.hidden = YES;
            }
        }
    }else{
        _index = index;
        if (_index == 1||_index==0) {
            self.dynamicButton.hidden = NO;
            
            if (index==0) {
                if (self.isfromTops) {
                    [self.dynamicButton setHidden:YES];
                }
                else
                {
                    [self.dynamicButton setHidden:NO];
                }
            }else
            {
                [self.dynamicButton setHidden:NO];
            }
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"动态筛选"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"动态筛选"] intValue] == 0) {
                [self.dynamicButton setImage:[UIImage imageNamed:@"条件筛选"] forState:UIControlStateNormal];
            }else{
                [self.dynamicButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
            }
        }else{
            self.dynamicButton.hidden = YES;
            _isSelect = NO;
            self.backgroundView.alpha = 0;
        }
        _pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        UIButton *button = (UIButton *)[self.navView viewWithTag:index + 100];
        for (int i = 100; i < 104; i++) {
            
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
}

-(void)createButton{
    
    UIButton * areaButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [areaButton setBackgroundImage:[UIImage imageNamed:@"大喇叭"] forState:UIControlStateNormal];
    areaButton.tag = 10;
    [areaButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    if (ISIPHONEX) {
        
        self.hornDogView = [[UILabel alloc] initWithFrame:CGRectMake(39, 52, 16, 16)];
        
    }else{
        
        self.hornDogView = [[UILabel alloc] initWithFrame:CGRectMake(39, 28, 16, 16)];
    }
    self.hornDogView.backgroundColor = [UIColor redColor];
    self.hornDogView.layer.cornerRadius = 8;
    self.hornDogView.hidden = YES;
    self.hornDogView.clipsToBounds = YES;
    self.hornDogView.textColor = [UIColor whiteColor];
    self.hornDogView.textAlignment = NSTextAlignmentCenter;
    self.hornDogView.font = [UIFont systemFontOfSize:10];
    [self.navigationController.view addSubview:self.hornDogView];
    
    self.dynamicButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [self.dynamicButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.dynamicButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)backButtonOnClick:(UIButton *)button{
    
    if (button.tag == 10) {
        LDGiveGifListViewController *gvc = [[LDGiveGifListViewController alloc] init];
        gvc.returnBack = ^{
            [[LDFromwebManager defaultTool] createRedlab];
        };
        self.hornDogView.hidden = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hornDog"];
        [self.navigationController pushViewController:gvc animated:YES];
    }else{
        
        if (_index >= 3) {
            LDMyTopicViewController *tvc = [[LDMyTopicViewController alloc] init];
            tvc.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            tvc.state = @"参与的话题";
            [self.navigationController pushViewController:tvc animated:YES];
        }else{
            if (_isSelect == NO) {
                _backgroundView.alpha = 1;
                _isSelect = YES;
            }else{
                _backgroundView.alpha = 0;
                _isSelect = NO;
            }
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self vhl_setNavBarShadowImageHidden:NO];
    self.navView.hidden = YES;
    self.hornDogView.hidden = YES;
    self.isshowhornDogView = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)suspenshowView
{
    int index = (int)[self.tabBarController selectedIndex];
    if (index==3) {
        ChatroomVC *vc = [[ChatroomVC alloc] init];
        vc.roomidStr = roomidStr;
        vc.popBlock = ^(NSString * _Nonnull popString) {
            
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
