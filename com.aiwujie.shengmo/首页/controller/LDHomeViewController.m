//
//  LDHomeViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/18.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDHomeViewController.h"
#import "LDMemberViewController.h"
#import "LDLoginViewController.h"
#import "LDScreenViewController.h"
#import "LDModalH5ViewController.h"
#import "LDHomePageViewController.h"
#import "WUGesturesUnlockViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UITabBar+badge.h"
#import "LDSignView.h"
#import "LDswitchManager.h"

@interface LDHomeViewController ()<CLLocationManagerDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic,strong) CLLocationManager *locationManager;

//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDHomePageViewController *homePageViewController;

//导航栏上的背景view
@property (nonatomic,strong) UIView *navView;


//搜索背景
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) UILabel *openLabel;
@property (nonatomic,assign) BOOL isSelect;

//根据我的性取向展示感兴趣的人
@property (nonatomic,strong) UILabel *searchLabel;

//新人按钮右上方红点
@property (nonatomic,strong) UILabel *newestDogLabel;

//右上方按钮变化
@property (nonatomic,strong) UIButton *rightButton;

//置顶按钮
@property (nonatomic,strong) UIButton *topButton;

@property (nonatomic, assign) NSInteger index;

//展示广告图片页
//NSTIMER
@property (nonatomic,strong) NSTimer *timer;
//展示的倒计时图片
@property (nonatomic,strong) UIImageView *imageView;
//展示的倒计时时间
@property (nonatomic,assign) NSInteger time;
//展示的时间的button
@property (nonatomic,strong) UIButton *closeButton;
//存储展示倒计时的广告的字符串
@property (nonatomic,strong) NSString *url;
@property (nonatomic,copy) NSString *titleString;

@end

@implementation LDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建导航栏上方的按钮,紫点,红点
    [self createNavButtn];
    //生成翻页控制器
    [self createPageViewController];
    //创建搜索界面
    [self createSearchView];
    //创建置顶按钮和发布动态按钮
    [self createtopButton];
    //创建刚刚进入页面的时候的广告图片
    [self createTimeReducePic];
    
    //判断有无人查看来控制红点的显示与隐藏
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"lookBadge"] intValue] == 0) {
        
        [self.tabBarController.tabBar hideBadgeOnItemIndex:4];
        
    }else{
        
        [self.tabBarController.tabBar showBadgeOnItemIndex:4];
    }
    
    //判断是否签到
    [self judgeSignState];
    
    //判断是不是会员
    [[LDswitchManager sharedClient] getVipStatusData];
    
    //判断是否开启了手势锁
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"手势"] isEqualToString:@"yes"]) {
        
        WUGesturesUnlockViewController *vc = [[WUGesturesUnlockViewController alloc] initWithUnlockType:WUUnlockTypeValidatePwd];
        [self presentViewController:vc animated:YES completion:nil];
        
    }else{
        //判断是否有最新版本
        [self judgeVerson];
    }
    
    //创建个人信息提供者
    [self getUserInfomation];
    
    //初始化CLLocationManager并开始定位
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    CLLocationDistance distance = 0.0;
    _locationManager.distanceFilter = distance;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager startUpdatingLocation];
    
    //监听手势解锁成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validateSuccess) name:@"验证成功" object:nil];
    
    //    //监听有新建的群
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupBadge) name:@"groupBadge" object:nil];
    //
    //    //监听没有新建的群
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noGroupBadge) name:@"groupBadge1" object:nil];
    
    //监听有没有新的动态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dynamicBadge) name:@"dynamicBadge" object:nil];
    
    //    //监听新的群组刷新
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteGroupNew) name:@"groupNewDelete" object:nil];
    
    //监听是否有新人
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newestBadge) name:@"newestBadge" object:nil];
    
    //监听谁看过我
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookFangBadge) name:@"lookBadge" object:nil];
    
    //监听tabbar消息数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveMessage) name:@"badgeNumber" object:nil];
    
    //监听刷新清除红点
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteRedDot) name:@"清除新人红点" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTopButton) name:@"隐藏置顶附近按钮" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTopButton) name:@"显示置顶附近按钮" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suspenshowView) name:SUPVIEWNOTIFICATION object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self vhl_setNavBarShadowImageHidden:YES];
    //上传实时位置
    [[LDFromwebManager defaultTool] createDataLat];

    _navView.hidden = NO;
    
    //判断是否开启搜索切换按钮颜色
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"] integerValue] == 0) {
        
        [self.rightButton setImage:[UIImage imageNamed:@"条件筛选"] forState:UIControlStateNormal];
        
        UIButton *btn = (UIButton *)[_backgroundView viewWithTag:20];
        
        [self changeScreenColor:btn];
        
    }else{
        
        [self.rightButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sexButton"] intValue] == 1 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"sexualButton"] intValue] == 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"sexButton"] length] == 1){
            
            UIButton *btn = (UIButton *)[_backgroundView viewWithTag:21];
            
            [self changeScreenColor:btn];
            
        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sexButton"] intValue] == 2 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"sexualButton"] intValue] == 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"sexButton"] length] == 1){
            
            NSLog(@"%@,%d",[[NSUserDefaults standardUserDefaults] objectForKey:@"sexButton"],[[[NSUserDefaults standardUserDefaults] objectForKey:@"sexButton"] intValue]);
            
            UIButton *btn = (UIButton *)[_backgroundView viewWithTag:22];
            
            [self changeScreenColor:btn];
            
        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sexButton"] intValue] == 3 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"sexualButton"] intValue] == 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"sexButton"] length] == 1){
            
            UIButton *btn = (UIButton *)[_backgroundView viewWithTag:23];
            
            [self changeScreenColor:btn];
            
        }else{
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sexButton"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSexual"]] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"sexualButton"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSex"]]){
                
                UIButton *btn = (UIButton *)[_backgroundView viewWithTag:11];
                
                [self changeScreenColor:btn];
                
                
            }else{
                
                _searchLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
                
                for (int i = 20; i < 24; i++) {
                    
                    UIButton *btn = (UIButton *)[_backgroundView viewWithTag:i];
                    
                    [btn setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1] forState:UIControlStateNormal];
                }
            }
        }
    }
}


