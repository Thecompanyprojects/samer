//
//  LDApplyMatchmakerViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/8/18.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDApplyMatchmakerViewController.h"
#import "LDEditMatchmakerViewController.h"
#import "LDEditIntroduceViewController.h"
#import "PersonChatViewController.h"
#import "ApplyMatchmakerCell.h"
#import "ApplyMatchMakerModel.h"
#import "LDOwnInformationViewController.h"

@interface LDApplyMatchmakerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>


//存储cell
@property (nonatomic, strong) ApplyMatchmakerCell *matchmakerCell;

//头像与空件间的水平距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sexX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *severviceX;

//创建整体的视图
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

//客服的数组
@property (nonatomic, strong) NSMutableArray *serviceArray;

//存储cell的高度
@property (nonatomic, assign) CGFloat cellH;

//头视图
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerW;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *headerNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerCerView;
@property (weak, nonatomic) IBOutlet UILabel *headerServiceLabel;

@property (weak, nonatomic) IBOutlet UILabel *sexualLabel;
@property (weak, nonatomic) IBOutlet UIView *aSexView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexLabel;

//城市的view
@property (weak, nonatomic) IBOutlet UIView *cityView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityW;

//step
@property (weak, nonatomic) IBOutlet UIView *step1View;
@property (weak, nonatomic) IBOutlet UIView *step2View;
@property (weak, nonatomic) IBOutlet UIView *step3View;

//step2的字典,及无数据时的提示
@property (nonatomic,strong) NSMutableDictionary *stemp2Dic;
@property (nonatomic,strong) UIView *stemp2WarnView;

//step3的字典,及无数据时的提示
@property (nonatomic,strong) NSMutableArray *stemp3Array;
//存储红娘荐语
@property (nonatomic,copy) NSString *stemp3IntroduceStr;
//是否有红娘荐语
@property (nonatomic,assign) BOOL isHaveIntroduce;
//是否有配对的用户
@property (nonatomic,assign) BOOL isHaveMatchObList;


//用于记录在哪一步
@property (nonatomic ,copy) NSString *recordStep;

@end

@implementation LDApplyMatchmakerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.step1View.layer.cornerRadius = 4;
    self.step1View.layer.masksToBounds = YES;
    
    self.step2View.layer.cornerRadius = 4;
    self.step2View.layer.masksToBounds = YES;
    
    self.step3View.layer.cornerRadius = 4;
    self.step3View.layer.masksToBounds = YES;
    
    //调整头像与控件间的水平距离
    self.nameX.constant = self.nameX.constant * WIDTHRADIO;
    self.sexX.constant = self.sexX.constant * WIDTHRADIO;
    self.severviceX.constant = self.severviceX.constant * WIDTHRADIO;
    
    _recordStep = @"1";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _dataArray = [NSMutableArray arrayWithArray:@[@[@"1.深入沟通",@"2.交付费用"],@[@"3.个人相册",@"4.内心独白"],@[@"5.红娘荐语",@"6.展开介绍"]]];
    _serviceArray = [NSMutableArray array];
    _stemp2Dic = [NSMutableDictionary dictionary];
    _stemp3Array = [NSMutableArray array];
    
    _headerW.constant = WIDTH;
    
    //创建tableView
    [self createTableView];
    
    //获取头部视图的数据信息
    [self createHeaderView];
    
    //获取客服的数据信息
    [self createServiceData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editSuccess) name:@"红娘资料编辑成功" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editIntroduceSuccess) name:@"红娘荐语编辑成功" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editPresentSuccess) name:@"红娘展开介绍编辑成功" object:nil];
}


/**
 * 上传资料成功
 */
-(void)editSuccess{
    
    [self getStep2Data];
}

/**
 * 红娘荐语编辑成功
 */
-(void)editIntroduceSuccess{
    
    [self getStep3IntroduceData];
}

/**
 * 红娘编辑介绍成功
 */
-(void)editPresentSuccess{
    
    [self getStep3PresentData];
}

/**
 * 移除监听
 */
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 * 头视图数据
 */
