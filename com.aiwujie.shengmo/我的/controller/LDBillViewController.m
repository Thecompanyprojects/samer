//
//  LDBillViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/12.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDBillViewController.h"
#import "BillCell.h"
#import "BillModel.h"
#import "LDDynamicDetailViewController.h"

@interface LDBillViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int page;
@property (nonatomic,strong) NSString *buttonState;

//充值界面的赠送记录和兑换记录
@property (weak, nonatomic) IBOutlet UIView *chargeView;
@property (weak, nonatomic) IBOutlet UIButton *chargeGiveButton;
@property (weak, nonatomic) IBOutlet UIButton *chargeExchangeButton;

//礼物和邮票的兑换记录
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIButton *detailExchangeButton;
@property (weak, nonatomic) IBOutlet UIButton *detailGiveButton;
@property (weak, nonatomic) IBOutlet UIButton *detailDepositButton;

@end

@implementation LDBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _buttonState = @"1";
    _dataArray = [NSMutableArray array];
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
}

-(void)createData:(NSString *)type{
    NSString *url = [NSString string];
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if (self.isfromVip) {
        if ([self.content intValue]==0) {
            //vip 购买记录
            url = [PICHEADURL stringByAppendingString:@"Api/users/vipbuylist"];
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
            
        }
        else
        {
            //vip获赠记录
            
            url = [PICHEADURL stringByAppendingString:@"Api/users/vipgiftlist"];
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
            
        }
    }
    else
    {
        
        if ([_index intValue] == 0) {
            if ([self.content intValue] == 1) {
                
                if ([self.buttonState isEqualToString:@"1"]) {
                    //充值赠送记录
                    url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getGivePsRerond"];
                    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"0"};
                }
                else
                {
                    //充值兑换记录
                    url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getExchangeRecord"];
                    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"1"};
                }
                
            }else if ([self.content intValue] == 0){
                //充值记录
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getWalletRecord"];
                parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};

                
            }
        }else if ([self.index intValue] == 1) {
            if ([self.content intValue] == 0) {
                
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/users/getReceivePresent"];
                parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
            }else if([self.content intValue] == 1){
                
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/users/getBasicGiveRecord"];
                parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
            }else if ([self.content intValue] == 2){
                
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getWalletRecord"];
                parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
            }
        }
        if([_index intValue] == 2){
            if ([self.content intValue] == 0) {
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getStampPaymentRs"];
                parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
            }else if([self.content intValue] == 1){
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getBasicStampGiveRs"];
                parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
            }else if ([self.content intValue] == 2){
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getStampUsedRs"];
                parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
            }
        }
        if([_index intValue] == 3)
        {
            if ([self.content intValue] == 0) {
                url = [PICHEADURL stringByAppendingString:buyTopcardPaymentRs];
                parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
            }
            if ([self.content intValue] == 1) {
                url = [PICHEADURL stringByAppendingString:getTopcardUsedRs];
                parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page],@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            }
            if ([self.content intValue] == 2) {
                url = [PICHEADURL stringByAppendingString:getTopcardUsedRs];
                parameters = @{@"fuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page],@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            }
            
        }

    }

    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            if (integer == 4001 || integer == 3000) {
                if ([type intValue] == 1) {
                    [_dataArray removeAllObjects];
                    [self.tableView reloadData];
                    self.tableView.mj_footer.hidden = YES;
                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                
                [self.tableView.mj_footer endRefreshing];
            }
        }else{
            if ([type intValue] == 1) {
                [_dataArray removeAllObjects];
            }
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[BillModel class] json:responseObj[@"data"]]];
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
    
    if (self.isfromVip) {
    
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 52) style:UITableViewStylePlain];

    }
    else
    {
        if (([_index intValue] == 0 && [self.content intValue] == 1)) {
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 41, WIDTH, [self getIsIphoneX:ISIPHONEX] - 52 - 41) style:UITableViewStylePlain];
        }
        else{
            
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 52) style:UITableViewStylePlain];
        }
    }
    
 
    if ([self.content intValue]==0&&[self.index intValue]!=1) {
        [self.chargeGiveButton setTitle:@"购买" forState:normal];
    }
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
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    BillCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Bill"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"BillCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BillModel *model = _dataArray[indexPath.row];
    if (self.isfromVip) {
        if ([self.content intValue]==0) {
            cell.type = @"会员购买记录";
        }
        else
        {
            cell.type = @"会员获赠记录";
        }
    }
    else
    {
        if ([_index intValue] == 1) {
            if ([self.content intValue] == 0) {
                cell.type = @"收到的礼物";
            }else if ([self.content intValue] == 1){
                cell.type = @"礼物系统赠送";
            }else if ([self.content intValue] == 2){
                cell.type = @"礼物兑换记录";
            }
        }else if ([_index intValue] == 0){
            if ([self.content intValue] == 0) {
                cell.type = @"充值记录";
            }else if ([self.content intValue] == 1){
                if ([_buttonState intValue] == 1) {
                    cell.type = @"充值赠送记录";
                }else if ([_buttonState intValue] == 2){
                    cell.type = @"充值兑换记录";
                }
            }
        }else if ([_index intValue] == 2){
            
            if ([self.content intValue] == 0) {
                cell.type = @"邮票购买记录";
            }else if ([self.content intValue] == 1){
                
                cell.type = @"邮票系统赠送记录";
                
            }else if([self.content intValue] == 2){
                
                cell.type = @"邮票使用记录";
            }
        }
        else if ([_index intValue] == 3){
            
            if ([self.content intValue] == 0) {
                
                cell.type = @"推顶购买记录";
                
            }else if ([self.content intValue] == 1){
                
                cell.type = @"推顶使用记录";
                
            }else if([self.content intValue] == 2){
                
                cell.type = @"他人推顶记录";
            }
        }
    }
   
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_index intValue] == 3) {
        if ([self.content intValue] == 1||[self.content intValue] == 2) {
            BillModel *model = self.dataArray[indexPath.row];
            LDDynamicDetailViewController *vc = [LDDynamicDetailViewController new];
            vc.did = model.did;
            vc.ownUid = model.uid;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 75;
    
}

- (IBAction)giveButtonClick:(UIButton *)sender {
    
    [_chargeGiveButton setTitleColor:MainColor forState:UIControlStateNormal];
    [_chargeExchangeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _buttonState = @"1";
    [self.tableView.mj_header beginRefreshing];
    
    
}

- (IBAction)chargeExchangeButtonClick:(UIButton *)sender {
    
    [_chargeExchangeButton setTitleColor:MainColor forState:UIControlStateNormal];
    [_chargeGiveButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _buttonState = @"2";
    [self.tableView.mj_header beginRefreshing];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
