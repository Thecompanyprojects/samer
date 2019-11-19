//
//  LDAttentionsearchVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/8.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDAttentionsearchVC.h"
#import "LDAttentionsearchCell.h"
#import "LDAttentionsearchModel.h"

@interface LDAttentionsearchVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITextField *search;
@property (nonatomic,assign) NSInteger page;
@end

static NSString *searchidentfity = @"LDAttentionsearchVC";

@implementation LDAttentionsearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索用户";
    self.dataSource = [NSMutableArray array];
    [self createSearch];
    [self createTableView];
    self.search.text = self.name?:@"";
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        [self createData:@"1"];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self createData:@"2"];
    }];
}

-(void)createSearch
{
    self.search = [[UITextField alloc] initWithFrame:CGRectMake(6, 6, WIDTH-12, 32)];
    self.search.layer.masksToBounds = YES;
    self.search.layer.cornerRadius = 12;
    [self.view addSubview:self.search];
    self.search.backgroundColor = [UIColor colorWithHexString:@"EDEEF0" alpha:1];
    self.search.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *leftPhoneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (self.search.frame.size.height - 20)*0.5, 30, 13)];
    leftPhoneImgView.image = [UIImage imageNamed:@"搜索用户"];
    leftPhoneImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.search.leftView = leftPhoneImgView;
    self.search.placeholder = @"搜索";
    self.search.returnKeyType = UIReturnKeySearch;
    self.search.delegate = self;
    self.search.clearButtonMode=UITextFieldViewModeWhileEditing;
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, WIDTH, [self getIsIphoneX:ISIPHONEX]-44) style:UITableViewStylePlain];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.name = textField.text;
    [self.dataSource removeAllObjects];
    [self.tableView.mj_header beginRefreshing];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.name = textField.text;
    [textField resignFirstResponder];
    [self.dataSource removeAllObjects];
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - getData

-(void)createData:(NSString *)str
{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,newgetFollewingListUrl];
    NSDictionary *parameters;
    
    parameters = @{@"page":[NSString stringWithFormat:@"%ld",(long)_page],@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"name":self.name?:@"",@"type":self.type?:@""};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (integer != 2000 && integer != 2001) {
            if (integer == 4001 || integer == 4002) {
                if ([str intValue] == 1) {
                    [self.dataSource removeAllObjects];
                    [self.tableView reloadData];
                    self.tableView.mj_footer.hidden = YES;
                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                [self.tableView.mj_footer endRefreshing];
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }
        }else{
            if ([str intValue] == 1) {
                [self.dataSource removeAllObjects];
            }
            NSArray *data = [NSArray yy_modelArrayWithClass:[LDAttentionsearchModel class] json:responseObj[@"data"]];
            [self.dataSource addObjectsFromArray:data];
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

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count?:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LDAttentionsearchCell *cell = [tableView dequeueReusableCellWithIdentifier:searchidentfity];
    cell = [[LDAttentionsearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchidentfity];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.searchStr = self.name.copy;
    if (self.dataSource.count!=0) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count==0) {
        return;
    }
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    LDAttentionsearchModel *model = self.dataSource[indexPath.row];
    ivc.userID = model.uid;
    [self.navigationController pushViewController:ivc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

@end