-(void)createHeaderView{
    
   
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Matchmaker/getUserCenterHeader"];
    
    NSDictionary *parameters = @{@"uid": self.userId};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 2000) {
            
            self.headerImageView.layer.cornerRadius = 40;
            self.headerImageView.layer.masksToBounds = YES;
            
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:responseObj[@"data"][@"head_pic"]] placeholderImage:[UIImage imageNamed:@"红娘未知图片"]];
            
            self.headerNameLabel.text = responseObj[@"data"][@"nickname"];
            
            if ([responseObj[@"data"][@"realname"] intValue] == 1) {
                
                self.headerCerView.hidden = NO;
                
            }else{
                
                self.headerCerView.hidden = YES;
            }
            
            if ([responseObj[@"data"][@"match_state"] intValue] == 0) {
                
                self.headerServiceLabel.text = @"非牵线会员";
                
            }else if([responseObj[@"data"][@"match_state"] intValue] == 1){
                
                self.headerServiceLabel.text = @"资料待完善";
                
            }else if([responseObj[@"data"][@"match_state"] intValue] == 2){
                
                self.headerServiceLabel.text = @"资料审核中";
                
            }else if([responseObj[@"data"][@"match_state"] intValue] == 3){
                
                self.headerServiceLabel.text = @"正在牵线服务中";
                
            }else if([responseObj[@"data"][@"match_state"] intValue] == 4 || [responseObj[@"data"][@"match_state"] intValue] == 5){
                
                self.headerServiceLabel.text = @"服务已结束";
            }
            
            self.sexualLabel.layer.cornerRadius = 2;
            self.sexualLabel.layer.masksToBounds = YES;
            
            if ([responseObj[@"data"][@"role"] isEqualToString:@"S"]) {
                
                self.sexualLabel.text = @"斯";
                
                self.sexualLabel.backgroundColor = BOYCOLOR;
                
            }else if ([responseObj[@"data"][@"role"] isEqualToString:@"M"]){
                
                self.sexualLabel.text = @"慕";
                
                self.sexualLabel.backgroundColor = GIRLECOLOR;
                
            }else if([responseObj[@"data"][@"role"] isEqualToString:@"SM"]){
                
                self.sexualLabel.text = @"双";
                
                self.sexualLabel.backgroundColor = DOUBLECOLOR;
                
            }else{
                
                self.sexualLabel.text = @"~";
                self.sexualLabel.backgroundColor = GREENCOLORS;
            }
            
            self.aSexView.layer.cornerRadius = 2;
            self.aSexView.layer.masksToBounds = YES;
            
            if ([responseObj[@"data"][@"sex"] intValue] == 1) {
                
                self.sexLabel.image = [UIImage imageNamed:@"男"];
                
                self.aSexView.backgroundColor = BOYCOLOR;
                
            }else if ([responseObj[@"data"][@"sex"] intValue] == 2){
                
                self.sexLabel.image = [UIImage imageNamed:@"女"];
                
                self.aSexView.backgroundColor = GIRLECOLOR;
                
            }else{
                
                self.sexLabel.image = [UIImage imageNamed:@"双性"];
                
                self.aSexView.backgroundColor = DOUBLECOLOR;
            }
            
            self.ageLabel.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"age"]];
            
            self.cityView.layer.cornerRadius = 2;
            self.cityView.layer.masksToBounds = YES;
            
            if (![responseObj[@"data"][@"city"] isEqual:[NSNull null]] && ![responseObj[@"data"][@"province"] isEqual:[NSNull null]]) {
                
                if([responseObj[@"data"][@"city"] length] != 0){
                    
                    if ([responseObj[@"data"][@"city"] isEqualToString:responseObj[@"data"][@"province"]]) {
                        
                        self.cityLabel.text = responseObj[@"data"][@"city"];
                        
                    }else{
                        
                        if ([responseObj[@"data"][@"province"] length] != 0) {
                            
                            self.cityLabel.text = [NSString stringWithFormat:@"%@ %@",responseObj[@"data"][@"province"],responseObj[@"data"][@"city"]];
                            
                        }else{
                            
                            self.cityLabel.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"city"]];
                        }
                    }
                    
                }else{
                    
                    self.cityLabel.text = @"隐身";
                    
                }
            }else{
                
                self.cityLabel.text = @"隐身";
            }
            
            [self.cityLabel sizeToFit];
            
            self.cityW.constant = 18 + CGRectGetWidth(self.cityLabel.frame);
            
        }else{
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"获取个人基本资料信息失败~"];
        }
    } failed:^(NSString *errorMsg) {
        
    }];

}