#pragma mark - Lazy Load

- (NSArray *)pageContentArray {
    
    if (!_pageContentArray) {
        
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        
        LDHomePageViewController *v1 = [[LDHomePageViewController alloc] init];
        LDHomePageViewController *v2 = [[LDHomePageViewController alloc] init];
        LDHomePageViewController *v3 = [[LDHomePageViewController alloc] init];
     
        [arrayM addObject:v1];
        [arrayM addObject:v2];
        [arrayM addObject:v3];

        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
        
    }
    return _pageContentArray;
}


#pragma mark 地图的代理方法
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:latitude];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:longitude];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"city"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"addr"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"province"];
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *location=[locations firstObject];//取出第一个位置
    
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    
    //    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark * placemark in placemarks) {
            
            if (coordinate.latitude != 0 && coordinate.longitude != 0) {
                
                if (!placemark.locality) {
                    //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                    
                    [[NSUserDefaults standardUserDefaults] setObject:placemark.administrativeArea forKey:@"city"];
                    [[NSUserDefaults standardUserDefaults] setObject:placemark.administrativeArea forKey:@"province"];
                    
                }else{
                    
                    [[NSUserDefaults standardUserDefaults] setObject:placemark.locality forKey:@"city"];
                    [[NSUserDefaults standardUserDefaults] setObject:placemark.administrativeArea forKey:@"province"];
                    
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:placemark.name forKey:@"addr"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",coordinate.latitude] forKey:latitude];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",coordinate.longitude] forKey:longitude];
                
            }else{
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:latitude];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:longitude];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"city"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"addr"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"province"];
            }
        }
    }];
    
}

/**
 * 收到消息后的tabbar的badge改变
 */
-(void)recieveMessage{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:2];
        
        NSInteger badge = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
        
        if (badge <= 0) {
            
            item.badgeValue = 0;
            
        }else{
            
            item.badgeValue = [NSString stringWithFormat:@"%ld",(long)badge];
        }
        
    });
}

/**
 * 有新人的监听方法
 */
-(void)newestBadge{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"newestBadge"] integerValue] > 0) {
        _newestDogLabel.hidden = NO;
        _newestDogLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"newestBadge"];
        [self.tabBarController.tabBar showBadgeOnItemIndex:1];
    }else{
        _newestDogLabel.hidden = YES;
        [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
    }
}

//隐藏置顶按钮
-(void)hideTopButton{
    
    _topButton.hidden = YES;
}

//显示置顶按钮
-(void)showTopButton{
    
    _topButton.hidden = NO;
}

