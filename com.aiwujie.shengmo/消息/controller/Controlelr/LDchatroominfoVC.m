//
//  LDchatroominfoVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/3.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDchatroominfoVC.h"
#import "ldchatroominfoCell0.h"
#import "ldchatroominfoCell1.h"
#import "LDAlertHeadAndNameViewController.h"
#import "LDAlertNameViewController.h"
#import "ldchatroominfoCell2.h"

@interface LDchatroominfoVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,copy) NSString *mictype;
@end

static NSString *chatroomidentfity0 = @"chatroomidentfity0";
static NSString *chatroomidentfity1 = @"chatroomidentfity1";
static NSString *chatroomidentfity2 = @"chatroomidentfity2";
static NSString *chatroomidentfity3 = @"chatroomidentfity3";

@implementation LDchatroominfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"聊吧信息";
    self.mictype = [self.infoDic objectForKey:@"mictype"];
    [self.view addSubview:self.table];
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

#pragma mark - getters

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        ldchatroominfoCell0 *cell = [tableView dequeueReusableCellWithIdentifier:chatroomidentfity0];
        cell = [[ldchatroominfoCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatroomidentfity0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:[self.infoDic objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"zm-聊天室"]];
        cell.nameLab.text = [self.infoDic objectForKey:@"name"]?:@"";
        if ([self.rule intValue]!=1) {
            [cell.rightImg setHidden:YES];
        }
        else
        {
            [cell.rightImg setHidden:NO];
        }
        return cell;
    }
    if (indexPath.row==1) {
        ldchatroominfoCell1 *cell = [tableView dequeueReusableCellWithIdentifier:chatroomidentfity1];
        if (!cell) {
            cell = [[ldchatroominfoCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatroomidentfity0];
        }
        cell.messageLab.text = [self.infoDic objectForKey:@"count"]?:@"";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.rule intValue]!=1) {
            [cell.rightImg setHidden:YES];
        }
        else
        {
            [cell.rightImg setHidden:NO];
        }
        return cell;
    }
    if (indexPath.row==2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chatroomidentfity2];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatroomidentfity2];
            UILabel *messageLab = [[UILabel alloc] init];
            [cell addSubview:messageLab];
            messageLab.textAlignment = NSTextAlignmentRight;
            messageLab.font = [UIFont systemFontOfSize:13];
            messageLab.textColor = [UIColor lightGrayColor];
            messageLab.frame = CGRectMake(WIDTH/2, 0, WIDTH/2-34, 50);
            messageLab.tag = 101;
            messageLab.text = [self.infoDic objectForKey:@"micnum"]?:@"0";
        }
        if ([self.rule intValue]==1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = @"开放麦数";
        cell.textLabel.textColor = TextCOLOR;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    if (indexPath.row==3) {
        ldchatroominfoCell2 *cell = [tableView dequeueReusableCellWithIdentifier:chatroomidentfity3];
        if (!cell) {
            cell = [[ldchatroominfoCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatroomidentfity3];
        }
        cell.mictype = self.mictype.copy;
        [cell setdata];
        [cell.leftBtn addTarget:self action:@selector(leftbtnclick) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightBtn addTarget:self action:@selector(rightbtnclick) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 80;
    }
    if (indexPath.row==1) {
        CGFloat hei = [self calculateRowHeight:[self.infoDic objectForKey:@"count"] fontSize:10];
        return hei+75;
    }
    if (indexPath.row==2) {
        return 50;
    }
    if (indexPath.row==3) {
        return 40;
    }
    return 0.01f;
}

- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(self.view.width - 30, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.rule intValue]==0) {
        return;
    }
    if (indexPath.row==0) {
        [self chooseinfoClick];
    }
    if (indexPath.row==1) {
        LDAlertNameViewController *VC  = [[LDAlertNameViewController alloc] init];
        VC.groupName = [self.infoDic objectForKey:@"count"];
        VC.type = @"1";
        VC.roomId = self.roomId;
        VC.isliaotians = YES;
        VC.block = ^(NSString *name) {
            NSString *roomid = self.roomId.copy;
            NSString *url = [PICHEADURL stringByAppendingString:getChatInfoUrl];
            [NetManager afPostRequest:url parms:@{@"roomid":roomid} finished:^(id responseObj) {
                if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                    self.infoDic = [NSDictionary dictionary];
                    self.infoDic = [responseObj objectForKey:@"data"];
                    [self.table reloadData];
                }
            } failed:^(NSString *errorMsg) {
                
            }];
        };
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (indexPath.row==2) {
        
        NSArray *array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        UILabel *lab = [self.table viewWithTag:101];
        
        // 使用
        // 1.Custom propery（自定义属性）
        NSDictionary *propertyDict = @{ZJPickerViewPropertyCanceBtnTitleKey : @"取消",
                                       ZJPickerViewPropertySureBtnTitleKey  : @"确定",
                                       ZJPickerViewPropertyCanceBtnTitleColorKey : [UIColor colorWithHexString:@"A9A9A9" alpha:1],
                                       ZJPickerViewPropertySureBtnTitleColorKey : MainColor,
                                       ZJPickerViewPropertyTipLabelTextColorKey : MainColor,
                                       ZJPickerViewPropertyLineViewBackgroundColorKey : [UIColor colorWithHexString:@"dedede" alpha:1],
                                       ZJPickerViewPropertyCanceBtnTitleFontKey : [UIFont systemFontOfSize:17.0f],
                                       ZJPickerViewPropertySureBtnTitleFontKey : [UIFont systemFontOfSize:17.0f],
                                       ZJPickerViewPropertyTipLabelTextFontKey : [UIFont systemFontOfSize:17.0f],
                                       ZJPickerViewPropertySelectRowTitleAttrKey : @{NSForegroundColorAttributeName : MainColor, NSFontAttributeName : [UIFont systemFontOfSize:15.0f]},
                                       ZJPickerViewPropertyUnSelectRowTitleAttrKey : @{NSForegroundColorAttributeName : TextCOLOR, NSFontAttributeName : [UIFont systemFontOfSize:15.0f]},
                                       ZJPickerViewPropertyIsTouchBackgroundHideKey : @YES,
                                       ZJPickerViewPropertyIsTouchBackgroundHideKey : @YES,
                                       ZJPickerViewPropertyIsShowTipLabelKey : @YES,
                                       ZJPickerViewPropertyIsShowSelectContentKey : @YES,
                                       ZJPickerViewPropertyIsScrollToSelectedRowKey: @YES,
                                       ZJPickerViewPropertyIsAnimationShowKey : @YES};
        
        [ZJPickerView zj_showWithDataList:array propertyDict:propertyDict completion:^(NSString *selectContent) {
            lab.text = selectContent;
            [self.table reloadData];
            
            NSString *url = [PICHEADURL stringByAppendingString:editChatMicNumUrl];
            NSString *roomid = roomidStr?:@"";
            NSString *micnum = selectContent?:@"";
            NSDictionary *params = @{@"roomid":roomid,@"micnum":micnum};
            [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
                
            } failed:^(NSString *errorMsg) {
                
            }];
            
        }];
        
    }
    
}

