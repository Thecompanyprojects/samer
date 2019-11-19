//
//  LDSharegroupVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/29.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDSharegroupVC.h"
#import "GroupSqureModel.h"
#import "GroupSqureCell.h"
#import "XYshareuserinfoContent.h"
#import "XYsharedymicContent.h"

@interface LDSharegroupVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int page;

@end

@implementation LDSharegroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.title = @"分享给群组";
    [self createTableView];
    self.dataArray = [NSMutableArray array];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [self createData:@"1"];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self createData:@"2"];
    }];
}

-(void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStylePlain];
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

-(void)createData:(NSString *)str{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getGroupListFilter"];
    
    NSDictionary *parameters;
    parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"2",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        
        if (integer!=2001) {
            if (integer == 4001 || integer == 4002) {
                if ([str intValue] == 1) {
                    [_dataArray removeAllObjects];
                    [self.tableView reloadData];
                    self.tableView.mj_footer.hidden = YES;
                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
        }else{
            
            if ([str intValue] == 1) {
                
                [_dataArray removeAllObjects];
            }
         
            NSArray *data = [NSArray yy_modelArrayWithClass:[GroupSqureModel class] json:responseObj[@"data"]];
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

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count?:0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupSqureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupSqure"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GroupSqureCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 83;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupSqureModel *model = self.dataArray[indexPath.row];

    if ([self.typeStr intValue]==0) {
        XYsharedymicContent *content = [[XYsharedymicContent alloc] init];
        content.content = self.content?:@"";
        content.icon = self.pic?:@"";
        content.Newid = self.did?:@"";
        [[RCIM sharedRCIM] sendMessage:ConversationType_GROUP targetId:model.gid content:content pushContent:nil pushData:nil success:^(long messageId) {
            dispatch_async(dispatch_get_main_queue(), ^{

                [MBProgressHUD showMessage:@"分享成功"];
                [self.navigationController popViewControllerAnimated:YES];
            });
        } error:^(RCErrorCode nErrorCode, long messageId) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showMessage:@"分享失败"];

            });
        }];
        
    }
    else
    {
        XYshareuserinfoContent *content = [[XYshareuserinfoContent alloc] init];
        content.content = self.content?:@"";
        content.icon = self.pic?:@"";
        content.Newid = self.did?:@"";
        [[RCIM sharedRCIM] sendMessage:ConversationType_GROUP targetId:model.gid content:content pushContent:nil pushData:nil success:^(long messageId) {
            dispatch_async(dispatch_get_main_queue(), ^{

                [MBProgressHUD showMessage:@"分享成功"];
                [self.navigationController popViewControllerAnimated:YES];
            });
        } error:^(RCErrorCode nErrorCode, long messageId) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showMessage:@"分享失败"];

            });
        }];
    }
}

@end
