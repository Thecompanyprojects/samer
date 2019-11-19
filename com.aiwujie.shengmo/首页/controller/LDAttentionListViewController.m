//
//  LDAttentionListViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/1.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDAttentionListViewController.h"
#import "LDOwnInformationViewController.h"
#import "attentionCell.h"
#import "TableModel.h"
#import "TableCell.h"

@interface LDAttentionListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int page;
@property (nonatomic,assign) NSInteger integer;
@property (nonatomic,copy)   NSString *name;
@property (nonatomic,copy)   NSString *queitNum;
@end

@implementation LDAttentionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    [self createTableView];
    
    if ([self.type intValue]<3) {
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 0;
            if ([self.type intValue]==1&&self.isquietly) {
                [self newisquietlyData:@"1"];
            }
            else
            {
                [self createData:@"1"];
            }
        }];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            if ([self.type intValue]==1&&self.isquietly) {
                [self newisquietlyData:@"2"];
            }
            else
            {
                [self createData:@"2"];
            }
        }];
        
    }
    else
    {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 0;
            [self createfgdata:@"1"];
        }];
        [self.tableView.mj_header beginRefreshing];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [self createfgdata:@"2"];
        }];
    }
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.type intValue]==0) {
        [self.tableView.mj_header beginRefreshing];
    }
    
    if (!self.isfromGuanzhu) {
        if ([self.type intValue]==0&&!self.isquietly) {
            self.tableView.frame = CGRectMake(0, -52, WIDTH, [self getIsIphoneX:ISIPHONEX]);
        }
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
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
}

