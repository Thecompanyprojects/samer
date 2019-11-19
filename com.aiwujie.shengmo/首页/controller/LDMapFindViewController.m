//
//  LDMapFindViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/25.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDMapFindViewController.h"
#import "CollectCell.h"
#import "CollectModel.h"
#import "LDBulletinViewController.h"
#import "LDOwnInformationViewController.h"
#import "TableCell.h"
#import "LDMemberViewController.h"
#import "LDScreenViewController.h"

@interface LDMapFindViewController ()<UITableViewDataSource,UITableViewDelegate>
//右上方按钮变化
@property (nonatomic,strong) UIButton *rightButton;
//搜索背景
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) UILabel *openLabel;
@property (nonatomic,assign) BOOL isSelect;

@property (nonatomic,strong) UILabel *searchLabel;

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) int page;
@property (nonatomic,assign) NSInteger integer;
@property (nonatomic,copy) NSString *pathString;
@property (nonatomic,copy) NSString *urlString;
@property (nonatomic,copy) NSString *titleString;


@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationViewBottomY;

@property (nonatomic,strong) UIImageView *img;

@end

@implementation LDMapFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"地图找人";
    if (ISIPHONEX) {
        self.locationViewBottomY.constant = IPHONEXBOTTOMH;
    }
    self.locationLabel.text = self.location;
    [self createRightBtn];
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.table];
    //创建搜索界面
    [self createSearchView];
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [self createData:@"1"];
    }];
    [self.table.mj_header beginRefreshing];
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self createData:@"2"];
    }];
    
    //监听确定搜索
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureScreen) name:@"screen" object:nil];
}

#pragma mark - 获取数据