/**
 * 客服数据的请求获取
 */
-(void)createServiceData{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Matchmaker/getMatchmakerInfo"];
    [NetManager afPostRequest:url parms:nil finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            [_serviceArray addObjectsFromArray:responseObj[@"data"]];
            [self.tableView reloadData];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

/**
 * 点击上方标签切换不同的步骤
 */
- (IBAction)stempButtonClick:(UIButton *)sender {
    
    if ([self.headerServiceLabel.text isEqualToString:@"非牵线会员"] && sender.tag != 10) {
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您还不是牵线会员,请开通后查看~"];
        
    }else{
        
        if (_stemp2WarnView != nil) {
            
            [_stemp2WarnView removeFromSuperview];
            
            _stemp2WarnView = nil;
        }
        
        for (int i = 0; i < 3; i++) {
            
            UIButton *button = [_headerView viewWithTag:i + 10];
            
            UIView *stepView = [_headerView viewWithTag:i + 20];
            
            if (sender.tag == button.tag) {
                
                stepView.backgroundColor = stepView.backgroundColor = [UIColor colorWithRed:196/255.0 green:80/255.0 blue:214/255.0 alpha:0.7];
                
                _recordStep = [NSString stringWithFormat:@"%d",i + 1];
                
                sender.userInteractionEnabled = NO;
                
            }else{
                
                stepView.backgroundColor = [UIColor colorWithRed:182/255.0 green:182/255.0 blue:182/255.0 alpha:0.7];
                
                button.userInteractionEnabled = YES;
            }
        }
        
        if (sender.tag == 10) {
            
            [self.tableView reloadData];
            
        }else if (sender.tag == 11) {
            
            [self getStep2Data];
            
        }else if(sender.tag == 12){
            
            [self getStep3Data];
        }
    }
}

/**
 * 获取第三步的数据
 */
-(void)getStep3Data{
    //获取第三步的红娘荐语的数据
    [self getStep3IntroduceData];
    //获取第三步的展开介绍的数据
    [self getStep3PresentData];
}

/**
 * 获取第三步的展开介绍的数据
 */

-(void)getStep3PresentData{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Matchmaker/getMatchObList"];
    
    NSDictionary *parameters = @{@"uid":self.userId};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 2000) {
            
            if (self.stemp3Array.count != 0) {
                
                [self.stemp3Array removeAllObjects];
                
            }
            [self.stemp3Array addObjectsFromArray:responseObj[@"data"]];
            _isHaveMatchObList = YES;
            
        }else if (integer == 3000){
            
            _isHaveMatchObList = NO;
            
        }else{
            
            _isHaveMatchObList = NO;
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请求错误"];
        }
        
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        _isHaveMatchObList = NO;
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"网络连接失败,请检查网络设置~"];
    }];
}

/**
 * 获取第三步的红娘荐语的数据
 */
-(void)getStep3IntroduceData{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Matchmaker/getMatchMakerIntroduce"];
    
    NSDictionary *parameters = @{@"uid":self.userId};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 2000) {
            
            _stemp3IntroduceStr = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"match_makerintroduce"]];
            
            _isHaveIntroduce = YES;
            
        }else if (integer == 3000){
            
            _isHaveIntroduce = NO;
            
        }else{
            
            _isHaveIntroduce = NO;
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请求错误"];
        }
        
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        _isHaveIntroduce = NO;
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"网络连接失败,请检查网络设置~"];
    }];
}

