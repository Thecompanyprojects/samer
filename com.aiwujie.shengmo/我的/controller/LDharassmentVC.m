//
//  LDharassmentVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/6.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDharassmentVC.h"
#import "LDharassmentCell.h"

@interface LDharassmentVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
//@property (nonatomic,assign) BOOL isChoose;
@end

static NSString *LDharassmentIdentfity = @"LDharassmentIdentfity";

@implementation LDharassmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"消息设置";
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _table.dataSource = self;
        _table.delegate = self;
    }
    return _table;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LDharassmentCell *cell = [tableView dequeueReusableCellWithIdentifier:LDharassmentIdentfity];
    if (!cell) {
        cell = [[LDharassmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LDharassmentIdentfity];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        if (self.isAll) {
            cell.leftImg.image = [UIImage imageNamed:@"shiguanzhu"];
        }
        else
        {
             cell.leftImg.image = [UIImage imageNamed:@"kongguanzhu"];
        }
        
        cell.nameLab.text = @"所有人可给我发消息";
    }
    if (indexPath.row==1) {
        if (!self.isAll) {
            cell.leftImg.image = [UIImage imageNamed:@"shiguanzhu"];
        }
        else
        {
            cell.leftImg.image = [UIImage imageNamed:@"kongguanzhu"];
        }
        cell.nameLab.text = @"好友/邮票/SVIP可给我发消息";
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
  
        self.isAll = YES;
    }
    else
    {

        self.isAll = NO;
    }
    [self.table reloadData];
}

-(void)backButtonOnClick
{
    if (self.returnValueBlock) {
        [self choosesvipsendMessage];
        //将自己的值传出去，完成传值
        self.returnValueBlock(self.isAll);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
        if (self.returnValueBlock) {
            //将自己的值传出去，完成传值
            self.returnValueBlock(self.isAll);
        }
    }
}

/**
 修改SVIP消息设置情况
 */
-(void)choosesvipsendMessage
{
    NSString *url = [PICHEADURL stringByAppendingString:setVipSecretSitUrl];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *char_rule = [NSString new];
    if (self.isAll) {
        char_rule = @"0";
    }
    else
    {
        char_rule = @"1";
    }
    NSDictionary *parms = @{@"uid":uid?:@"",@"char_rule":char_rule};
    [NetManager afPostRequest:url parms:parms finished:^(id responseObj) {
 
    } failed:^(NSString *errorMsg) {
        
    }];
}

@end
