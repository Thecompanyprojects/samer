//
//  LDSharefriendVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/29.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDSharefriendVC.h"
#import "TableModel.h"
#import "SelectAtCell.h"
#import "attentionCell.h"
#import "XYsharedymicContent.h"
#import "XYshareuserinfoContent.h"
#import "GroupSqureModel.h"
#import "GroupSqureCell.h"


@interface LDSharefriendVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int page;
@property (nonatomic,copy) NSString *nameStr;
@property (nonatomic,strong) UITextField *search;
@end

@implementation LDSharefriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分享给好友";
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.indexStr intValue]==3) {
        [self.search setHidden:YES];
        self.tableView.frame = CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]);
    }
    else
    {
        [self.search setHidden:NO];
        self.tableView.frame = CGRectMake(0, 44, WIDTH, [self getIsIphoneX:ISIPHONEX]-44);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.nameStr = textField.text;
    [textField resignFirstResponder];
    [self.dataArray removeAllObjects];
    [self.tableView.mj_header beginRefreshing];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.nameStr = textField.text;
    [textField resignFirstResponder];
    [self.dataArray removeAllObjects];
    [self.tableView.mj_header beginRefreshing];
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

//getFollewingListUrl
//getatlisturl
-(void)createData:(NSString *)str{
    NSString *url;
    NSDictionary *parameters;
    if ([self.indexStr intValue]==0) {
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,newgetFollewingListUrl];
        if (self.nameStr.length==0) {
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"0",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        }
        else
        {
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"0",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"name":self.nameStr?:@"",@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        }
        
    }
    if ([self.indexStr intValue]==1) {
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,newgetFollewingListUrl];
        if (self.nameStr.length==0) {
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"1",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        }
        else
        {
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"1",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"name":self.nameStr?:@"",@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        }
    }
    if ([self.indexStr intValue]==2) {
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,newgetFollewingListUrl];
        if (self.nameStr.length==0) {
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"2",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        }
        else
        {
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"2",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"name":self.nameStr?:@"",@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        }
    }
    if ([self.indexStr intValue]==3) {
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getGroupListFilter"];
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"2",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        
        if (integer != 2000&&integer != 2001) {
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
            
            if ([self.indexStr intValue]==2||[self.indexStr intValue]==1||[self.indexStr intValue]==0) {
                NSArray *data = [NSArray yy_modelArrayWithClass:[TableModel class] json:responseObj[@"data"]];
                [self.dataArray addObjectsFromArray:data];
            }
            if ([self.indexStr intValue]==3) {
                NSArray *data = [NSArray yy_modelArrayWithClass:[GroupSqureModel class] json:responseObj[@"data"]];
                [self.dataArray addObjectsFromArray:data];
            }
            
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([self.indexStr intValue]==2||[self.indexStr intValue]==1||[self.indexStr intValue]==0) {
        attentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attention"];
        if (!cell) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"attentionCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataArray.count!=0) {
            if (indexPath.section==self.dataArray.count-1) {
                [cell.lineView setHidden:YES];
            }
            else
            {
                [cell.lineView setHidden:NO];
            }
            TableModel *model = _dataArray[indexPath.row];
            cell.model = model;
            [cell.attentButton setHidden:YES];
        }
        return cell;
    }
    if ([self.indexStr intValue]==3) {
        GroupSqureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupSqure"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"GroupSqureCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataArray.count!=0) {
            cell.model = self.dataArray[indexPath.row];
        }
        return cell;
    }
    return [UITableViewCell new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count==0) {
        return;
    }
    if ([self.indexStr intValue]==0||[self.indexStr intValue]==1) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue]!=1) {
            
            UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"限SVIP可用" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                [self.navigationController pushViewController:mvc animated:YES];
                
            }];
            [control addAction:action0];
            [control addAction:action1];
            [self presentViewController:control animated:YES completion:nil];
            
            return;
        }
        
        atselectModel *model = self.dataArray[indexPath.row];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if ([self.typeStr intValue]==0) {
            
            XYsharedymicContent *content = [[XYsharedymicContent alloc] init];
            content.content = self.content?:@"";
            content.icon = self.pic?:@"";
            content.Newid = self.did?:@"";
            content.userId = self.userid?:@"";
            [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:model.uid content:content pushContent:nil pushData:nil success:^(long messageId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD showMessage:@"分享成功"];
                    [MBProgressHUD hideHUD];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } error:^(RCErrorCode nErrorCode, long messageId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showMessage:@"分享失败"];
                     [MBProgressHUD hideHUD];
                });
            }];
        }
        else
        {
            
            XYshareuserinfoContent *content = [[XYshareuserinfoContent alloc] init];
            content.content = self.content?:@"";
            content.icon = self.pic?:@"";
            content.Newid = self.did?:@"";
            [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:model.uid content:content pushContent:nil pushData:nil success:^(long messageId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD showMessage:@"分享成功"];
                    [MBProgressHUD hideHUD];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } error:^(RCErrorCode nErrorCode, long messageId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showMessage:@"分享失败"];
                    [MBProgressHUD hideHUD];
                });
            }];
        }
    }
    
    if ([self.indexStr intValue]==2) {
        atselectModel *model = self.dataArray[indexPath.row];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if ([self.typeStr intValue]==0) {
            XYsharedymicContent *content = [[XYsharedymicContent alloc] init];
            content.content = self.content?:@"";
            content.icon = self.pic?:@"";
            content.Newid = self.did?:@"";
            content.userId = self.userid?:@"";
            [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:model.uid content:content pushContent:nil pushData:nil success:^(long messageId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD showMessage:@"分享成功"];
                    [MBProgressHUD hideHUD];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } error:^(RCErrorCode nErrorCode, long messageId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showMessage:@"分享失败"];
                    [MBProgressHUD hideHUD];
                });
            }];
        }
        else
        {
            XYshareuserinfoContent *content = [[XYshareuserinfoContent alloc] init];
            content.content = self.content?:@"";
            content.icon = self.pic?:@"";
            content.Newid = self.did?:@"";
            [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:model.uid content:content pushContent:nil pushData:nil success:^(long messageId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD showMessage:@"分享成功"];
                    [MBProgressHUD hideHUD];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } error:^(RCErrorCode nErrorCode, long messageId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showMessage:@"分享失败"];
                    [MBProgressHUD hideHUD];
                });
            }];
        }
    }
    if ([self.indexStr intValue]==3) {
        GroupSqureModel *model = self.dataArray[indexPath.row];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if ([self.typeStr intValue]==0) {
            XYsharedymicContent *content = [[XYsharedymicContent alloc] init];
            content.content = self.content?:@"";
            content.icon = self.pic?:@"";
            content.Newid = self.did?:@"";
            content.userId = self.userid?:@"";
            [[RCIM sharedRCIM] sendMessage:ConversationType_GROUP targetId:model.gid content:content pushContent:nil pushData:nil success:^(long messageId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD showMessage:@"分享成功"];
                    [MBProgressHUD hideHUD];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } error:^(RCErrorCode nErrorCode, long messageId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showMessage:@"分享失败"];
                    [MBProgressHUD hideHUD];
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
                    [MBProgressHUD hideHUD];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } error:^(RCErrorCode nErrorCode, long messageId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showMessage:@"分享失败"];
                    [MBProgressHUD hideHUD];
                });
            }];
        }
    }
}

@end
