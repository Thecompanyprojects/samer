//
//  LDSetBankCardViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/8.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDSetBankCardViewController.h"
#import "LDAddBankCardViewController.h"
#import "BankCell.h"

@interface LDSetBankCardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation LDSetBankCardViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self createData];
}

-(void)createData{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getbankcard"];

    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        NSLog(@"%@",responseObj);
        if (integer != 2000) {
            
        }else{
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:responseObj[@"data"]];
            [self.tableView reloadData];
        }
    } failed:^(NSString *errorMsg) {
        
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"银行卡设置";
    
    _dataArray = [NSMutableArray array];
    
    [self createTableView];
    
    [self createButton];
}

-(void)createTableView{

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
    
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

    BankCell *cell = [[NSBundle mainBundle] loadNibNamed:@"BankCell" owner:self options:nil].lastObject;
    
    cell.nameLabel.text = _dataArray[indexPath.section][@"realname"];
    
    cell.bankLabel.text = _dataArray[indexPath.section][@"bankname"];
    
    cell.bankCardLabel.text = _dataArray[indexPath.section][@"bankcard"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 92;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否选择此银行卡"    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@:%@",_dataArray[indexPath.section][@"bankname"],_dataArray[indexPath.section][@"bankcard"]],@"bank",[NSString stringWithFormat:@"%@",_dataArray[indexPath.section][@"bid"]],@"bid", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bank" object:nil userInfo:dict];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    
    [action setValue:MainColor forKey:@"_titleTextColor"];
    
    [cancelAction setValue:MainColor forKey:@"_titleTextColor"];
    
    [alert addAction:action];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self createDeleteData:indexPath];
    }];
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        LDAddBankCardViewController *cvc = [[LDAddBankCardViewController alloc] init];
        
        cvc.dict = _dataArray[indexPath.section];
        
        [self.navigationController pushViewController:cvc animated:YES];
    }];
    
    editAction.backgroundColor = [UIColor grayColor];
    
    return @[deleteAction, editAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    editingStyle = UITableViewCellEditingStyleDelete;
}

-(void)createDeleteData:(NSIndexPath *)indexPath{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/deletebankcard"];
    
    NSDictionary *parameters = @{@"bid":_dataArray[indexPath.section][@"bid"]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
            
        }else{
            
            [_dataArray removeObjectAtIndex:indexPath.section];
            
            if (_dataArray.count == 0) {
                
                [self.tableView removeFromSuperview];
                
            }else{
                
                [self.tableView reloadData];
            }
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}


-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton setTitle:@"添加" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

-(void)backButtonOnClick:(UIButton *)button{
    
    LDAddBankCardViewController *cvc = [[LDAddBankCardViewController alloc] init];
    
    [self.navigationController pushViewController:cvc animated:YES];
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