/**
 * 有人查看我的监听方法
 */
-(void)lookFangBadge{
    
    [self.tabBarController.tabBar showBadgeOnItemIndex:4];
}

/**
 * 监听有没有新的动态
 */
-(void)dynamicBadge{
    
//    [self.tabBarController.tabBar showBadgeOnItemIndex:3];
}

/**
 * 手势解锁成功执行方法
 */
-(void)validateSuccess{
    
    //判断是否有最新版本
    [self judgeVerson];
    
}

/**
 * 删除附近新人上方红点及附近tabbar上的红点
 */
-(void)deleteRedDot{
    
    _newestDogLabel.hidden = YES;
    _newestDogLabel.text = @"";
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"newestBadge"];
    [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
}


/**
 * 融云个人信息提供者
 */
-(void)getUserInfomation{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getmineinfoUrl];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
        }else{
            //设置当前用户信息
            [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"] name:responseObj[@"data"][@"nickname"] portrait:responseObj[@"data"][@"head_pic"]];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}


/**
 * 判断是否是最新版本
 */
-(void)judgeVerson{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/judgeVersionNew"];
    
    NSString *uid;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == 0) {
        
        uid = @"";
        
    }else{
        
        uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    }
    
    //用keychain存储用户的唯一标示uuid,用于封设备
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.aiwujie.shengmoApp"];
    
    NSString *device;
    
    if ([keychain[@"device_token"] length] == 0) {
        
        device = @"";
        
    }else{
        
        device = keychain[@"device_token"];
    }
    
    NSString *versionStr =  [NSString stringWithFormat:@"V%@", [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSDictionary *parameters = @{@"version":versionStr,@"device_tag":@"ios",@"uid":uid,@"device_token":device};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        
        if ([responseObj[@"retcode"] integerValue] == 3001) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseObj[@"msg"]    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                //判断是否开启定位
               // [self judgeLocation];
                
            }];
            
            UIAlertAction * setAction = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                [self presentViewController:alert animated:YES completion:nil];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:responseObj[@"data"][@"url"]]];
                
                
            }];
            
            if ([responseObj[@"data"][@"necessity"] intValue] == 0) {
                
                [alert addAction:action];
            }
            
            [alert addAction:setAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            //判断是否开启定位
           // [self judgeLocation];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

/**
 * 判断是否开启定位
 */
-(void)judgeLocation{
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:latitude];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:longitude];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"city"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"addr"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"province"];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位权限未开启，将无法查看附近的人，请前往手机设置-隐私-位置-开启定位服务"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
        
        UIAlertAction * setAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
            
        }];
        
        [alert addAction:action];
        
        [alert addAction:setAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

/**
 * 判断是否签到
 */
-(void)judgeSignState{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getSignTimesInWeeksUrl];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer == 2002) {
            LDSignView *signView = [[LDSignView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
            [signView getSignDays:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"signtimes"]] andsignState:@"未签到"];
            [self.tabBarController.view addSubview:signView];
        }
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

/**
 * 启动页后的展示图片
 */
-(void)createTimeReducePic{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/getSlideStartup"];
    
    NSString *state = [NSString string];
    
    if (HEIGHT == 568) {
        
        state = @"6";
        
    }else if (HEIGHT == 667){
        
        state = @"7";
        
    }else if (HEIGHT == 736){
        
        state = @"8";
        
    }else if (HEIGHT == 812){
        
        state = @"9";
    }
    
    NSDictionary *parameters = @{@"state":state};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        if ([responseObj[@"retcode"] integerValue] == 2000) {
            
            _url = responseObj[@"data"][@"url"];
            
            _titleString = responseObj[@"data"][@"title"];
            
            _time = 3;
            
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
            [_imageView sd_setImageWithURL:[NSURL URLWithString:responseObj[@"data"][@"path"]]];
            _imageView.userInteractionEnabled = YES;
            [[[UIApplication sharedApplication].delegate window] addSubview:_imageView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicClick)];
            [_imageView addGestureRecognizer:tap];
            
            _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 80, 20, 70, 30)];
            _closeButton.backgroundColor = [UIColor grayColor];
            _closeButton.layer.cornerRadius = 2;
            _closeButton.clipsToBounds = YES;
            [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [_closeButton setTitle:[NSString stringWithFormat:@"关闭(%ld)",(long)_time] forState:UIControlStateNormal];
            [_imageView addSubview:_closeButton];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeReduce) userInfo:nil repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

