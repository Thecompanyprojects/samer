//
//  LDMatchmasterDetailViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/8/16.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDMatchmasterDetailViewController.h"
#import "LDApplyMatchmakerViewController.h"
#import "MatchmakerDetailModel.h"
#import "MatchmakerDetailCell.h"

@interface LDMatchmasterDetailViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableDictionary *dataDic;

@property (nonatomic,assign) CGFloat cellH;

//底部的切换按钮
@property (nonatomic, strong) UIButton *bottomApplyButton;

//保存最初的偏移量
@property (nonatomic,assign) CGFloat lastScrollOffset;

@end

@implementation LDMatchmasterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
        
        [self createButton];
    }

    _dataArray = [NSMutableArray arrayWithArray:@[@"基本资料",@"斯慕资料",@"内心独白",@"红娘荐语"]];
    
    _dataDic = [NSMutableDictionary dictionary];
    
    [self createPersonInformationData];
    
    self.lastScrollOffset = 0;
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
    
    [_bottomApplyButton setBackgroundImage:[UIImage imageNamed:@"红娘联系他"] forState:UIControlStateNormal];
    
    [_bottomApplyButton addTarget:self action:@selector(bottomApplyButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_bottomApplyButton];
    
}

-(void)bottomApplyButtonOnClick{
    
    LDApplyMatchmakerViewController *mvc = [[LDApplyMatchmakerViewController alloc] init];
    
    mvc.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"match_state"] intValue] == 0) {
        
        mvc.title = @"申请服务";
        
    }else{
        
        mvc.title = @"个人中心";
    }
    [self.navigationController pushViewController:mvc animated:YES];
}
#pragma mark- scrollView代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 获取开始拖拽时tableview偏移量
    self.lastScrollOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView) {
        
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y + HEIGHT < scrollView.contentSize.height) {
            
            CGFloat y = scrollView.contentOffset.y;
            
            if (y >= self.lastScrollOffset) {
                //用户往上拖动，也就是屏幕内容向下滚动
                
                _bottomApplyButton.hidden = YES;
                
            } else if(y < self.lastScrollOffset){
                //用户往下拖动，也就是屏幕内容向上滚动
                
                _bottomApplyButton.hidden = NO;
            }
        }
    }
}

/**
 * 创建黑V可进入编辑红年荐语
 */
-(void)createButton{
    
    UIButton *applyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyButton setTitle:@"个人中心" forState:UIControlStateNormal];
    [applyButton setBackgroundColor:MainColor];
    applyButton.alpha = 0.7;
    applyButton.titleLabel.font = [UIFont systemFontOfSize:12];
    applyButton.layer.cornerRadius = 2;
    applyButton.clipsToBounds = YES;
    [applyButton addTarget:self action:@selector(applyButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:applyButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

-(void)applyButtonOnClick:(UIButton *)button{
    
    LDApplyMatchmakerViewController *mvc = [[LDApplyMatchmakerViewController alloc] init];
    
    mvc.userId = self.userId;
    
    mvc.title = @"个人中心";
    
    [self.navigationController pushViewController:mvc animated:YES];
}

/**
 * 获取个人信息
 */
-(void)createPersonInformationData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Matchmaker/getMatchUserInfo"];
    
    NSDictionary *parameters = @{@"uid":self.userId};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            if (integer == 4001) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                
            }else{
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"获取资料失败~"];
                
            }
            
        }else{
            
            [_dataDic setValuesForKeysWithDictionary:responseObj[@"data"]];
            
            [self createHeaderView:responseObj[@"data"]];
            
            [self createTableView];
            
            //创建红娘底部按钮
            [self createBottomApplyButton];
        }
    } failed:^(NSString *errorMsg) {
        
    }];


}

-(void)createTableView{

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStyleGrouped];
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
  
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableHeaderView = _headerView;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _dataArray.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        
        MatchmakerDetailCell *cell = [[NSBundle mainBundle] loadNibNamed:@"MatchmakerDetailCell" owner:self options:nil][0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell matchmasterDic:_dataDic andIndexPath:indexPath];
        
        return cell;
        
    }else{
    
        MatchmakerDetailCell *cell = [[NSBundle mainBundle] loadNibNamed:@"MatchmakerDetailCell" owner:self options:nil][1];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell matchmasterDic:_dataDic andIndexPath:indexPath];
        
        _cellH = cell.introduceH.constant + 30;
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0 || indexPath.section == 1) {
        
        return 70 + 24 * 3;
    }

    return _cellH;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, WIDTH - 15, 40)];
    
    label.text = _dataArray[section];
    
    label.font = [UIFont systemFontOfSize:14];
    
    [view addSubview:label];
    
    return view;
}

