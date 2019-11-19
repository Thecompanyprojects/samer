//
//  LDGiveGifListPageViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/22.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGiveGifListPageViewController.h"
#import "LDOwnInformationViewController.h"
#import "GiveGifCell.h"
#import "GiveGifModel.h"

@interface LDGiveGifListPageViewController ()<UITableViewDelegate,UITableViewDataSource>
//首页tableview及数据源
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
//分页page
@property (nonatomic,assign) int tablePage;
@property (nonatomic,strong) UIView *headerView;
@end

@implementation LDGiveGifListPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.dataArray = [NSMutableArray array];
    
    [self createTableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _tablePage = 0;
        [self createDatatype:@"1"];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _tablePage++;
        [self createDatatype:@"2"];
    }];
}

-(void)createDatatype:(NSString *)type{
    
    NSString *url;
    
    NSDictionary *parameters;
    NSString *contentss = [NSString new];
    if ([self.content isEqualToString:@"0"]) {
        contentss = @"0";
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_tablePage],@"type":contentss,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getPresentMsgUrl];
        
    }
    if ([self.content isEqualToString:@"1"]) {
        contentss = @"1";
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_tablePage],@"type":contentss,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getPresentMsgUrl];
    }
    if ([self.content isEqualToString:@"2"]) {
        url = [PICHEADURL stringByAppendingString:getTopcardUsedLb];
        parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
    }
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if ([type intValue]==1) {
            if ([self.content intValue]==0) {
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"redgiftnum"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"delloudspeakers" object:nil];
                });
            }
            if ([self.content intValue]==1) {
                 [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"redvipnum"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"delloudspeakers" object:nil];
            }
            if ([self.content intValue]==2) {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"redtopcardnum"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"delloudspeakers" object:nil];
            }
        }
        
        if (integer != 2000 && integer != 2001) {
            if (integer == 4000) {
                if ([type intValue] == 1) {
                    [_dataArray removeAllObjects];
                    [_tableView reloadData];
                    self.tableView.mj_footer.hidden = YES;
                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                [self.tableView.mj_footer endRefreshing];
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }
        }else{
            if ([type intValue] == 1) {
                [_dataArray removeAllObjects];
            }
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[GiveGifModel class] json:responseObj[@"data"]]];
            [self.dataArray addObjectsFromArray:data];
            
            self.tableView.mj_footer.hidden = NO;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView.mj_header endRefreshing];
    } failed:^(NSString *errorMsg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 44) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor blackColor];
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count?:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GiveGifCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiveGif"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GiveGifCell" owner:self options:nil].lastObject;
    }
    if ([self.content isEqualToString:@"2"]) {
        cell.isTopcard = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count > 0) {
        GiveGifModel *model = _dataArray[indexPath.row];
        cell.model = model;
    }
    [cell.giveButton addTarget:self action:@selector(giveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.givenButton addTarget:self action:@selector(givenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)giveButtonClick:(UIButton *)button{
    GiveGifCell *cell = (GiveGifCell *) button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    GiveGifModel *model = _dataArray[indexPath.row];
    ivc.userID = model.uid;
    [self.navigationController pushViewController:ivc animated:YES];
}

-(void)givenButtonClick:(UIButton *)button{

    GiveGifCell *cell = (GiveGifCell *) button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    GiveGifModel *model = _dataArray[indexPath.row];
    ivc.userID = model.fuid;
    [self.navigationController pushViewController:ivc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

#pragma mark - HeaderView

-(UIView *)headerView
{
    if(!_headerView)
    {
        _headerView = [[UIView  alloc] init];
        _headerView.frame = CGRectMake(0, 0, WIDTH, 44);
        UILabel *lab = [UILabel new];
        [_headerView addSubview:lab];
        lab.frame = CGRectMake(0, 15, WIDTH, 20);
        lab.font = [UIFont systemFontOfSize:13];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        if ([self.content isEqualToString:@"0"]) {
            lab.text = @"送500魔豆以上的礼物可上大喇叭";
        }
        if ([self.content isEqualToString:@"1"]) {
            lab.text = @"送SVIP会员可上大喇叭";
        }
        if ([self.content isEqualToString:@"2"]) {
            lab.text = @"推顶动态可上大喇叭,可获魅力值";
        }
    }
    return _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
