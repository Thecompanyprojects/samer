//
//  LDAttentionpersonVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/9/2.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDAttentionpersonVC.h"
#import "LDSelectpersonpageVC.h"
#import "TableCell.h"
#import "TableModel.h"

@interface LDAttentionpersonVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *fuidArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL ischange;
@end

static NSString *ldattentpersonidentfity0 = @"ldattentpersonidentfity0";
static NSString *ldattentpersonidentfity1 = @"ldattentpersonidentfity1";
static NSString *ldattentpersonidentfity2 = @"ldattentpersonidentfity2";

@implementation LDAttentionpersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置分组";
    [self.view addSubview:self.tableView];
    self.dataSource = [NSMutableArray array];
    self.fuidArray = [NSMutableArray array];
    
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

-(void)createData:(NSString *)str{
    
    NSString *url = [PICHEADURL stringByAppendingString:getgfuserslistUrl];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *fgid = self.groupModel.Newid;
    NSString *pageStr = [NSString stringWithFormat:@"%ld",(long)self.page];
    NSString *lng = [[NSUserDefaults standardUserDefaults] objectForKey:longitude];
    NSString *lat = [[NSUserDefaults standardUserDefaults] objectForKey:latitude];
    
    NSDictionary *parameters = @{@"uid":uid,@"fgid":fgid,@"page":pageStr,@"lng":lng?:@"0",@"lat":lat?:@"0"};
    
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
            NSArray *data = [NSArray yy_modelArrayWithClass:[TableModel class] json:responseObj[@"data"]];
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

-(void)rightbtns
{
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [right setTitle:@"确定" forState:UIControlStateNormal];
    [right setTitleColor:TextCOLOR forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:15];
    [right addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)rightButtonOnClick
{
    UITextField *nameText = [self.tableView viewWithTag:101];
    NSString *fgname = nameText.text;
    
    if (fgname.length>4) {
        fgname = [fgname substringToIndex:4];
        [MBProgressHUD showMessage:@"限4字以内"];
        return;
    }
    
    NSString *fgid = self.groupModel.Newid;
    if (fgname.length==0) {
//        [MBProgressHUD showMessage:@"请输入分组名称"];
        return;
    }
    if ([fgname isEqualToString:self.groupModel.fgname]) {
        self.ischange = NO;
    }
    else
    {
        self.ischange = YES;
    }
    if (!self.ischange) {
        return;
    }
    
    NSDictionary *params = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fgname":fgname?:@"",@"fgid":fgid?:@""};
    NSString *url = [PICHEADURL stringByAppendingString:updfriendgroupUrl];
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
        NSString *msg = [responseObj objectForKey:@"msg"];
        [MBProgressHUD showMessage:msg];
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
    
            if (self.Complate) {
                self.Complate();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
       
        [self rightButtonOnClick];

    }
}


#pragma mark - getters

-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0||section==1) {
        return 1;
    }
    else
    {
        return self.dataSource.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ldattentpersonidentfity0];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ldattentpersonidentfity0];
            UITextField *text = [[UITextField alloc] init];
            text.frame = CGRectMake(10, 0, WIDTH-20, 50);
            text.placeholder = @"请输入标签名";
            text.font = [UIFont systemFontOfSize:14];
            [cell addSubview:text];
            text.text = self.groupModel.fgname?:@"";
            text.tag = 101;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ldattentpersonidentfity1];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ldattentpersonidentfity1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *iconImg = [[UIImageView alloc] init];
        iconImg.image = [UIImage imageNamed:@"jiajia"];
        iconImg.frame = CGRectMake(15, 15, 24,24);
        [cell addSubview:iconImg];
        UILabel *titleLab = [[UILabel alloc] init];
        [cell addSubview:titleLab];
        titleLab.font = [UIFont systemFontOfSize:14];
        titleLab.textColor = MainColor;
        titleLab.text = @"添加成员";
        titleLab.frame = CGRectMake(45, 15, 100, 25);
        return cell;
    }
    if (indexPath.section==2) {
        TableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Table"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil].lastObject;
        }
        if (self.dataSource!=0) {
            if (indexPath.section==self.dataSource.count-1) {
                [cell.lineView setHidden:YES];
            }
            else
            {
                [cell.lineView setHidden:NO];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            TableModel *model = self.dataSource[indexPath.row];
            cell.model = model;
        }
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0||indexPath.section==1) {
        return 50;
    }
    else
    {
        return 90;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0||section==1) {
        return 30;
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *headView = [[UIView alloc] init];
        headView.frame = CGRectMake(0, 0, WIDTH, 30);
        UILabel *titleLab = [[UILabel alloc] init];
        [headView addSubview:titleLab];
        titleLab.textColor = TextCOLOR;
        titleLab.font = [UIFont systemFontOfSize:13];
        titleLab.text = @"标签名字";
        titleLab.frame = CGRectMake(15, 0, WIDTH-30, 30);
        return headView;
    }
    if (section==1) {
        UIView *headView = [[UIView alloc] init];
        headView.frame = CGRectMake(0, 0, WIDTH, 30);
        UILabel *titleLab = [[UILabel alloc] init];
        [headView addSubview:titleLab];
        titleLab.textColor = TextCOLOR;
        titleLab.font = [UIFont systemFontOfSize:13];
        titleLab.text = @"标签成员";
        titleLab.frame = CGRectMake(15, 0, WIDTH-30, 30);
        return headView;
    }
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        LDSelectpersonpageVC *addVC = [[LDSelectpersonpageVC alloc] init];
        addVC.isfromGroup = YES;
        addVC.uidArray = [NSMutableArray array];
        for (int i = 0; i<self.dataSource.count; i++) {
            TableModel *model = [self.dataSource objectAtIndex:i];
            NSString *uid = model.uid;
            [addVC.uidArray addObject:uid];
        }
        addVC.newblock = ^(NSMutableArray * _Nonnull allUid, NSMutableArray * _Nonnull nameArr, int personNumber) {
            __weak typeof (self) weakSelf = self;
            [weakSelf.fuidArray addObjectsFromArray:allUid];
        
            NSString *fuid = [weakSelf.fuidArray componentsJoinedByString:@","];
            NSString *fgid = self.groupModel.Newid;
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            NSDictionary *params = @{@"fuid":fuid,@"fgid":fgid,@"uid":uid};
            NSString *url = [PICHEADURL stringByAppendingString:setfgusersUrl];
            [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
//                NSString *msg = [responseObj objectForKey:@"msg"];
                if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                    [self.tableView.mj_header beginRefreshing];
                }
//                [MBProgressHUD showMessage:msg];
            } failed:^(NSString *errorMsg) {
                
            }];
            
        };
        [self.navigationController pushViewController:addVC animated:YES];
    }
    if (indexPath.section==2) {
        if (self.dataSource.count==0) {
            return;
        }
        LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
        TableModel *model = self.dataSource[indexPath.section];
        ivc.userID = model.uid;
        [self.navigationController pushViewController:ivc animated:YES];
    }
}



#pragma mark - 左滑删除

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==2) {
        return YES;
    }
    return NO;;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==2) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {

            TableModel *model = self.dataSource[indexPath.row];
            NSString *fuid = model.uid;
            NSString *fgid = self.groupModel.Newid;
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            NSDictionary *params = @{@"uid":uid,@"fgid":fgid,@"fuid":fuid};
            NSString *url = [PICHEADURL stringByAppendingString:delfgusersUrl];
            [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
                if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                    [self.dataSource removeObjectAtIndex:indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView reloadData];
                }
            } failed:^(NSString *errorMsg) {
                
            }];
    
        }
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
    
}

@end