/**
 * 点击图片跳转到相应的链接
 */
-(void)tapPicClick{
    
    [self closeButtonClick];
    
    LDModalH5ViewController *bvc = [[LDModalH5ViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:bvc];
    
    nav.navigationBarHidden = NO;
    
    bvc.url = _url;
    
    bvc.title = _titleString;
    
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 * 清除定时器
 */

-(void)closeButtonClick{
    
    [_imageView removeFromSuperview];
    
    [_timer invalidate];
    
    _timer = nil;
}

/**
 * 时间大于0,显示并文字改变,等于0则移除
 */
-(void)timeReduce{
    
    if (_time > 0) {
        
        _time--;
        
        [_closeButton setTitle:[NSString stringWithFormat:@"关闭(%ld)",_time] forState:UIControlStateNormal];
        
    }else{
        
        [self closeButtonClick];
    }
}

//置顶按钮
-(void)createtopButton{
    
    CGFloat publishH = 44;
    
    CGFloat publishBottomY = 130;
    
    if (ISIPHONEX) {
        
         _topButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 45, HEIGHT - publishBottomY - publishH - 24 - 34, publishH, publishH)];
        
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

//置顶按钮点击
-(void)topButtonClick{
    
    NSDictionary *dic = @{@"index":[NSString stringWithFormat:@"%ld",(long)_index]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"置顶附近" object:nil userInfo:dic];
}
/**
 * 生成翻页控制器
 */
-(void)createPageViewController{

    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(1)};
    //    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options:options];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    LDHomePageViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    _index = 0;
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = self.view.frame;
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDHomePageViewController *)viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];

}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDHomePageViewController *)viewController];
    
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

    _homePageViewController = (LDHomePageViewController *)pendingViewControllers[0];
    
}
//翻页动画执行完成后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{

    if (finished) {
        
        if (completed) {
            
            NSInteger index = [self.pageContentArray indexOfObject:_homePageViewController];
            
            _index = index;
            
            [self changeNavButtonColor:index];
            
        }else{
        
            NSInteger index = [self.pageContentArray indexOfObject:previousViewControllers[0]];
            
            _index = index;
            
            [self changeNavButtonColor:index];
        }
        
    }
}

#pragma mark - 根据index得到对应的UIViewController

- (LDHomePageViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        
        return nil;
    }
    
    LDHomePageViewController *contentVC = self.pageContentArray[index];
    
    if(index == 1){
    
        contentVC.content = @"1";
        
    }else if (index == 2){
    
        contentVC.content = @"7";
        
    }else if(index == 3){
    
        contentVC.content = @"3";
        
    }else{
    
        contentVC.content = @"0";
        
    }
    
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(LDHomePageViewController *)viewController {
    
    if ([viewController.content intValue] == 0) {
        
        return 0;
        
    }else if ([viewController.content intValue] == 1){
        
        return 1;
    
    }else if ([viewController.content intValue] == 3){
        
        return 3;
    
    }
    
    return 2;
    
}