/**
 * 获取第二步的数据
 */
-(void)getStep2Data{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Matchmaker/getStep2Info"];
    
    NSDictionary *parameters = @{@"uid":self.userId,@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 2000) {
            
            if ([responseObj[@"data"][@"match_state"] intValue] == 0) {
                
                self.headerServiceLabel.text = @"非牵线会员";
                
            }else if([responseObj[@"data"][@"match_state"] intValue] == 1){
                
                self.headerServiceLabel.text = @"资料待完善";
                
            }else if([responseObj[@"data"][@"match_state"] intValue] == 2){
                
                self.headerServiceLabel.text = @"资料审核中";
                
            }else if([responseObj[@"data"][@"match_state"] intValue] == 3){
                
                self.headerServiceLabel.text = @"正在牵线服务中";
                
            }else if([responseObj[@"data"][@"match_state"] intValue] == 4 || [responseObj[@"data"][@"match_state"] intValue] == 5){
                
                self.headerServiceLabel.text = @"服务已结束";
            }
            
            if ([responseObj[@"data"][@"match_introduce"] length] == 0 && [responseObj[@"data"][@"match_photo"] count] == 0) {
                
                if ([responseObj[@"data"][@"match_state"] intValue] == 0) {
                    
                    [self createStep2WarnView:@"非牵线会员~"];
                    
                }else{
                    
                    [self createStep2WarnView:@"请完善您的相册及独白"];
                }
                
            }else{
                
                if (self.stemp2Dic.count != 0) {
                    
                    [self.stemp2Dic removeAllObjects];
                }
                
                [self.stemp2Dic setDictionary:responseObj[@"data"]];
                
                [self.tableView reloadData];
            }
            
        }else if (integer == 4002){
            [self createStep2WarnView:@"非牵线会员~"];
        }else{
            [self createStep2WarnView:@"请求发生错误~"];
        }
    } failed:^(NSString *errorMsg) {
         [self createStep2WarnView:@"网络连接错误,请检查网络设置~"];
    }];
}

-(void)createStep2WarnView:(NSString *)warnString{
    
    self.stemp2WarnView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame), self.tableView.frame.size.width, self.tableView.frame.size.height - CGRectGetMaxY(_headerView.frame))];
    
    _stemp2WarnView.backgroundColor = [UIColor whiteColor];
    
    CGFloat editButtonW = CGRectGetWidth(self.step2View.frame);
    CGFloat editButtonH = editButtonW / 1.4;
    CGFloat editButtonY = (CGRectGetHeight(self.stemp2WarnView.frame) - editButtonH)/2 - editButtonH;
    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.step2View.frame), editButtonY, editButtonW, editButtonH)];
    [editButton setBackgroundImage:[UIImage imageNamed:@"红娘完善资料"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(stemp2EditButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_stemp2WarnView addSubview:editButton];
    
    if ([warnString isEqualToString:@"请完善您的相册及独白"]) {
        
        editButton.userInteractionEnabled = YES;
        
    }else{
        
        editButton.userInteractionEnabled = NO;
    }
    
    UILabel *editLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(editButton.frame) + 20, WIDTH, 20)];
    editLabel.text = warnString;
    editLabel.textColor = [UIColor lightGrayColor];
    editLabel.textAlignment = NSTextAlignmentCenter;
    editLabel.font = [UIFont systemFontOfSize:15];
    [_stemp2WarnView addSubview:editLabel];
    
    [self.tableView addSubview:self.stemp2WarnView];
    
    [self.tableView reloadData];
}

/**
 * 编辑红娘会员的个人资料
 */
