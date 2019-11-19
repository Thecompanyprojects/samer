//
//  LDSelectAtPersonViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/2.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDSelectAtPersonViewController.h"
#import "SelectAtCell.h"
#import "TableModel.h"

@interface LDSelectAtPersonViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,assign) int page;
@property (nonatomic,strong) UITextField *search;
@property (nonatomic,copy)   NSString *nameStr;
@end

@implementation LDSelectAtPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    self.nameArray = [NSMutableArray array];
    self.selectArray2 = [NSMutableArray array];
    self.nameArray2 = [NSMutableArray array];
    self.liaoselectArray = [NSMutableArray array];
    self.liaonameArray = [NSMutableArray array];
    [self createTableView];
    
    if ([self.content intValue]==0) {
        
        NSArray *array =  [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE)]];
        if (array.count > 0) {
            
            for (int i = 0; i < array.count; i++) {
                RCConversation *conversation = array[i];

                RCUserInfo *user = [[RCIM sharedRCIM] getUserInfoCache:conversation.targetId];
                
                TableModel *Tmodel = [[TableModel alloc] init];
                Tmodel.uid = conversation.targetId;
                Tmodel.select = NO;
                Tmodel.nickname = user.name;
                Tmodel.head_pic = user.portraitUri;
                [self.dataArray addObject:Tmodel];
            }
            [self.tableView reloadData];
        }
    }
    else
    {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 0;
            [self createData:@"1"];
        }];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [self createData:@"2"];
        }];
    }
    
    [self.tableView.mj_header beginRefreshing];
    
    if ([self.content intValue]!=0) {
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
        self.tableView.frame = CGRectMake(0, 44, WIDTH, [self getIsIphoneX:ISIPHONEX]-44);
    }
    else
    {
        self.tableView.frame = CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.content intValue]==0) {
        return YES;
    }
    self.nameStr = textField.text;
    [textField resignFirstResponder];
    [self.dataArray removeAllObjects];
    [self.tableView.mj_header beginRefreshing];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.content intValue]==0) {
        return;
    }
    self.nameStr = textField.text;
    [textField resignFirstResponder];
    [self.dataArray removeAllObjects];
    [self.tableView.mj_header beginRefreshing];
}