//创建导航栏顶部视图
-(void)createNavButtn{
    
    if (ISIPHONEX) {
        
        _navView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, WIDTH - 120, 88)];
        
    }else{
        
        _navView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, WIDTH - 120, 64)];
    }

    _navView.backgroundColor = [UIColor clearColor];
    
    [self.navigationController.view addSubview:_navView];
    
    //左侧查看看过我和我看过的人按钮
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] length] == 0) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"layout"];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] intValue] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] length] == 0){
        
        [leftButton setImage:[UIImage imageNamed:@"列表模式"] forState:UIControlStateNormal];
        
    }else{
        
        [leftButton setImage:[UIImage imageNamed:@"宫格模式"] forState:UIControlStateNormal];
    }
    
    [leftButton addTarget:self action:@selector(leftButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

    //右侧下拉列表
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"] integerValue] == 0) {

        [_rightButton setImage:[UIImage imageNamed:@"条件筛选"] forState:UIControlStateNormal];

    }else{

        [_rightButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
    }

    _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightButton addTarget:self action:@selector(rightButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    CGFloat spotH = 2;
    CGFloat spotW = 38;
    int buttonNum = 3;
    CGFloat buttonWidth = _navView.frame.size.width/buttonNum;
    
    //推荐按钮及紫点
    UIButton *recommendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, [self getIsIphoneXNAV:ISIPHONEX], buttonWidth, 30)];
    [recommendButton setTitle:@"推荐" forState:UIControlStateNormal];
    [recommendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    recommendButton.tag = 100;
    [recommendButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    recommendButton.titleLabel.font = [UIFont systemFontOfSize:21];
    recommendButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    [_navView addSubview:recommendButton];
    
    UIView *recommendView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/(2 * buttonNum) - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    recommendView.backgroundColor = [UIColor blackColor];
    recommendView.tag = 200;
    recommendView.layer.cornerRadius = spotH/2;
    recommendView.hidden = NO;
    recommendView.clipsToBounds = YES;
    [_navView addSubview:recommendView];
    
    //附近按钮及紫点
    UIButton *nearButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth, [self getIsIphoneXNAV:ISIPHONEX],buttonWidth, 30)];
    [nearButton setTitle:@"附近" forState:UIControlStateNormal];
    nearButton.titleLabel.font = [UIFont systemFontOfSize:17];
    nearButton.tag = 101;
    [nearButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [nearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_navView addSubview:nearButton];
    
    UIView *nearView = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth + _navView.frame.size.width/(2 * buttonNum) - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    nearView.backgroundColor = [UIColor blackColor];
    nearView.tag = 201;
    nearView.layer.cornerRadius = spotH/2;
    nearView.hidden = YES;
    nearView.clipsToBounds = YES;
    [_navView addSubview:nearView];
    
    //在线按钮及紫点
    UIButton *onlineButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth * 2, [self getIsIphoneXNAV:ISIPHONEX], buttonWidth, 30)];
    [onlineButton setTitle:@"在线" forState:UIControlStateNormal];
    onlineButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [onlineButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    onlineButton.tag = 102;
    [onlineButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_navView addSubview:onlineButton];
    
    UIView *onlineView = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth * 2 + _navView.frame.size.width/(2 * buttonNum) - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    onlineView.backgroundColor = [UIColor blackColor];
    onlineView.tag = 202;
    onlineView.layer.cornerRadius = spotH/2;
    onlineView.hidden = YES;
    onlineView.clipsToBounds = YES;
    [_navView addSubview:onlineView];

}

//点击导航栏处的按钮
-(void)navButtonClick:(UIButton *)button{
    
    LDHomePageViewController *initialViewController = [self viewControllerAtIndex:button.tag - 100];// 得到对应页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    if (button.tag == 100) {
        
        if (initialViewController.selectButtonState.length != 0) {
            
            initialViewController.selectButtonState = @"";
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"附近榜单" object:nil];
        }

    }
    
    [self changeNavButtonColor:button.tag - 100];
}

//改变导航栏上按钮的颜色
-(void)changeNavButtonColor:(NSInteger)index{
    
    _rightButton.hidden = NO;
    
    UIButton *button = (UIButton *)[self.navView viewWithTag:index + 100];
    
    UIButton *btn0 = (UIButton *)[self.navView viewWithTag:100];
    
    UIButton *btn1 = (UIButton *)[self.navView viewWithTag:101];
    
    UIButton *btn2 = (UIButton *)[self.navView viewWithTag:102];
    
    if (index==0) {
        btn0.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
        btn1.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
        btn2.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    }
    if (index==1) {
        btn0.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
        btn1.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
        btn2.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    }
    if (index==2) {
        btn0.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
        btn1.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
        btn2.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    }
    
    _index = index;
    
    for (int i = 100; i < 100 + _pageContentArray.count; i++) {
        
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

//切换宫格和列表模式
-(void)leftButtonOnClick:(UIButton *)leftButton{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"切换模式" object:nil];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] intValue] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] length] == 0){
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"layout"];
        
        [leftButton setImage:[UIImage imageNamed:@"宫格模式"] forState:UIControlStateNormal];
        
        
    }else{
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"layout"];
        
        [leftButton setImage:[UIImage imageNamed:@"列表模式"] forState:UIControlStateNormal];

    }
}

//点击查看筛选等列表
-(void)rightButtonOnClick:(UIButton *)rightButton{
    
    //获得列表处条件筛选的开启状态
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"] integerValue] == 0) {
        
        _openLabel.text = @"未开启";
        _openLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        
    }else{
        
        _openLabel.text = @"已开启";
        _openLabel.textColor = MainColor;
    }

    if (_isSelect == NO) {
        
        _backgroundView.alpha = 1;
        
        _isSelect = YES;
        
    }else{
    
        _backgroundView.alpha = 0;
        
        _isSelect = NO;
    }
}

