//
//  redgrouplistVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/23.
//  Copyright © 2019 a. All rights reserved.
//

#import "redgrouplistVC.h"
#import "toreceiveCell.h"
#import "toreceiveModel.h"
#import "redgroupModel.h"
#import "LDOwnInformationViewController.h"

@interface redgrouplistVC ()<UITableViewDataSource,UITableViewDelegate,toreceiveDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *messageLab;
@property (nonatomic,strong) UILabel *numberLab;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

static NSString *redgroupIdentfity = @"redgroupIdentfity";

@implementation redgrouplistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = [NSMutableArray array];
    [self creaeData];
    [self createTableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataSource removeAllObjects];
        [self creaeData];
    }];
}

-(void)creaeData
{
    if (self.message.length==0) {
        self.messageLab.text = @"恭喜发财，大吉大利";
    }
    else
    {
        self.messageLab.text = self.message;
    }
    [self.tableView reloadData];
    NSString *url = [PICHEADURL stringByAppendingString:getQunRedbagListUrl];
    NSDictionary *params = @{@"orderid":self.orderid};
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSArray *datas = [NSArray yy_modelArrayWithClass:[redgroupModel class] json:responseObj[@"data"][@"datas"]];
            [self.dataSource addObjectsFromArray:datas];
            if (self.dataSource.count!=0) {
                NSDictionary *dict = responseObj[@"data"];
                redgroupModel *models = [self.dataSource firstObject];
                self.titleLab.text = [NSString stringWithFormat:@"%@%@",models.nickname,@"的红包"];
                NSInteger back = (long)[dict objectForKey:@"back"];
                if (back==1) {
                    self.numberLab.text = @"该红包已过期";
                }else
                {
                    NSString *tnum = [dict objectForKey:@"tnum"];
                    NSString *nums = [dict objectForKey:@"nums"];
                    NSMutableArray *moneyarra= [NSMutableArray new];
                    for (int i =0; i<self.dataSource.count; i++) {
                        redgroupModel *newmodels = self.dataSource[i];
                        [moneyarra addObject:newmodels.num];
                    }
                    NSInteger sum = [[moneyarra valueForKeyPath:@"@sum.floatValue"] intValue];
                    
                    self.numberLab.text = [NSString stringWithFormat:@"%@%@%@%@%@%lu%@%ld%@",@"共",nums,@"个/",tnum,@"金魔豆,已领取",(unsigned long)self.dataSource.count,@"个/",(long)sum,@"金魔豆"];
                }
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }
    } failed:^(NSString *errorMsg) {
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self vhl_setNavBarShadowImageHidden:NO];
    [self vhl_setNavBarBackgroundColor:[UIColor whiteColor]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self vhl_setNavBarShadowImageHidden:YES];
    [self vhl_setNavBarBackgroundColor:[UIColor colorWithHexString:@"EF5B49" alpha:1]];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 0) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE" alpha:1];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = self.headView;
}

-(UIView *)headView
{
    if(!_headView)
    {
        _headView = [[UIView alloc] init];
        _headView.frame = CGRectMake(0, -2, WIDTH, 170);
        [_headView addSubview:self.bgView];
        [_headView addSubview:self.headImg];
        [_headView addSubview:self.titleLab];
        [_headView addSubview:self.messageLab];
        [_headView addSubview:self.numberLab];
    }
    return _headView;
}

-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.frame = CGRectMake(0, -2, WIDTH, 75);
        _bgView.backgroundColor = [UIColor colorWithHexString:@"EF5B49" alpha:1];
    }
    return _bgView;
}

-(UIImageView *)headImg
{
    if(!_headImg)
    {
        _headImg = [[UIImageView alloc] init];
        _headImg.frame = CGRectMake(0, 70, WIDTH, 50);
        _headImg.image = [UIImage imageNamed:@"假半圆"];
    }
    return _headImg;
}

-(UILabel *)titleLab
{
    if(!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        _titleLab.frame = CGRectMake(10, 30, WIDTH-20, 20);
        _titleLab.textColor = [UIColor colorWithHexString:@"FED2AD" alpha:1];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

-(UILabel *)messageLab
{
    if(!_messageLab)
    {
        _messageLab = [[UILabel alloc] init];
        _messageLab.frame = CGRectMake(10, 69, WIDTH-20, 16);
        _messageLab.textColor = [UIColor colorWithHexString:@"FED2AD" alpha:1];
        _messageLab.font = [UIFont systemFontOfSize:13];
        _messageLab.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLab;
}

-(UILabel *)numberLab
{
    if(!_numberLab)
    {
        _numberLab = [[UILabel alloc] init];
        _numberLab.frame = CGRectMake(20, 136, WIDTH-40, 20);
        _numberLab.font = [UIFont systemFontOfSize:16];
        _numberLab.textColor = TextCOLOR;
        _numberLab.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLab;
}


#pragma mark - UITableViewDataSource&&UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    toreceiveCell *cell = [tableView dequeueReusableCellWithIdentifier:redgroupIdentfity];
    cell = [[toreceiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:redgroupIdentfity];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell create:self.dataSource[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)touchup:(UITableViewCell *)cell
{
    if (self.dataSource.count==0) {
        return;
    }
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    redgroupModel *model = self.dataSource[index.row];
    LDOwnInformationViewController *InfoVC = [LDOwnInformationViewController new];
    InfoVC.userID = model.uid?:@"";
    [self.navigationController pushViewController:InfoVC animated:YES];
}

@end
