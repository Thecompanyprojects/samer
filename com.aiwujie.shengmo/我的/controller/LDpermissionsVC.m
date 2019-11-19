//
//  LDpermissionsVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/10.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDpermissionsVC.h"
#import "LDpermissionsVCCell.h"

@interface LDpermissionsVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@end

static NSString *ldpermissidendfity = @"ldpermissidendfity";

@implementation LDpermissionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    switch (_InActionType) {
        case ENUM_PERMISSIONPHOTO_ActionType:
            self.title = @"相册查看";
            break;
        case ENUM_PERMISSIONDYNAMIC_ActionType:
            self.title = @"主页动态查看";
            break;
        case ENUM_PERMISSIONCOMMENTS_ActionType:
            self.title = @"主页评论查看";
            break;
        case ENUM_PERMISSIONCOMMENTS_HistorynameType:
            self.title = @"历史昵称查看权限";
            break;
        default:
            break;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.table];
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
        NSLog(@"页面pop成功了");
        
        if (self.returnValueBlock) {
            //将自己的值传出去，完成传值
            self.returnValueBlock(self.isChoose);
            
        }
    }
}

-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _table.dataSource = self;
        _table.delegate = self;
        _table.tableFooterView = [UIView new];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _table;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LDpermissionsVCCell *cell = [tableView dequeueReusableCellWithIdentifier:ldpermissidendfity];
    if (!cell) {
        cell= [[LDpermissionsVCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ldpermissidendfity];
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        if (!self.isChoose) {
            cell.leftImg.image = [UIImage imageNamed:@"shiguanzhu"];
        }
        else
        {
            cell.leftImg.image = [UIImage imageNamed:@"kongguanzhu"];
        }
        if (self.InActionType==ENUM_PERMISSIONCOMMENTS_HistorynameType) {
            cell.nameLab.text = @"SVIP可见";
        }
        else
        {
            cell.nameLab.text = @"所有人可见";
        }
        
    }
    if (indexPath.row==1) {
        if (self.isChoose) {
            cell.leftImg.image = [UIImage imageNamed:@"shiguanzhu"];
        }
        else
        {
            cell.leftImg.image = [UIImage imageNamed:@"kongguanzhu"];
        }
        if (self.InActionType==ENUM_PERMISSIONCOMMENTS_HistorynameType) {
            cell.nameLab.text = @"仅自己可见";
        }
        else
        {
             cell.nameLab.text = @"好友/会员可见";
        }
        [cell.lineView setHidden:YES];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.InActionType==ENUM_PERMISSIONCOMMENTS_HistorynameType) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue]!=1) {
            
            UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"SVIP可设置历史昵称查看权限" preferredStyle:UIAlertControllerStyleAlert];
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
        else
        {
            if (indexPath.row==0) {
                self.isChoose = NO;
            }
            else
            {
                self.isChoose = YES;
            }
            [self.table reloadData];
        }
    }
    else
    {
        if (indexPath.row==0) {
            self.isChoose = NO;
        }
        else
        {
            self.isChoose = YES;
        }
        [self.table reloadData];
    }
  
}

-(void)backButtonOnClick
{
    if (self.returnValueBlock) {
        //将自己的值传出去，完成传值
        self.returnValueBlock(self.isChoose);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