-(void)newisquietlyData:(NSString *)str
{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getFollowListQueitUrl];
    NSDictionary *parameters;
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        _integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (_integer != 2000 && _integer != 2001) {
            if (_integer == 4001 || _integer == 4002) {
                if ([str intValue] == 1) {
                    [self.dataArray removeAllObjects];
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
                [self.dataArray removeAllObjects];
            }
            NSArray *data = [NSArray yy_modelArrayWithClass:[TableModel class] json:responseObj[@"data"]];
            [self.dataArray addObjectsFromArray:data];
            self.queitNum = [NSString stringWithFormat:@"%ld",self.dataArray.count];
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

-(void)createData:(NSString *)str{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,newgetFollewingListUrl];
    NSDictionary *parameters;
    if ([self.type intValue] == 0 || [self.type intValue] == 1) {
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":self.type,@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID,@"name":self.name?:@""};
    }else{
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":self.type,@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID,@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:latitude],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:longitude],@"name":self.name?:@""};
    }
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        _integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (_integer != 2000 && _integer != 2001) {
            if (_integer == 4001 || _integer == 4002) {
                if ([str intValue] == 1) {
                    [self.dataArray removeAllObjects];
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
                [self.dataArray removeAllObjects];
            }
            
            NSArray *data = [NSArray yy_modelArrayWithClass:[TableModel class] json:responseObj[@"data"]];
            [self.dataArray addObjectsFromArray:data];
            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_footer.hidden = NO;
        }
        
        [self.tableView.mj_header endRefreshing];
        
    } failed:^(NSString *errorMsg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(void)createfgdata:(NSString *)str
{
    NSString *url = [PICHEADURL stringByAppendingString:getgfuserslistUrl];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *fgid = self.fgid;
    NSString *pageStr = [NSString stringWithFormat:@"%ld",(long)self.page];
    NSString *lng = [[NSUserDefaults standardUserDefaults] objectForKey:longitude];
    NSString *lat = [[NSUserDefaults standardUserDefaults] objectForKey:latitude];
    
    NSDictionary *parameters = @{@"uid":uid,@"fgid":fgid?:@"0",@"page":pageStr,@"lng":lng?:@"0",@"lat":lat?:@"0"};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (integer != 2000 && integer != 2001) {
            if (integer == 4001 || integer == 4002) {
                if ([str intValue] == 1) {
                    [self.dataArray removeAllObjects];
                    [self.tableView reloadData];
                    self.tableView.mj_footer.hidden = YES;
                    
                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else{
            if ([str intValue] == 1) {
                [self.dataArray removeAllObjects];
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count?:0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.type intValue] == 0 || [self.type intValue] == 1||[self.type intValue]>=3) {
        attentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attention"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"attentionCell" owner:self options:nil].lastObject;
        }
        cell.isfromguanzhu = YES;
        if (self.isquietly) {
            cell.isquite = YES;
        }
        if (self.dataArray.count!=0) {
            if (indexPath.section==self.dataArray.count-1) {
                [cell.lineView setHidden:YES];
            }
            else
            {
                [cell.lineView setHidden:NO];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            TableModel *model = _dataArray[indexPath.section];
            cell.type = self.type;
            cell.model = model;
            if ([self.type intValue]>=3) {
               [cell.attentButton addTarget:self action:@selector(fansButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        if ([self.type intValue] == 0) {
            [cell.attentButton addTarget:self action:@selector(attentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([self.type intValue] == 1&&!self.isquietly){
            [cell.attentButton addTarget:self action:@selector(fansButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (self.isquietly) {
            [cell.attentButton addTarget:self action:@selector(quietlyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
       
        return cell;
    }
    
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Table"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil].lastObject;
    }
    cell.isfromguanzhu = YES;
    if (self.dataArray!=0) {
        if (indexPath.section==self.dataArray.count-1) {
            [cell.lineView setHidden:YES];
        }
        else
        {
            [cell.lineView setHidden:NO];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TableModel *model = _dataArray[indexPath.section];
        cell.type = self.type;
        cell.integer = _integer;
        cell.model = model;
    }
    return cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (!self.isquietly) {
        if ([self.type intValue] == 1 && section == 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
            label.text = @"不显示违规用户";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor lightGrayColor];
            return label;
        }
    }
    if ([self.type intValue]==0) {
        return [[UIView alloc] init];
    }
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

-(void)fansButtonClick:(UIButton *)button{

    attentionCell *cell = (attentionCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TableModel *model = _dataArray[indexPath.section];
    if ([model.state intValue] == 0) {
        NSString *url;
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,setfollowOne];
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":model.uid};
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
            if (integer != 2000) {
          
                if (integer==8881||integer==8882) {
                    NSString *msg = [responseObj objectForKey:@"msg"];
                    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"开会员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                        [self.navigationController pushViewController:mvc animated:YES];
                    }];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                        cvc.where = @"2";
                        [self.navigationController pushViewController:cvc animated:YES];
                    }];
                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [control addAction:action1];
                    [control addAction:action0];
                    [control addAction:action2];
                    [self presentViewController:control animated:YES completion:^{
                        
                    }];
                }else
                {
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                }
                
               
            }else{
                model.state = @"1";
                [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                [self.tableView reloadData];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }else{
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定不再关注此人"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *url;
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,setoverfollow];
            
            NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":model.uid};
            
            [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
                NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
                
                if (integer != 2000) {
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                }else{
                    model.state = @"0";
                    [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                    [self.tableView reloadData];
                }
            } failed:^(NSString *errorMsg) {
                
            }];
            
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
        [alert addAction:action];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];

    }
}

-(void)attentButtonClick:(UIButton *)button{
    
    attentionCell *cell = (attentionCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TableModel *model = _dataArray[indexPath.section];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定不再关注此人"    preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {

        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,setoverfollow];
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":model.uid};
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
            if (integer != 2000) {
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }else{
                [_dataArray removeObject:model];
                [self.tableView reloadData];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
    [alert addAction:action];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)quietlyButtonClick:(UIButton *)button
{
    NSString *url = [PICHEADURL stringByAppendingString:overfollowquietUrl];
    attentionCell *cell = (attentionCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TableModel *model = _dataArray[indexPath.section];
    NSString *fuid = model.uid;
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSDictionary *params = @{@"uid":uid,@"fuid":fuid};
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            
            NSString *msg = [responseObj objectForKey:@"msg"];
            [MBProgressHUD showMessage:msg];
            [self.dataArray removeObjectAtIndex:indexPath.section];
            [self.tableView reloadData];
            if (self.quiteNumblock) {
                self.quiteNumblock(@"1");
            }
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)staticsButtonClick
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 88;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!self.isquietly) {
        if ([self.type intValue] == 1 && section == 0) {
            return 40;
        }
    }
    if ([self.type intValue]==0) {
        return 0.01f;
    }
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count==0) {
        return;
    }
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    TableModel *model = self.dataArray[indexPath.section];
    ivc.userID = model.uid;
    [self.navigationController pushViewController:ivc animated:YES];
}

#pragma mark - empty

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *text;
    NSMutableAttributedString *attStr = [NSMutableAttributedString new];
    if (self.isquietly&&[self.type intValue]==1&&[[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue]!=1) {
        text = @"开通SVIP即可悄悄关注";
        attStr = [[NSMutableAttributedString alloc] initWithString:text];
        [attStr addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:15.0]
                       range:NSMakeRange(0, text.length)];
        [attStr addAttribute:NSForegroundColorAttributeName
                       value:[UIColor lightGrayColor]
                       range:NSMakeRange(0, text.length)];
        [attStr addAttribute:NSForegroundColorAttributeName
                       value:MainColor
                       range:NSMakeRange(0, 6)];
    }
    else
    {
        text = @"";
        attStr = [[NSMutableAttributedString alloc] initWithString:text];
    }
    return attStr;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
    [self.navigationController pushViewController:mvc animated:YES];
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    self.tableView.contentOffset = CGPointZero;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
