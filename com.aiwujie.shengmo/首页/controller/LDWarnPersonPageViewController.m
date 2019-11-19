//
//  LDWarnPersonPageViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/11/17.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDWarnPersonPageViewController.h"
#import "LDOwnInformationViewController.h"
#import "TableModel.h"
#import "WarnPersonCell.h"

@interface LDWarnPersonPageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int page;
@end

@implementation LDWarnPersonPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
        [self createTableView];
        
        _dataArray = [NSMutableArray array];
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            _page = 0;
            
            [self requestData:@"1"];
            
        }];
        
        [self.tableView.mj_header beginRefreshing];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            _page++;
            
            [self requestData:@"2"];
            
        }];
    
    NSLog(@"%@",self.content);
}

/**
 * 请求相应的数据
 */
-(void)requestData:(NSString *)state{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/index/getOutOfLineList"];
    
    NSDictionary *parameters;
    
    parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":[NSString stringWithFormat:@"%d",[self.content intValue] + 1]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        
        if (integer != 2000) {
            
            if (integer == 3000) {
                
                if ([state intValue] == 1) {
                    
                    [_dataArray removeAllObjects];
                    
                    [self.tableView reloadData];
                    
                    self.tableView.mj_footer.hidden = YES; 
                    
                }else{
                    
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }
                
                
            }else{
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"发生错误~"];
                
            }
            
        }else{
            
            if ([state intValue] == 1) {
                
                [_dataArray removeAllObjects];
            }
            
            NSArray *data = [NSArray yy_modelArrayWithClass:[TableModel class] json:responseObj[@"data"]];
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 50) style:UITableViewStyleGrouped];
    
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
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WarnPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WarnPerson"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"WarnPersonCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TableModel *model = _dataArray[indexPath.section];
    cell.content = self.content;
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 88;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    TableModel *model = _dataArray[indexPath.section];
    ivc.userID = model.uid;
    [self.navigationController pushViewController:ivc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