-(void)chooseinfoClick
{
    LDAlertHeadAndNameViewController *vc = [[LDAlertHeadAndNameViewController alloc] init];
    vc.isliaotians = YES;
    vc.headUrl = [self.infoDic objectForKey:@"pic"];
    vc.groupName = [self.infoDic objectForKey:@"name"];
    vc.infoDic = self.infoDic.copy;
    vc.roomId = self.roomId;
    vc.myBlock = ^(NSDictionary *dic) {
        
        NSString *roomid = self.roomId.copy;
        NSString *url = [PICHEADURL stringByAppendingString:getChatInfoUrl];
        [NetManager afPostRequest:url parms:@{@"roomid":roomid} finished:^(id responseObj) {
            if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                self.infoDic = [NSDictionary dictionary];
                self.infoDic = [responseObj objectForKey:@"data"];
                [self.table reloadData];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
        NSLog(@"页面pop成功了");
        if ([self.rule intValue]==1) {
            if (self.myBlock) {
                self.myBlock([NSDictionary dictionary]);
            }
        }
    }
}

#pragma mark - 切换选择

-(void)leftbtnclick
{
    if ([self.rule intValue]==0) {
        return;
    }
    self.mictype = @"1";
    [self.table reloadData];
    [self choosemictype];
}

-(void)rightbtnclick
{
    if ([self.rule intValue]==0) {
        return;
    }
    self.mictype = @"2";
    [self.table reloadData];
    [self choosemictype];
}

-(void)choosemictype
{
    NSString *url = [PICHEADURL stringByAppendingString:@"api/power/setChatMicType"];
    NSString *roomid = roomidStr.copy;
    NSDictionary *params = @{@"roomid":roomid,@"mictype":self.mictype};
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

@end