//创建右侧按钮下拉列表
-(void)createSearchView{
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    
    _isSelect = NO;
    
    _backgroundView.alpha = 0;
    
    _backgroundView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_backgroundView];

    UIView *backgroundShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 3 * 44 - 1, WIDTH, HEIGHT - 3 * 44 + 1)];
    
    backgroundShadowView.backgroundColor = [UIColor blackColor];
    
    backgroundShadowView.alpha = 0.3;
    
    [_backgroundView addSubview:backgroundShadowView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    
    [_backgroundView addGestureRecognizer:tap];
    
    NSArray *imageArray = @[@[@""],@[@"查看全部",@"只看男",@"只看女",@"只看CDTS"],@"查看全部",@"条件筛选"];
        
    NSArray *titleArray = @[@[@"筛选仅对“推荐/附近/在线”生效"],@[@"所有人",@"男",@"女",@"CDTS"],@"根据我的性取向展示感兴趣的人",@"自定义高级筛选"];
        
    for (int i = 0; i < 4; i++) {
        
        //没条的view
        UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, i * 44, WIDTH, 44)];
        
        searchView.backgroundColor = [UIColor whiteColor];
        
        [_backgroundView addSubview:searchView];
        
        if (i > 1) {
            
            //图片
            UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 17, 17)];
            
            searchImage.image = [UIImage imageNamed:imageArray[i]];
            
            [searchView addSubview:searchImage];
            
            //标题
            UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 9, 250, 24)];
            
            if (i == 2) {
                
                _searchLabel = searchLabel;
            }
            
            searchLabel.text = titleArray[i];
            
            searchLabel.font = [UIFont systemFontOfSize:15];
            
            searchLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
 
            [searchView addSubview:searchLabel];
            
            //点击事件
            UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 43)];
            
            [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            searchButton.tag = 9 + i;
            
            [searchView addSubview:searchButton];
            
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

        }else if (i == 0){
        
            UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, WIDTH - 26, 44)];
            
            showLabel.text = titleArray[i][0];
            
            showLabel.textAlignment = NSTextAlignmentCenter;
            
            showLabel.textColor = [UIColor lightGrayColor];
            
            showLabel.font = [UIFont systemFontOfSize:15];
            
            [searchView addSubview:showLabel];
        }
        
        //中间线
        UIView *searchLine = [[UIView alloc] initWithFrame:CGRectMake(12, 43, WIDTH, 1)];
        
        searchLine.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
        
        [searchView addSubview:searchLine];
        
        if (i == 2 || i == 3) {
            
            //箭头
            UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - 20, 15, 7, 13)];
            
            rightArrow.image = [UIImage imageNamed:@"youjiantou"];
            
            [searchView addSubview:rightArrow];
        }
        
        if (i == 3) {
            
            //是否开启
            _openLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 81, 14, 55, 15)];
            
            _openLabel.textAlignment = NSTextAlignmentRight;
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"] integerValue] == 0) {
                
                _openLabel.text = @"未开启";
                
                _openLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
                
            }else{
            
                _openLabel.text = @"已开启";
                _openLabel.textColor = MainColor;
            }
            _openLabel.font = [UIFont systemFontOfSize:15];
            [searchView addSubview:_openLabel];
        }
    }
}

-(void)tapClick{

    if (_isSelect) {
        
        _backgroundView.alpha = 0;
        
        _isSelect = NO;
        
    }
}

