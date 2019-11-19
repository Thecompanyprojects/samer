//
//  LDMoreTopicPageViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/7/18.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDMoreTopicPageViewController.h"
#import "HeaderTabViewController.h"
#import "TopicCell.h"
#import "TopicModel.h"

@interface LDMoreTopicPageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

//保存tableview的偏移量
@property (nonatomic,assign) CGFloat lastScrollOffset;

//分页page
@property (nonatomic,assign) int tablePage;

@end

@implementation LDMoreTopicPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
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

    
    if ([self.type isEqualToString:@"MyTopic"]) {
        
        //起始偏移量为0
        self.lastScrollOffset = 0;
    }
}

-(void)createDatatype:(NSString *)type{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getTopicListUrl];
    NSDictionary *parameters = [NSDictionary dictionary];
    if ([self.type isEqualToString:@"MyTopic"]) {
        
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_tablePage],@"type":[NSString stringWithFormat:@"%d",[self.content intValue] + 2],@"uid":self.userId};
        
    }else if([self.type isEqualToString:@"MoreTopic"]){
    
        if ([self.content intValue] == 0) {
            
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_tablePage],@"type":@"1",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
        }else{
        
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_tablePage],@"type":@"0",@"pid":self.content,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        }
        
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if ([self.type isEqualToString:@"MyTopic"]) {
    
        // 获取开始拖拽时tableview偏移量
        self.lastScrollOffset = self.tableView.contentOffset.y + 40;
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([self.type isEqualToString:@"MyTopic"]) {
    
        if (scrollView == self.tableView) {
            
            if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y + HEIGHT < self.tableView.contentSize.height + 104) {
                
                CGFloat y = scrollView.contentOffset.y + 40;
                
                if (y >= self.lastScrollOffset) {
                    //用户往上拖动，也就是屏幕内容向下滚动
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"创建话题按钮隐藏" object:nil];
                    
                } else if(y < self.lastScrollOffset){
                    //用户往下拖动，也就是屏幕内容向上滚动
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"创建话题按钮显示" object:nil];
                }
                
            }else{
                
                if (self.lastScrollOffset == 0) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"创建话题按钮显示" object:nil];
                    
                }
            }
        }

    }
    
}

-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 40) style:UITableViewStyleGrouped];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