-(void)stemp2EditButtonClick{
    
    LDEditMatchmakerViewController *mvc = [[LDEditMatchmakerViewController alloc] init];
    mvc.title = @"修改资料";
    mvc.userId = self.userId;
    [self.navigationController pushViewController:mvc animated:YES];
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStyleGrouped];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.tableView.tableHeaderView = _headerView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ([_recordStep intValue] == 2 && self.stemp2Dic.count == 0) {
        
        return 0;
    }
    
    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([_recordStep intValue] == 3 && section == 1) {
        
        if (_isHaveMatchObList) {
            
            return self.stemp3Array.count;
        }
        
        return 1;
    }
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_recordStep intValue] == 1) {
        
        ApplyMatchmakerCell *cell = [[ApplyMatchmakerCell alloc] init];
        
        if (indexPath.section == 0) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"ApplyMatchmakerCell" owner:self options:nil][0];
            
            for (int i = 10 ; i < 13; i++) {
                
                UIButton *button = [cell.contentView viewWithTag:i];

                if (i - 9 <= _serviceArray.count) {
                    
                    [button sd_setBackgroundImageWithURL:[NSURL URLWithString:_serviceArray[i - 10][@"head_pic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"红娘未知图片"]];
                    
                    if (i == 10) {
                        
                        cell.oneLabel.text = _serviceArray[i - 10][@"nickname"];
                        
                    }else if (i == 11){
                        
                        cell.twoLabel.text = _serviceArray[i - 10][@"nickname"];
                        
                    }else if (i == 12){
                        
                        cell.threeLabel.text = _serviceArray[i - 10][@"nickname"];
                    }
                    
                }else{
                    
                    [button setBackgroundImage:[UIImage imageNamed:@"红娘未知图片"] forState:UIControlStateNormal];
                    
                }
                
                [button addTarget:self action:@selector(serviceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [cell.mobileButton addTarget:self action:@selector(mobileButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.phoneButton addTarget:self action:@selector(phoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if(indexPath.section == 1){
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"ApplyMatchmakerCell" owner:self options:nil][1];
 
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if ([_recordStep intValue] == 2){
        
        ApplyMatchmakerCell *cell = [[ApplyMatchmakerCell alloc] init];
        
        if (indexPath.section == 0){
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"ApplyMatchmakerCell" owner:self options:nil][2];
            
            if ([self.stemp2Dic[@"match_photo_lock"] intValue] == 0) {
                
                UIButton *button = (UIButton *)[cell.contentView viewWithTag:20];
                
                button.userInteractionEnabled = NO;
                
                button.selected = YES;
                
            }else if ([self.stemp2Dic[@"match_photo_lock"] intValue] == 1) {
                
                UIButton *button = (UIButton *)[cell.contentView viewWithTag:21];
                
                button.userInteractionEnabled = NO;
                
                button.selected = YES;
                
            }else{
                
                UIButton *button = (UIButton *)[cell.contentView viewWithTag:22];
                
                button.userInteractionEnabled = NO;
                
                button.selected = YES;
            }
            
            for (int i = 20; i < 23; i++) {
                
                UIButton *button = (UIButton *)[cell.contentView viewWithTag:i];
                
                [button addTarget:self action:@selector(showOrHiddenPic:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            CGFloat bothPicSpace = 6;
            int picScrollH = ((WIDTH - 20) - 3 * bothPicSpace)/3.5;
            
            int picCount = (int)[self.stemp2Dic[@"match_photo"] count];
          
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 20, picScrollH)];
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.contentSize = CGSizeMake(picScrollH * picCount + bothPicSpace * (picCount - 1), picScrollH);
            [cell.picBackView addSubview:scrollView];
            
            for (int i = 0; i < picCount; i++) {
                
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(picScrollH * i + bothPicSpace * i, 0, picScrollH, picScrollH)];
                
                [img sd_setImageWithURL:[NSURL URLWithString:self.stemp2Dic[@"match_photo"][i]] placeholderImage:[UIImage imageNamed:@"动态图片默认"] ];
                
                img.userInteractionEnabled = YES;
                
                img.tag = 30 + i;
                
                img.contentMode = UIViewContentModeScaleAspectFill;
                
                img.clipsToBounds = YES;
                
                [scrollView addSubview:img];
            }
            
            cell.editPicTopH.constant = 0;
            
            cell.editPicWarnH.constant = 0;
            
            _cellH = cell.contentView.frame.size.height + picScrollH - 25 - 16 - 10;
            
        }else if (indexPath.section == 1){
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"ApplyMatchmakerCell" owner:self options:nil][3];
            
            cell.introduceLabel.text = @"1、自我介绍、斯慕经历、喜恶项目等；2、择友要求：征友地区、年龄、身材、长相、长期短期、结婚意向等。3、请勿使用大尺度文字描述。";
            
            cell.recommendEditButton.hidden = YES;
            
            cell.editTextView.text = self.stemp2Dic[@"match_introduce"];
            
            cell.editTextView.editable = NO;
            
            if ([self.stemp2Dic[@"match_introduce"] length] == 0) {
                
                cell.introduceLabel.hidden = NO;
                
            }else{
                
                cell.introduceLabel.hidden = YES;
            }
            
            cell.editTextView.delegate = self;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    ApplyMatchmakerCell *cell = [[ApplyMatchmakerCell alloc] init];
    
   if (indexPath.section == 0){
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"ApplyMatchmakerCell" owner:self options:nil][3];
       
       if (_isHaveIntroduce) {
           
           cell.introduceView.hidden = NO;
           cell.noIntrouceView.hidden = YES;
           cell.noIntroduceLabel.hidden = YES;
           
           cell.editTextView.text = _stemp3IntroduceStr;
           
       }else{
           
           cell.introduceView.hidden = YES;
           cell.noIntrouceView.hidden = NO;
           cell.noIntroduceLabel.hidden = NO;
           
           cell.editTextView.text = @"";
       }
       
       cell.editTextView.editable = NO;
       
       if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
           
           cell.recommendEditButton.hidden = NO;
           
           [cell.recommendEditButton addTarget:self action:@selector(recommendEditButtonClick) forControlEvents:UIControlEventTouchUpInside];
           
       }else{
           
           cell.recommendEditButton.hidden = YES;
       }
        
    }else if (indexPath.section == 1){
        
        if (_isHaveMatchObList) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"ApplyMatchmakerCell" owner:self options:nil][4];
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
                
                cell.matchObListEditButton.hidden = NO;
                
                cell.matchObListEditButton.tag = indexPath.row + 100;
                
                [cell.matchObListEditButton addTarget:self action:@selector(matchObListEditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                
                cell.matchObListEditButton.hidden = YES;
            }
            
            cell.matchObListTextView.editable = NO;
            
            if (indexPath.row == _stemp3Array.count - 1) {
                
                cell.matchObListLineView.hidden = YES;
                
            }else{
                
                cell.matchObListLineView.hidden = NO;
            }
            
            NSDictionary *dic = _stemp3Array[indexPath.row];
            
            [cell cellwithDic:dic];

        }else{
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"ApplyMatchmakerCell" owner:self options:nil][5];

        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

/**
 * 控制相册的可见权限的开关变化
 */
-(void)showOrHiddenPic:(UIButton *)button{
    
    NSString *url;
    
    if (button.tag == 20) {
        
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Matchmaker/setPhotoLock/method/0"];
        
    }else if(button.tag == 21){
        
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Matchmaker/setPhotoLock/method/1"];
        
    }else{
        
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Matchmaker/setPhotoLock/method/2"];
    }
    
    NSDictionary *parameters = @{@"uid":self.userId};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 2000) {
            
            button.selected = !button.selected;
            
            button.userInteractionEnabled = NO;
            
            for (int i = 20; i < 23; i++) {
                
                UIButton *btn = (UIButton *)[button.superview viewWithTag:i];
                
                if (i != button.tag) {
                    
                    btn.selected = NO;
                    
                    btn.userInteractionEnabled = YES;
                }
            }
            
        }else{
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"设置失败~"];
        }
    } failed:^(NSString *errorMsg) {
         [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"网络连接错误,请检查网络设置~"];
    }];
}

/**
 * 编辑红娘荐语按钮
 */
-(void)recommendEditButtonClick{
    
    LDEditIntroduceViewController *introduce = [[LDEditIntroduceViewController alloc] init];
    introduce.title = @"红娘荐语";
    introduce.userId = self.userId;
    introduce.introduce = _stemp3IntroduceStr;
    [self.navigationController pushViewController:introduce animated:YES];
}

/**
 * 编辑展开介绍按钮
 */
-(void)matchObListEditButtonClick:(UIButton *)button{
    
    LDEditIntroduceViewController *introduce = [[LDEditIntroduceViewController alloc] init];
    introduce.title = @"红娘荐语";
    introduce.userId = self.userId;
    introduce.introduce = _stemp3Array[button.tag - 100][@"remarks"];
    introduce.fid = _stemp3Array[button.tag - 100][@"mid"];
    [self.navigationController pushViewController:introduce animated:YES];
}

//点击座机拨打电话
-(void)mobileButtonClick:(UIButton *)button{
    
    WKWebView *webView = [[WKWebView alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",button.titleLabel.text]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
}

//点击手机拨打电话
-(void)phoneButtonClick:(UIButton *)button{
    
    WKWebView *webView = [[WKWebView alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",button.titleLabel.text]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
}

//点击客服头像进行红娘服务咨询
-(void)serviceButtonClick:(UIButton *)button{

    if (button.tag - 9 <= _serviceArray.count) {

        LDOwnInformationViewController *InfoVC = [LDOwnInformationViewController new];
        InfoVC.userID = [NSString stringWithFormat:@"%@",_serviceArray[button.tag - 10][@"uid"]];
        [self.navigationController pushViewController:InfoVC animated:YES];
        
        
    }else{
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"客服未在线,请选择其他客服或电话联系我们~"];
    
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_recordStep intValue] == 1) {//第二步cell的高度
        
        if (indexPath.section == 0) {
            
            return 157;
            
        }else if (indexPath.section == 1){
            
            return 120;
            
        }
        
    }else if ([_recordStep intValue] == 2){//第二步cell的高度
        
        if (indexPath.section == 0){
            
            return _cellH;
            
        }else if (indexPath.section == 1){
            
            return 160;
        }
    }
    
    //第3步的红娘推荐语的cell高度
    if (indexPath.section == 0){
    
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
            
            return 195;
        }
        
        return 160;
    }
    
    if (_isHaveMatchObList) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
            
            return 278;
        }
        
        return 240;
    }
    
    return 155;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 1 && [self.stemp2Dic[@"match_state"] intValue] < 4 && [self.stemp2Dic[@"match_state"] intValue] > 0 && [_recordStep intValue] == 2) {
        
        return 80;
    }
    
    return 0.00000001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, WIDTH - 20, 40)];
    backImageView.image = [UIImage imageNamed:@"红娘文字背景"];
    [view addSubview:backImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, WIDTH - 20, 30)];
    
    label.text = _dataArray[[_recordStep intValue] - 1][section];
    
    label.textColor = [UIColor whiteColor];
    
    label.font = [UIFont systemFontOfSize:14];
    
    [view addSubview:label];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 1 && [self.stemp2Dic[@"match_state"] intValue] < 4 && [self.stemp2Dic[@"match_state"] intValue] > 0 && [_recordStep intValue] == 2) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0 ,0 , WIDTH, 80)];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - 100 * WIDTHRADIO)/2, 10, 100 * WIDTHRADIO, 43 * WIDTHRADIO)];
        [view addSubview:button];
        
        if ([self.stemp2Dic[@"match_state"] intValue] == 2) {
            
            [button setBackgroundImage:[UIImage imageNamed:@"红娘审核中按钮"] forState:UIControlStateNormal];
            
        }else{
            
            [button setBackgroundImage:[UIImage imageNamed:@"红娘修改按钮"] forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return view;
    }
    
    return [[UIView alloc] init];
}

-(void)editButtonClick{
    
    LDEditMatchmakerViewController *mvc = [[LDEditMatchmakerViewController alloc] init];
    mvc.title = @"修改资料";
    mvc.userId = self.userId;
    [self.navigationController pushViewController:mvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