//选择对应的人
-(void)singleButtonClick:(UIButton *)button{

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == 11 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == 14514 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == 14518) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1) {
        
            //改变按钮字体颜色
            [self changeScreenColor:button];
            
            if (button.tag == 20) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sexButton"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sexualButton"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"roleButton"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"searchSwitch"];
                
                _isSelect = NO;
                
                self.backgroundView.alpha = 0;
                
                [self.rightButton setImage:[UIImage imageNamed:@"条件筛选"] forState:UIControlStateNormal];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"screen" object:nil];
                
            }else if (button.tag == 21){
                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchSwitch"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sexButton"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sexualButton"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"roleButton"];
                
                [self.rightButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
                
                _isSelect = NO;
                
                self.backgroundView.alpha = 0;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"screen" object:nil];
                
            }else if (button.tag == 22){
                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchSwitch"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"sexButton"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sexualButton"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"roleButton"];
                
                [self.rightButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
                
                _isSelect = NO;
                
                self.backgroundView.alpha = 0;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"screen" object:nil];
                
            }else if (button.tag == 23){
                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchSwitch"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"sexButton"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sexualButton"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"roleButton"];
                
                [self.rightButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
                
                _isSelect = NO;
                
                self.backgroundView.alpha = 0;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"screen" object:nil];
            }
            
        }else{
        
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"附近筛选功能VIP会员可用哦~"    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"开通会员" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                
                LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                
                [self.navigationController pushViewController:mvc animated:YES];
                
                
            }];
            
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
            
            [alert addAction:cancelAction];
            
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    
    }else{
    
        //改变按钮字体颜色
        [self changeScreenColor:button];
        
        if (button.tag == 20) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sexButton"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sexualButton"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"roleButton"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"searchSwitch"];
            
            _isSelect = NO;
            
            self.backgroundView.alpha = 0;
            
            [self.rightButton setImage:[UIImage imageNamed:@"条件筛选"] forState:UIControlStateNormal];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"screen" object:nil];
            
        }else if (button.tag == 21){
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchSwitch"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sexButton"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sexualButton"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"roleButton"];
            
            [self.rightButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
            
            _isSelect = NO;
            
            self.backgroundView.alpha = 0;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"screen" object:nil];
            
        }else if (button.tag == 22){
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchSwitch"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"sexButton"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sexualButton"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"roleButton"];
            
            [self.rightButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
            
            _isSelect = NO;
            
            self.backgroundView.alpha = 0;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"screen" object:nil];
            
        }else if (button.tag == 23){
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchSwitch"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"sexButton"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sexualButton"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"roleButton"];
            
            [self.rightButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
            
            _isSelect = NO;
            
            self.backgroundView.alpha = 0;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"screen" object:nil];
        }
    }
    
}

//根据性取向选择对应的人
-(void)searchButtonClick:(UIButton *)button{
    
    if(button.tag == 11){
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == 11 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == 14514 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == 14518) {
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1) {
                
                //改变按钮字体颜色
                [self changeScreenColor:button];
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSex"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSexual"] length] == 0) {
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请退出软件重新登录后使用此功能~"];
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchSwitch"];
                    [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSexual"] forKey:@"sexButton"];
                    [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSex"] forKey:@"sexualButton"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"roleButton"];
                    [self.rightButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
                    _isSelect = NO;
                    self.backgroundView.alpha = 0;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"screen" object:nil];
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
            
        }else{
        
            //改变按钮字体颜色
            [self changeScreenColor:button];
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSex"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSexual"] length] == 0) {
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请退出软件重新登陆后使用此功能~"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchSwitch"];
                [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSexual"] forKey:@"sexButton"];
                [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSex"] forKey:@"sexualButton"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"roleButton"];
                [self.rightButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
                _isSelect = NO;
                self.backgroundView.alpha = 0;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"screen" object:nil];
            }
        }
    }else if (button.tag == 12){
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == 11 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == 14514 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == 14518) {
        
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1) {
                LDScreenViewController *svc = [[LDScreenViewController alloc] init];
                self.backgroundView.alpha = 0;
                _isSelect = NO;
                [self.navigationController pushViewController:svc animated:YES];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"附近筛选功能VIP会员可用哦~"    preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"开通会员" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                    LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                    [self.navigationController pushViewController:mvc animated:YES];
                }];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
                [alert addAction:cancelAction];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }else{
            LDScreenViewController *svc = [[LDScreenViewController alloc] init];
            self.backgroundView.alpha = 0;
            _isSelect = NO;
            [self.navigationController pushViewController:svc animated:YES];
        }
    }
}

-(void)changeScreenColor:(UIButton *)button{

    if (button.tag == 11) {
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

//隐藏导航栏上的view
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self vhl_setNavBarShadowImageHidden:NO];
    _navView.hidden = YES;
}

-(void)suspenshowView
{
    int index =  (int)[self.tabBarController selectedIndex];
    if (index==1) {
        ChatroomVC *vc = [ChatroomVC new];
        vc.roomidStr = roomidStr.copy;
        vc.popBlock = ^(NSString * _Nonnull popString) {
            
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//移除监听
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
