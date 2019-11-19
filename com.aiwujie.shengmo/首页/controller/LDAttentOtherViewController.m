//
//  LDAttentOtherViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/5.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDAttentOtherViewController.h"
#import "LDOwnInformationViewController.h"
#import "attentionCell.h"
#import "TableModel.h"
#import "TableCell.h"

@interface LDAttentOtherViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton *nearButton;
@property (nonatomic,strong) UIButton *hotButton;
@property (nonatomic,strong) UIView *nearView;
@property (nonatomic,strong) UIView *hotView;
@property (nonatomic,strong) UIView *navView;
@property (nonatomic,assign) int page;
@property (nonatomic,assign) NSInteger integer;
@end

@implementation LDAttentOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavButtn];
    
    self.dataArray = [NSMutableArray array];

    [self createTableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 0;
        
        [self createData:@"1"];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _page++;
        
        [self createData:@"2"];
        
    }];
    
    if ([self.type intValue] == 0) {
        [_nearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _nearView.hidden = NO;
    }else if ([self.type intValue] == 1){
        [_hotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _hotView.hidden = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navView.hidden = NO;
}

-(void)createNavButtn{
    
    if (ISIPHONEX) {
        
        _navView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, WIDTH - 120, 88)];
        
    }else{
        
        _navView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, WIDTH - 120, 64)];
    }

    _navView.backgroundColor = [UIColor clearColor];
    
    [self.navigationController.view addSubview:_navView];
    
    CGFloat spotH = 2;
    CGFloat spotW = 38;
    
    _nearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, [self getIsIphoneXNAV:ISIPHONEX], _navView.frame.size.width/2, 30)];
    
    [_nearButton setTitle:@"关注" forState:UIControlStateNormal];
    
    [_nearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [_nearButton addTarget:self action:@selector(nearButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _nearButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [_navView addSubview:_nearButton];
    
    _nearView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/4 - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    
    _nearView.backgroundColor = [UIColor blackColor];
    
    _nearView.layer.cornerRadius = spotH/2;
    
    _nearView.hidden = YES;
    
    _nearView.clipsToBounds = YES;
    
    [_navView addSubview:_nearView];
    
    
    _hotButton = [[UIButton alloc] initWithFrame:CGRectMake(_navView.frame.size.width/2, [self getIsIphoneXNAV:ISIPHONEX],_navView.frame.size.width/2, 30)];
    
    [_hotButton setTitle:@"粉丝" forState:UIControlStateNormal];
    
    _hotButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [_hotButton addTarget:self action:@selector(hotButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_hotButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [_navView addSubview:_hotButton];
    
    _hotView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/2 + _navView.frame.size.width/4 - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    
    _hotView.backgroundColor = [UIColor blackColor];
    
    _hotView.layer.cornerRadius = spotH/2;
    
    _hotView.hidden = YES;
    
    _hotView.clipsToBounds = YES;
    
    [_navView addSubview:_hotView];
    
}

-(void)nearButtonClick{
    
    self.type = @"0";
    
    [self.tableView.mj_header beginRefreshing];
    
    [_nearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _nearView.hidden = NO;
    
    [_hotButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _hotView.hidden = YES;
    
}

-(void)hotButtonClick{
    
    self.type = @"1";
    
    [self.tableView.mj_header beginRefreshing];
    
    [_hotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _hotView.hidden = NO;
    
    [_nearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _nearView.hidden = YES;
}

-(void)createData:(NSString *)str{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,newgetFollewingListUrl];
    
    NSDictionary *parameters;
    
    parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":self.type,@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        
        if (integer != 2000) {
            
            if (integer == 4001 || integer == 4002) {
                
                if ([str intValue] == 1) {
                    
                    [self.dataArray removeAllObjects];
                    
                    [self.tableView reloadData];
                    
                    self.tableView.mj_footer.hidden = YES;
                    
                }else{
                    
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                if (integer == 4002) {
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count?:0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    attentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attention"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"attentionCell" owner:self options:nil].lastObject;
    }
    if (indexPath.section==self.dataArray.count-1) {
        [cell.lineView setHidden:YES];
    }
    else
    {
        [cell.lineView setHidden:NO];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TableModel *model = self.dataArray[indexPath.section];
    cell.otherType = self.type;
    cell.model = model;
    if ([self.type intValue] == 0) {
        [cell.attentButton addTarget:self action:@selector(attentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([self.type intValue] == 1){
        [cell.attentButton addTarget:self action:@selector(fansButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(void)fansButtonClick:(UIButton *)button{
    
    attentionCell *cell = (attentionCell *)button.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    TableModel *model = self.dataArray[indexPath.section];
    
    if ([model.state intValue] == 0 || [model.state intValue] == 2) {
        
        NSString *url;
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,setfollowOne];
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":model.uid};
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
            if (integer != 2000) {

                if (integer==5000)
                {
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:responseObj[@"msg"]];
                }
                else
                {
                    NSString *msg = [responseObj objectForKey:@"msg"];
                    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"开会员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                        [self.navigationController pushViewController:mvc animated:YES];
                    }];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                        cvc.where = @"7";
                        [self.navigationController pushViewController:cvc animated:YES];
                    }];
                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [control addAction:action1];
                    [control addAction:action0];
                    [control addAction:action2];
                    [self presentViewController:control animated:YES completion:^{
                        
                    }];
                }
            
            }else{
                if ([model.state intValue] == 0) {
                    model.state = @"1";
                    [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                    [self.tableView reloadData];
                }else if ([model.state intValue] == 2){
                    model.state = @"3";
                    [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                    [self.tableView reloadData];
                }
            }
        } failed:^(NSString *errorMsg) {
            
        }];
        
    }else if ([model.state intValue] == 1 || [model.state intValue] == 3){
        
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
                    
                    if ([model.state intValue] == 1) {
                        model.state = @"0";
                        [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                        [self.tableView reloadData];
                    }else if ([model.state intValue] == 3){
                        model.state = @"2";
                        [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                        [self.tableView reloadData];
                    }
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
    if ([model.state intValue] == 0 || [model.state intValue] == 2) {
        NSString *url;
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,setfollowOne];
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":model.uid};
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
            if (integer != 2000) {
                
                if (integer==5000)
                {
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:responseObj[@"msg"]];
                }
                else
                {
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
                }
            }else{
                if ([model.state intValue] == 0) {
                    model.state = @"1";
                    [self.dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                    [self.tableView reloadData];
                }else if ([model.state intValue] == 2){
                    model.state = @"3";
                    [self.dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                    [self.tableView reloadData];
                }
            }
        } failed:^(NSString *errorMsg) {
            
        }];

    }else if([model.state intValue] == 1 || [model.state intValue] == 3){
    
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
                    if ([model.state intValue] == 1) {
                        model.state = @"0";
                        [self.dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                        [self.tableView reloadData];
                    }else if ([model.state intValue] == 3){
                        model.state = @"2";
                        [self.dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                        [self.tableView reloadData];
                    }
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 && [self.type intValue] == 1) {
        return 40;
    }
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0 && [self.type intValue] == 1) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        label.text = @"不显示违规用户";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor lightGrayColor];
        
        return label;
    }
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    TableModel *model = self.dataArray[indexPath.section];
    ivc.userID = model.uid;
    [self.navigationController pushViewController:ivc animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    _navView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
