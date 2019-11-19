//
//  LDhistorynameViewController.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/15.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDhistorynameViewController.h"
#import "LDhistorynameModel.h"
#import "LDhistoryViewModel.h"
#import "LDHistorynameCell.h"

@interface LDhistorynameViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) LDhistoryViewModel *viewModel;
@property (copy, nonatomic) NSArray<LDhistoryViewModel *> *publicModelArray;
@end

@implementation LDhistorynameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"历史昵称";
    [self createData];
    [self.view addSubview:self.table];
}

-(void)createData
{
    LDhistorynameModel *model = [[LDhistorynameModel alloc] init];
    self.viewModel = [[LDhistoryViewModel alloc] initWithGoods:model];
    self.viewModel.uid = self.uid;
    [self.viewModel getNewsList];
    __weak typeof(self) weakSelf = self;
    self.viewModel.newsListBlock = ^(NSArray * _Nonnull array) {
        weakSelf.publicModelArray = array.mutableCopy;
        [weakSelf.table reloadData];
    };
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _table.dataSource = self;
        _table.delegate = self;
        _table.tableFooterView = [UIView new];
        _table.emptyDataSetSource = self;
        _table.emptyDataSetDelegate = self;
    }
    return _table;
}

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.publicModelArray.count?:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LDHistorynameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyname"];
    cell = [[LDHistorynameCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"historyname"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = TextCOLOR;
//    cell.detailTextLabel.text = [[TimeManager defaultTool] getDateFormatStrFromTimeStampWithMin:model.addtime];
    [cell bindViewModel:self.publicModelArray[indexPath.row]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无历史昵称记录";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


@end