-(void)createData:(NSString *)str{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,newgetFollewingListUrl];
    NSDictionary *parameters;
    NSString *type = [NSString stringWithFormat:@"%ld",(long)[self.content integerValue]-1];
    parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":type?:@"",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"name":self.nameStr?:@"",@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
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
            }else{
                [self.tableView.mj_footer endRefreshing];
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else{
            if ([str intValue]==1) {
                [self.dataArray removeAllObjects];
            }
            NSArray *data = [NSArray yy_modelArrayWithClass:[TableModel class] json:responseObj[@"data"]];
            [self.dataArray addObjectsFromArray:data];
            self.tableView.mj_footer.hidden = NO;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    } failed:^(NSString *errorMsg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, WIDTH, [self getIsIphoneX:ISIPHONEX]-44) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 88;
    _tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count?:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SelectAtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectAt"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SelectAtCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.content intValue]==0) {
        
        TableModel *model = self.dataArray[indexPath.row];
        cell.model = model;
        cell.nameLabel.text = model.nickname;
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.head_pic] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        cell.nameW.constant = 200;
        [cell.ageLabel setHidden:YES];
        [cell.sexLabel setHidden:YES];
        [cell.aSexView setHidden:YES];
        [cell.sexualLabel setHidden:YES];
        if (indexPath.row==self.dataArray.count-1) {
            [cell.lineView setHidden:YES];
        }
        else
        {
            [cell.lineView setHidden:NO];
        }
    }
    else
    {
        if (self.dataArray.count!=0) {
            [cell.ageLabel setHidden:NO];
            [cell.sexLabel setHidden:NO];
            [cell.aSexView setHidden:NO];
            [cell.sexualLabel setHidden:NO];
            TableModel *model = self.dataArray[indexPath.row];
            cell.model = model;
           
            if (indexPath.row==self.dataArray.count-1) {
                [cell.lineView setHidden:YES];
            }
            else
            {
                [cell.lineView setHidden:NO];
            }
            
            if (self.isfromGroup) {
                BOOL isbool = [self.uidArray containsObject: model.uid];
                if (isbool) {
                    model.select = YES;
                }
                
            }
            if (model.select) {
                cell.selectView.image = [UIImage imageNamed:@"shiguanzhu"];
            }
            else
            {
                cell.selectView.image = [UIImage imageNamed:@"kongguanzhu"];
            }
            
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count==0) {
        return;
    }
    SelectAtCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    TableModel *model = self.dataArray[indexPath.row];
    
    if (self.isfromGroup) {
        BOOL isbool = [self.uidArray containsObject: model.uid];
        if (isbool) {
            return;
        }
    }
    
    NSString *uid = [NSString new];
    NSString *name = [NSString new];
    
    if ([self.content intValue]==0) {
        uid = model.uid;
        name = [NSString stringWithFormat:@"%@%@%@",@"@",model.nickname,@" "];
    }
    else
    {
        NSDictionary *userinfo = model.userInfo;
        uid = [userinfo objectForKey:@"uid"];
        name = [NSString stringWithFormat:@"%@%@%@",@"@",[userinfo objectForKey:@"nickname"],@" "];
    }
    if (model.select) {
     
        cell.selectView.image = [UIImage imageNamed:@"kongguanzhu"];
        model.select = NO;
        
        if ([self.content intValue]==0) {
            [self.liaonameArray removeObject:name];
            [self.liaoselectArray removeObject:uid];
            
            NSNotification *notification = [NSNotification notificationWithName:@"addselectname3" object:self.liaonameArray];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            NSNotification *notifications = [NSNotification notificationWithName:@"addselectuid3" object:self.liaoselectArray];
            [[NSNotificationCenter defaultCenter] postNotification:notifications];
        }
        
        if ([self.content intValue]==1) {
            
            [self.nameArray removeObject:name];
            [self.selectArray removeObject:uid];
            
            NSNotification *notification = [NSNotification notificationWithName:@"addselectname" object:self.nameArray];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            NSNotification *notifications = [NSNotification notificationWithName:@"addselectuid" object:self.selectArray];
            [[NSNotificationCenter defaultCenter] postNotification:notifications];
        }
         if ([self.content intValue]==2)
        {
            [self.nameArray2 removeObject:name];
            [self.selectArray2 removeObject:uid];
            
            NSNotification *notification = [NSNotification notificationWithName:@"addselectname2" object:self.nameArray2];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            NSNotification *notifications = [NSNotification notificationWithName:@"addselectuid2" object:self.selectArray2];
            [[NSNotificationCenter defaultCenter] postNotification:notifications];
        }
        
    }else{

        cell.selectView.image = [UIImage imageNamed:@"shiguanzhu"];
        model.select = YES;
        
        if ([self.content intValue]==0) {
            [self.liaoselectArray addObject:uid];
            [self.liaonameArray addObject:name];
            NSNotification *notification = [NSNotification notificationWithName:@"addselectname3" object:self.liaonameArray];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            NSNotification *notifications = [NSNotification notificationWithName:@"addselectuid3" object:self.liaoselectArray];
            [[NSNotificationCenter defaultCenter] postNotification:notifications];
        }
        
        if ([self.content intValue]==1) {
            [self.selectArray addObject:uid];
            [self.nameArray addObject:name];
            NSNotification *notification = [NSNotification notificationWithName:@"addselectname" object:self.nameArray];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            NSNotification *notifications = [NSNotification notificationWithName:@"addselectuid" object:self.selectArray];
            [[NSNotificationCenter defaultCenter] postNotification:notifications];
        }
        if ([self.content intValue]==2)
        {
            [self.selectArray2 addObject:uid];
            [self.nameArray2 addObject:name];
            NSNotification *notification = [NSNotification notificationWithName:@"addselectname2" object:self.nameArray2];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            NSNotification *notifications = [NSNotification notificationWithName:@"addselectuid2" object:self.selectArray2];
            [[NSNotificationCenter defaultCenter] postNotification:notifications];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
