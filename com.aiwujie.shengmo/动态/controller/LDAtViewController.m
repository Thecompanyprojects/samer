//
//  LDAtViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/4.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDAtViewController.h"
#import "AtCell.h"
#import "AtModel.h"
#import "LDOwnInformationViewController.h"
#import "LDDynamicDetailViewController.h"

@interface LDAtViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation LDAtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"@过我的";
    _dataArray = [NSMutableArray array];
    [self createTableView];
    [self createCommentData];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
}

-(void)createCommentData{
    
    for (NSDictionary *dic in [[NSUserDefaults standardUserDefaults] objectForKey:@"atPerson"]) {
        AtModel *model = [[AtModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [_dataArray addObject:model];
        [self.tableView reloadData];
    }
}

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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count?:0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AtCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"At"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AtCell" owner:self options:nil].lastObject;
    }
    if (indexPath.section==self.dataArray.count-1) {
        [cell.lineView setHidden:YES];
    }
    else
    {
        [cell.lineView setHidden:NO];
    }
    if (_dataArray.count > 0) {
        AtModel *model = _dataArray[indexPath.section];
        cell.model = model;
        [cell.headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.lookDynamicButton addTarget:self action:@selector(lookDynamicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(void)lookDynamicButtonClick:(UIButton *)button{
    
    AtCell *cell = (AtCell *)button.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    AtModel *model = _dataArray[indexPath.section];
    
    LDDynamicDetailViewController *dvc = [[LDDynamicDetailViewController alloc] init];
    
    dvc.did = [NSString stringWithFormat:@"%d",model.did];
    
    dvc.ownUid = [NSString stringWithFormat:@"%d",model.uid];
    
    [_dataArray removeObjectAtIndex:indexPath.section];
    
//    NSMutableArray *array = [NSMutableArray array];
//
//    [array addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"atPerson"]];
//
//    [array removeObjectAtIndex:indexPath.section];
//
//    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"atPerson"];
    
    [self.navigationController pushViewController:dvc animated:YES];
}

-(void)headButtonClick:(UIButton *)button{
    
    AtCell *cell = (AtCell *)button.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    AtModel *model = _dataArray[indexPath.section];
    
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    
    ivc.userID = [NSString stringWithFormat:@"%d",model.uid];
    
    [self.navigationController pushViewController:ivc animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 58;
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
