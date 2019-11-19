//
//  LDGiftgrouplistVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/11.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDGiftgrouplistVC.h"
#import "giftgroupModel.h"
#import "giftgroupCell.h"
#import "LDOwnInformationViewController.h"

@interface LDGiftgrouplistVC()<UITableViewDataSource,UITableViewDelegate,giftDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIImageView *giftImg;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UILabel *messaegLab;
@property (nonatomic,copy) NSString *num;
@end

static NSString *giftidentfity = @"giftidentfity";

@implementation LDGiftgrouplistVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"领取列表";
    [self createTableView];
    [self createData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataSource removeAllObjects];
        [self createData];
    }];
}

-(void)createData
{
    self.dataSource = [NSMutableArray array];
    self.giftImg.image = [UIImage imageNamed:self.imageName];
    NSString *url = [PICHEADURL stringByAppendingString:@"Api/friend/getQunGiftList"];
    NSDictionary *params = @{@"orderid":self.orderid?:@""};
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSArray *data = [NSArray yy_modelArrayWithClass:[giftgroupModel class] json:responseObj[@"data"][@"datas"]];
            [self.dataSource addObjectsFromArray:data];
            self.num = responseObj[@"data"][@"num"];
            self.messaegLab.text = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"共",self.number,@"个礼物",@",剩余",self.num?:@"0",@"个礼物"];
        }
        //self.messaegLab.text = [NSString stringWithFormat:@"%@%@%@",@"剩余",self.num?:@"0",@"个礼物"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
    } failed:^(NSString *errorMsg) {
        [self.tableView.mj_header endRefreshing];
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
    self.tableView.tableHeaderView = self.headView;
}

-(UIView *)headView
{
    if(!_headView)
    {
        _headView = [[UIView alloc] init];
        _headView.frame = CGRectMake(0, 0, WIDTH, 180);
        [_headView addSubview:self.giftImg];
        [_headView addSubview:self.messaegLab];
    }
    return _headView;
}

-(UIImageView *)giftImg
{
    if(!_giftImg)
    {
        _giftImg = [[UIImageView alloc] init];
        _giftImg.frame = CGRectMake(WIDTH/2-50, 30, 100, 100);
    }
    return _giftImg;
}

-(UILabel *)messaegLab
{
    if(!_messaegLab)
    {
        _messaegLab = [[UILabel alloc] init];
        _messaegLab.frame = CGRectMake(15, 160, WIDTH-30, 18);
        _messaegLab.font = [UIFont systemFontOfSize:16];
        _messaegLab.textColor = TextCOLOR;
        _messaegLab.textAlignment = NSTextAlignmentCenter;
    }
    return _messaegLab;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    giftgroupCell *cell = [tableView dequeueReusableCellWithIdentifier:giftidentfity];
    cell = [[giftgroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:giftidentfity];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(void)iconTabVClick:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    giftgroupModel *model = self.dataSource[index.row];
    NSString *uid = model.fuid;
    LDOwnInformationViewController *VC = [[LDOwnInformationViewController alloc] init];
    VC.userID = uid;
    [self.navigationController pushViewController:VC animated:YES];
}

@end
