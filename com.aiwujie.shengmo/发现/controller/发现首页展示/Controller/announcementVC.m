//
//  announcementVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/18.
//  Copyright © 2019 a. All rights reserved.
//

#import "announcementVC.h"
#import "announcementCell.h"
#import "announcementModel.h"
#import "LDAlwaysQuestionH5ViewController.h"
#import "LDDynamicDetailViewController.h"
#import "LDOwnInformationViewController.h"
#import "HeaderTabViewController.h"


@interface announcementVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger page;
@end

static NSString *announcementidendfity = @"announcementidendfity";

@implementation announcementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"爱无界公益";
    self.dataSource = [NSMutableArray array];
    [self createTableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [self createDatatype:@"1"];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self createDatatype:@"2"];
    }];
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
}

-(void)createDatatype:(NSString *)type
{
    if ([type intValue]==1) {
        [self.dataSource removeAllObjects];
    }
    
    NSString *url = [PICHEADURL stringByAppendingString:getBasicNewsListUrl];
    NSDictionary *param = @{@"page":[NSString stringWithFormat:@"%ld",self.page]};
    [NetManager afPostRequest:url parms:param finished:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            
            NSArray *data = [NSArray yy_modelArrayWithClass:[announcementModel class] json:responseObj[@"data"]];
            [self.dataSource addObjectsFromArray:data];
            [self.tableView reloadData];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } failed:^(NSString *errorMsg) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count?:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    announcementCell *cell = [tableView dequeueReusableCellWithIdentifier:announcementidendfity];
    cell = [[announcementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:announcementidendfity];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    announcementModel *model = self.dataSource[indexPath.row];
    if ([model.url_type intValue]==0) {
        NSString *newid = model.Newid;
        NSString *url = [NSString stringWithFormat:@"%@%@%@",PICHEADURL,@"Home/Info/news/id/",newid];
        JXBWebViewController *webVC = [[JXBWebViewController alloc] initWithURLString:url];
        webVC.title = @"圣魔斯慕";
        [self.navigationController pushViewController:webVC animated:YES];
    }
    if ([model.url_type intValue]==1) { //动态
        LDDynamicDetailViewController *vc = [LDDynamicDetailViewController new];
        vc.did = model.url;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([model.url_type intValue]==2) { //话题
        HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
        tvc.tid = model.url;;
        [self.navigationController pushViewController:tvc animated:YES];
    }
    if ([model.url_type intValue]==3) { //主页
        LDOwnInformationViewController *VC = [LDOwnInformationViewController new];
        VC.userID = model.url;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

@end