-(void)createHeaderView:(NSDictionary *)dic{
    
    NSArray *imagesURLStrings = dic[@"match_photo"];

    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH + 65)];
    [self.view addSubview:_headerView];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, WIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    
    if ([dic[@"match_photo_lock"] intValue] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
        
        cycleScrollView.isBlur = NO;
        
    }else if([dic[@"match_photo_lock"] intValue] == 1){

        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"match_state"] intValue] == 0) {
            
            cycleScrollView.isBlur = YES;
            
        }else{
            
            cycleScrollView.isBlur = NO;
        }
        
    }else if([dic[@"match_photo_lock"] intValue] == 2){
        
        cycleScrollView.isBlur = YES;
    }
    
    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    cycleScrollView.autoScrollTimeInterval = 3.0;
    [_headerView addSubview:cycleScrollView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, WIDTH, WIDTH, 65)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:bottomView];
    
    //创建显示姓名的label
    UILabel *nameLabel = [[UILabel alloc] init];

    nameLabel.text = dic[@"match_num"];
    nameLabel.font = [UIFont systemFontOfSize:15];
    [nameLabel sizeToFit];
    CGSize nameSize = nameLabel.frame.size;
    nameLabel.frame = CGRectMake(27, 10, nameSize.width, 20);
    [bottomView addSubview:nameLabel];
    
    //创建认证的imageView
    UIImageView *cerimageView = [[UIImageView alloc] initWithFrame:CGRectMake(5 + nameLabel.frame.origin.x + nameSize.width, (nameLabel.frame.size.height - 12)/2 + nameLabel.frame.origin.y, 17, 12)];
    cerimageView.image = [UIImage imageNamed:@"认证"];
    
    if ([dic[@"realname"] intValue] == 1) {
        
        cerimageView.hidden = NO;
        
    }else{
    
        cerimageView.hidden = YES;
    }
    
    [bottomView addSubview:cerimageView];
    
    //创建显示年龄性别的view
    UIView *ageView = [[UIView alloc] initWithFrame:CGRectMake(27, nameLabel.frame.origin.y + nameLabel.frame.size.height + 10, 35, 15)];
    ageView.layer.cornerRadius = 2;
    ageView.clipsToBounds = YES;
    [bottomView addSubview:ageView];
    
    UIImageView *sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 8, 8)];
    [ageView addSubview:sexImageView];
    
    if ([dic[@"sex"] intValue] == 1) {
        
        sexImageView.image = [UIImage imageNamed:@"男"];
        
        ageView.backgroundColor = BOYCOLOR;
        
    }else if ([dic[@"sex"] intValue] == 2){
        
        sexImageView.image = [UIImage imageNamed:@"女"];
        
        ageView.backgroundColor = GIRLECOLOR;
        
    }else{
        
        sexImageView.image = [UIImage imageNamed:@"双性"];
        
        ageView.backgroundColor = DOUBLECOLOR;
    }

    
    UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 3, 18, 9)];
    
    ageLabel.text = [NSString stringWithFormat:@"%@",dic[@"age"]];
    ageLabel.textAlignment = NSTextAlignmentCenter;
    ageLabel.textColor = [UIColor whiteColor];
    ageLabel.font = [UIFont systemFontOfSize:10];
    [ageView addSubview:ageLabel];
    
    //创建显示性取向的label
    UILabel *sexualLabel = [[UILabel alloc] initWithFrame:CGRectMake(ageView.frame.origin.x + ageView.frame.size.width + 5, ageView.frame.origin.y, 20, 15)];
    if ([dic[@"role"] isEqualToString:@"S"]) {
        
        sexualLabel.text = @"斯";
        
        sexualLabel.backgroundColor = BOYCOLOR;
        
    }else if ([dic[@"role"] isEqualToString:@"M"]){
        
        sexualLabel.text = @"慕";
        
        sexualLabel.backgroundColor = GIRLECOLOR;
        
    }else if([dic[@"role"] isEqualToString:@"SM"]){
        
        sexualLabel.text = @"双";
        
        sexualLabel.backgroundColor = DOUBLECOLOR;
        
    }else{
        
        sexualLabel.text = @"~";
        sexualLabel.backgroundColor = GREENCOLORS;
    }
    sexualLabel.font = [UIFont systemFontOfSize:10];
    sexualLabel.layer.cornerRadius = 2;
    sexualLabel.clipsToBounds = YES;
    sexualLabel.textAlignment = NSTextAlignmentCenter;
    sexualLabel.textColor = [UIColor whiteColor];
    [bottomView addSubview:sexualLabel];
    
    //创建显示城市的view
    UIView *cityView = [[UIView alloc] init];
    cityView.layer.cornerRadius = 2;
    cityView.clipsToBounds = YES;
    cityView.backgroundColor = [UIColor colorWithRed:182/255.0 green:182/255.0 blue:182/255.0 alpha:1];
    [bottomView addSubview:cityView];
    
    UIImageView *cityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 2, 10, 10)];
    cityImageView.image = [UIImage imageNamed:@"所在城市"];
    [cityView addSubview:cityImageView];
    
    UILabel *cityLabel = [[UILabel alloc] init];
    
    if ([dic[@"province"] length] == 0 && [dic[@"city"] length] == 0) {
        
        cityLabel.text = [NSString stringWithFormat:@"%@",@"隐身"];
        
    }else{
        
        if ([dic[@"province"] isEqualToString:dic[@"city"]]) {
            
            cityLabel.text = [NSString stringWithFormat:@"%@",dic[@"province"]];
            
        }else{
            
            cityLabel.text = [NSString stringWithFormat:@"%@ %@",dic[@"province"],dic[@"city"]];
        }
    }
    
    cityLabel.font = [UIFont systemFontOfSize:10];
    cityLabel.textColor = [UIColor whiteColor];
    [cityLabel sizeToFit];
    cityLabel.frame = CGRectMake(cityImageView.frame.origin.x + cityImageView.frame.size.width + 1, 3, cityLabel.frame.size.width, 9);
    [cityView addSubview:cityLabel];
    
    cityView.frame = CGRectMake(sexualLabel.frame.origin.x + sexualLabel.frame.size.width + 5, ageView.frame.origin.y, cityLabel.frame.origin.x + cityLabel.frame.size.width + 3, 15);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
  
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
