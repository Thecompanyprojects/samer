//
//  LDApplyAddGroupViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/18.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDApplyAddGroupViewController.h"
#import "ApplyGroupCell.h"
#import "ApplyGroupModel.h"
#import "FollowMessageModel.h"
#import "FollowMessageCell.h"
#import "LDOwnInformationViewController.h"

@interface LDApplyAddGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int page;

@end

@implementation LDApplyAddGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.chatSystemType == chatSystemTypeApply) {
        
        self.navigationItem.title = @"群消息";
        
    }else if (self.chatSystemType == chatSystemTypeFollowMessage){
    
        self.navigationItem.title = @"关注提醒";
    }
    
    self.dataArray = [NSMutableArray array];
    
    [self createTableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 0;
        
        [self createData:@"0"];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _page++;
        
        [self createData:@"1"];
        
    }];
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"其他"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

}

-(void)backButtonOnClick{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *titleString;
    
    if (self.chatSystemType == chatSystemTypeApply) {
        
        titleString = @"清空群消息";
        
    }else if (self.chatSystemType == chatSystemTypeFollowMessage){
    
        titleString = @"清空消息提醒";
    }
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:titleString style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
     
        NSString *url = [NSString string];
        
        if (self.chatSystemType == chatSystemTypeApply) {
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/delGroupMsg"];
            
        }else if (self.chatSystemType == chatSystemTypeFollowMessage){
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/delFollowMessage"];
        }
        
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
            
            if (integer != 2000) {

                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];

            }else{
                
                [self.dataArray removeAllObjects];
                
                [self.tableView reloadData];
            }

        } failed:^(NSString *errorMsg) {
            
        }];

    }];
    
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
    
        [action setValue:MainColor forKey:@"_titleTextColor"];
        [cancel setValue:MainColor forKey:@"_titleTextColor"];
    }
    
    [alert addAction:cancel];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)createData:(NSString *)type{

    NSString *url = [NSString string];
    
    if (self.chatSystemType == chatSystemTypeApply) {
        
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getGroupMsgUrl];
        
    }else if (self.chatSystemType == chatSystemTypeFollowMessage){
        
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getFollowMessage"];
    }
    
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};

    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        
        if (integer != 2000) {
            if (integer == 4001 || integer == 3000) {
                if ([type intValue] == 0) {
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
            if ([type intValue] == 0) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dic in responseObj[@"data"]) {
                
                if (self.chatSystemType == chatSystemTypeApply) {
                    ApplyGroupModel *model = [[ApplyGroupModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }else if (self.chatSystemType == chatSystemTypeFollowMessage){
                    FollowMessageModel *model = [[FollowMessageModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
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

    return _dataArray.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.chatSystemType == chatSystemTypeApply) {
        
        ApplyGroupCell *cell = [ApplyGroupCell cellWithApplyCell:tableView];
        ApplyGroupModel *model = _dataArray[indexPath.section];
        cell.model = model;
        [cell.agreeButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.refuseButton addTarget:self action:@selector(refuseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    FollowMessageCell *cell = [FollowMessageCell cellWithFollowMessageCell:tableView];
    FollowMessageModel *model = _dataArray[indexPath.section];
    cell.model = model;
    return cell;
}

-(void)agreeButtonClick:(UIButton *)button{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ApplyGroupCell *cell = (ApplyGroupCell *)button.superview.superview;
    cell.agreeButton.userInteractionEnabled = NO;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/agreeOneInto"];
    ApplyGroupModel *model = _dataArray[indexPath.section];
    NSDictionary *parameters = @{@"ugid":model.ugid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"mid":model.mid};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (integer != 2000) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            model.state = @"2";
            cell.agreeButton.userInteractionEnabled = YES;
            cell.agreeButton.hidden = YES;
            cell.refuseButton.hidden = YES;
            cell.completeButton.hidden = NO;
            NSDictionary *data = [responseObj objectForKey:@"data"];
            NSString *nickname = [data objectForKey:@"nickname"];
            cell.chooseLab.text = nickname?:@"";
            [self.tableView reloadData];
        }
        
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

-(void)refuseButtonClick:(UIButton *)button{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ApplyGroupCell *cell = (ApplyGroupCell *)button.superview.superview;
    cell.refuseButton.userInteractionEnabled = NO;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/refuseOneInto"];
    ApplyGroupModel *model = _dataArray[indexPath.section];
    NSDictionary *parameters = @{@"ugid":model.ugid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"mid":model.mid};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (integer != 2000) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            model.state = @"2";
            cell.refuseButton.userInteractionEnabled = YES;
            cell.agreeButton.hidden = YES;
            cell.refuseButton.hidden = YES;
            cell.completeButton.hidden = NO;
            NSDictionary *data = [responseObj objectForKey:@"data"];
            NSString *nickname = [data objectForKey:@"nickname"];
            cell.chooseLab.text = nickname?:@"";
            [self.tableView reloadData];
        }
        
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.chatSystemType == chatSystemTypeApply) {
        ApplyGroupModel *model = _dataArray[indexPath.section];
        if ([model.other_uid intValue] != 0) {
            LDOwnInformationViewController *fvc = [[LDOwnInformationViewController alloc] init];
            fvc.userID = model.other_uid;
            [self.navigationController pushViewController:fvc animated:YES];
        }
    }else if (self.chatSystemType == chatSystemTypeFollowMessage){
        FollowMessageModel *model = _dataArray[indexPath.section];
        LDOwnInformationViewController *fvc = [[LDOwnInformationViewController alloc] init];
        fvc.userID = model.uid;
        [self.navigationController pushViewController:fvc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 81;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 1;
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
