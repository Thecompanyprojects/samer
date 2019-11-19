//
//  LDtopViewController.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/25.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDtopViewController.h"
#import "CommentedCell.h"
#import "CommentedModel.h"
#import "LDOwnInformationViewController.h"
#import "LDDynamicDetailViewController.h"

@interface LDtopViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) int page;
@property (nonatomic,assign) CGFloat cellH;
@end

@implementation LDtopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"推顶过我的";
    self.dataSource = [NSMutableArray array];
    [self createTableView];
    [self createCommentData];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self createCommentData];
    }];
}

-(void)createCommentData{
    
    NSString *url;
    NSDictionary *parameters;
    parameters = @{@"fuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page],@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getTopcardUsedRs];
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (integer == 2000){
            
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[CommentedModel class] json:responseObj[@"data"]]];
            [self.dataSource addObjectsFromArray:data];
            
            self.tableView.mj_footer.hidden = NO;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }else if (integer == 4002){
            self.tableView.mj_footer.hidden = YES;
        }
        [self.tableView.mj_footer endRefreshing];
    } failed:^(NSString *errorMsg) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - creatUI

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count?:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentedCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Commented"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CommentedCell" owner:self options:nil].lastObject;
    }
    if (indexPath.row==self.dataSource.count-1) {
        [cell.lineView setHidden:YES];
    }
    else
    {
        [cell.lineView setHidden:NO];
    }
    CommentedModel *model = self.dataSource[indexPath.row];
    cell.type = @"4";
    cell.model = model;
    _cellH = cell.contentView.frame.size.height;
    [cell.headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.lookDynamicButton addTarget:self action:@selector(lookDynamicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

-(void)lookDynamicButtonClick:(UIButton *)button{
    CommentedCell *cell = (CommentedCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CommentedModel *model = self.dataSource[indexPath.section];
    LDDynamicDetailViewController *dvc = [[LDDynamicDetailViewController alloc] init];
    dvc.did = model.did;
    dvc.ownUid = model.uid;
    [self.navigationController pushViewController:dvc animated:YES];
}

-(void)headButtonClick:(UIButton *)button{
    CommentedCell *cell = (CommentedCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CommentedModel *model = self.dataSource[indexPath.section];
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    ivc.userID = model.uid;
    [self.navigationController pushViewController:ivc animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _cellH;
}
@end