//地图找人
-(void)createData:(NSString *)str{
    
    if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        [self.table.mj_header endRefreshing];
        [self.table.mj_footer endRefreshing];

        //定位不能用
        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"请您在手机设置-Samer-权限中开启位置权限，以便正常使用全部功能（如您想隐藏位置，可在APP我的-设置-隐私中关闭位置）" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
            
        }];
        [control addAction:action0];
        [control addAction:action1];
        [self presentViewController:control animated:YES completion:^{
            
        }];
        
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,userListNewthUrl];
    
    NSString *age;
    NSString *sex;
    NSString *sexual;
    NSString *role = [NSString string];
    NSString *education = [NSString string];
    NSString *month = [NSString string];
    NSString *online;
    NSString *real = [NSString string];
    NSString *want = [NSString string];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"] integerValue] == 0) {
        
        age = @"";
        sex = @"";
        sexual = @"";
        role = @"";
        education = @"";
        month = @"";
        online = @"";
        real = @"";
        want = @"";
        
    }else
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sexButton"] length] == 0) {
            sex = @"0";
        }else{
            sex = [[NSUserDefaults standardUserDefaults] objectForKey:@"sexButton"];
        }
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sexualButton"] length] == 0) {
            sexual = @"0";
        }else{
            sexual = [[NSUserDefaults standardUserDefaults] objectForKey:@"sexualButton"];
        }
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"roleButton"] length] == 0) {
            role = @"0";
        }else{
            NSArray *roleArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"roleButton"] componentsSeparatedByString:@","];
            NSMutableArray *roleOtherArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < roleArray.count; i++) {
                if ([roleArray[i] integerValue] == 0) {
                    [roleOtherArray addObject:@"0"];
                }else if ([roleArray[i] integerValue] == 1){
                    [roleOtherArray addObject:@"S"];
                }else if ([roleArray[i] integerValue] == 2){
                    [roleOtherArray addObject:@"M"];
                }else if ([roleArray[i] integerValue] == 3){
                    [roleOtherArray addObject:@"SM"];
                }else if ([roleArray[i] integerValue] == 4){
                    [roleOtherArray addObject:@"~"];
                }
            }
            if (roleOtherArray.count == 1) {
                role = roleOtherArray[0];
            }else if (roleOtherArray.count == 2){
                role = [NSString stringWithFormat:@"%@,%@",roleOtherArray[0],roleOtherArray[1]];
            }else if (roleOtherArray.count == 3){
                role = [NSString stringWithFormat:@"%@,%@,%@",roleOtherArray[0],roleOtherArray[1],roleOtherArray[2]];
            }else if (roleOtherArray.count == 4){
                role = [NSString stringWithFormat:@"%@,%@,%@,%@",roleOtherArray[0],roleOtherArray[1],roleOtherArray[2],roleOtherArray[3]];
            }
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hight"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hight"] integerValue] == 0) {
            education = @"";
            month = @"";
            real = @"";
            online = @"";
            age = @"";
            want = @"";
        }else{
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screenEducation"] length] == 0) {
                education = @"";
            }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screenEducation"] length] != 0){
                education = [[NSUserDefaults standardUserDefaults] objectForKey:@"educationRow"];
            }
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screenMonth"] length] == 0) {
                month = @"";
            }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screenMonth"] length] != 0){
                month = [[NSUserDefaults standardUserDefaults] objectForKey:@"monthRow"];
            }
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authen"] length] == 0) {
                real = @"";
            }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authen"] length] != 0){
                real = [[NSUserDefaults standardUserDefaults] objectForKey:@"authen"];
            }
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"online"] length]== 0) {
                online = @"";
            }else{
                online = [[NSUserDefaults standardUserDefaults] objectForKey:@"online"];
            }
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screenAge"] length] != 0) {
                age = [NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"minAge"],[[NSUserDefaults standardUserDefaults] objectForKey:@"maxAge"]];
            }else{
                age = @"";
            }
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screenWant"] length] == 0) {
                want = @"";
            }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screenWant"] length] != 0){
                want = [[NSUserDefaults standardUserDefaults] objectForKey:@"wantRow"];
            }
        }
    }

    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"lat":[NSString stringWithFormat:@"%lf",self.lat],@"lng":[NSString stringWithFormat:@"%lf",self.lng],@"layout":@"1",@"age":age,@"sex":sex,@"sexual":sexual,@"role":role,@"education":education,@"month":month,@"online":online,@"real":real,@"type":@"1",@"want":want?:@""};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        _integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (_integer != 2000 && _integer != 2001) {
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
        }else{
            if ([str intValue] == 1) {
                [self.dataSource removeAllObjects];
            }
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[TableModel class] json:responseObj[@"data"]]];
            [self.dataSource addObjectsFromArray:data];
            [self.table reloadData];
        }
        
        [self.table.mj_header endRefreshing];
        [self.table.mj_footer endRefreshing];
        
    } failed:^(NSString *errorMsg) {
        [self.table.mj_header endRefreshing];
        [self.table.mj_footer endRefreshing];
        
    }];
}

-(void)createRightBtn{
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

#pragma mark - 筛选按钮

//点击查看筛选等列表
-(void)rightButtonOnClick:(UIButton *)rightButton{
    
    //获得列表处条件筛选的开启状态
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"] integerValue] == 0) {
        self.openLabel.text = @"未开启";
        self.openLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    }else{
        self.openLabel.text = @"已开启";
        self.openLabel.textColor = MainColor;
    }
    if (self.isSelect == NO) {
        self.backgroundView.alpha = 1;
        self.isSelect = YES;
    }else{
        self.backgroundView.alpha = 0;
        self.isSelect = NO;
    }
}

