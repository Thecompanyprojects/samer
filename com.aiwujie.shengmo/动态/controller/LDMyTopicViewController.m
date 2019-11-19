//
//  LDMyTopicViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/7/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDMyTopicViewController.h"
#import "LDCreateTopicViewController.h"
#import "LDMoreTopicPageViewController.h"
#import "HeaderTabViewController.h"
#import "TopicCell.h"
#import "TopicModel.h"

@interface LDMyTopicViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

//保存tableview的偏移量
@property (nonatomic,assign) CGFloat lastScrollOffset;

//分页page
@property (nonatomic,assign) int tablePage;

@end

@implementation LDMyTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    if ([self.userId intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        self.title = @"我的话题";
        self.type = @"1";
    }else{
        
        self.title = @"Ta的话题";
        self.type = @"2";
    }
    
    _dataArray = [NSMutableArray array];
    
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
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getTopicListUrl];
    NSDictionary *parameters = [NSDictionary dictionary];
    if ([self.type intValue]==1) {
         parameters = @{@"page":[NSString stringWithFormat:@"%d",_tablePage],@"type":@"3",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }
    else
    {
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_tablePage],@"type":@"3",@"uid":self.userId?:@""};
    }
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            if (integer == 3000) {
                if ([type intValue] == 1) {
                    [_dataArray removeAllObjects];
                    [_tableView reloadData];
                    self.tableView.mj_footer.hidden = YES;
                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                [self.tableView.mj_footer endRefreshing];
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请求发生错误~"];
            }
            
        }else{
            if ([type intValue] == 1) {
                [_dataArray removeAllObjects];
            }
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[TopicModel class] json:responseObj[@"data"]]];
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Topic"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TopicCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TopicModel *model = _dataArray[indexPath.section];
    cell.indexPath = indexPath;
    cell.model = model;
    cell.topicBlock = ^(UIImage *topicImage) {
        [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:0 imagesBlock:^NSArray *{
            NSArray *array = [NSArray arrayWithObject:topicImage];
            return array;
        }];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
    TopicModel *model = _dataArray[indexPath.section];
    tvc.tid = [NSString stringWithFormat:@"%@",model.tid];
    tvc.index = [self.content integerValue];
    [self.navigationController pushViewController:tvc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_dataArray.count != 0 && _dataArray.count == section + 1) {
        return 2;
    }
    return 0.1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