//创建右侧按钮下拉列表
-(void)createSearchView{
    
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.isSelect = NO;
    self.backgroundView.alpha = 0;
    self.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.backgroundView];
    
    UIView *backgroundShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 3 * 44 - 1, WIDTH, HEIGHT - 3 * 44 + 1)];
    
    backgroundShadowView.backgroundColor = [UIColor blackColor];
    backgroundShadowView.alpha = 0.3;
    [self.backgroundView addSubview:backgroundShadowView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.backgroundView addGestureRecognizer:tap];
    
    NSArray *imageArray = @[@[@""],@[@"查看全部",@"只看男",@"只看女",@"只看CDTS"],@"查看全部",@"条件筛选"];
    NSArray *titleArray = @[@[@"筛选仅对“推荐/附近/在线”生效"],@[@"所有人",@"男",@"女",@"CDTS"],@"根据我的性取向展示感兴趣的人",@"自定义高级筛选"];
    
    for (int i = 0; i < 4; i++) {
        
        //没条的view
        UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, i * 44, WIDTH, 44)];
        searchView.backgroundColor = [UIColor whiteColor];
        [self.backgroundView addSubview:searchView];
        
        if (i > 1) {
            
            //图片
            UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 17, 17)];
            
            searchImage.image = [UIImage imageNamed:imageArray[i]];
            
            [searchView addSubview:searchImage];
            
            //标题
            UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 9, 250, 24)];
            
            if (i == 2) {
                
                self.searchLabel = searchLabel;
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
            self.openLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 81, 14, 55, 15)];
            self.openLabel.textAlignment = NSTextAlignmentRight;
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"] integerValue] == 0) {
                
                self.openLabel.text = @"未开启";
                self.openLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
                
            }else{
                
                self.openLabel.text = @"已开启";
                self.openLabel.textColor = MainColor;
            }
            self.openLabel.font = [UIFont systemFontOfSize:15];
            [searchView addSubview:self.openLabel];
        }
    }
}

-(void)tapClick{
    if (self.isSelect) {
        self.backgroundView.alpha = 0;
        self.isSelect = NO;
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
                
                self.isSelect = NO;
                
                self.backgroundView.alpha = 0;
                
                [self.rightButton setImage:[UIImage imageNamed:@"条件筛选"] forState:UIControlStateNormal];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"screen" object:nil];

            }else if (button.tag == 21){
                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchSwitch"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sexButton"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sexualButton"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"roleButton"];
                
                [self.rightButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
                
                self.isSelect = NO;
                
                self.backgroundView.alpha = 0;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"screen" object:nil];
                
    
            }else if (button.tag == 22){
                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchSwitch"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"sexButton"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sexualButton"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"roleButton"];
                
                [self.rightButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
                
                self.isSelect = NO;
                
                self.backgroundView.alpha = 0;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"screen" object:nil];

            }else if (button.tag == 23){
                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchSwitch"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"sexButton"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sexualButton"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"roleButton"];
                
                [self.rightButton setImage:[UIImage imageNamed:@"条件筛选绿"] forState:UIControlStateNormal];
                
                self.isSelect = NO;
                
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

#pragma mark - 数据列表

-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc]  initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 44)];
        _table.dataSource = self;
        _table.delegate = self;
        _table.tableFooterView = [UIView new];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _table;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Table"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil].lastObject;
    }
    if (indexPath.row==self.dataSource.count-1) {
        [cell.lineView setHidden:YES];
    }
    else
    {
        [cell.lineView setHidden:NO];
    }
    cell.typeStr = @"10";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSource.count > 0) {
        TableModel *model = self.dataSource[indexPath.row];
        cell.integer = _integer;
        //cell.content = [self.content intValue] > 2 ? self.content : nil;
        cell.model = model;
    }
    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
        
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectModel *model = self.dataSource[indexPath.row];
    if ([model.location_switch intValue]==1||[model.location_city_switch intValue]==1) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue]==1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue]==1) {
            LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
            ivc.userID = model.uid;
            [self.navigationController pushViewController:ivc animated:YES];
        }
        else
        {
            UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"Ta的个人主页限VIP可见" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                [self.navigationController pushViewController:mvc animated:YES];
            }];
            [control addAction:action0];
            [control addAction:action1];
            [self presentViewController:control animated:YES completion:^{
                
            }];
        }
    }
    else
    {
        LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
        ivc.userID = model.uid;
        [self.navigationController pushViewController:ivc animated:YES];
    }

}

/**
 * 点击了确定搜索后的监听方法
 */
-(void)sureScreen{
//    [self createData:@"1"];
    [self.table.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
