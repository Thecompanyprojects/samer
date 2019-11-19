//
//  LDHelpCenterViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDHelpCenterViewController.h"
#import "LDHelpViewController.h"
#import "LDConnectUsViewController.h"
#import "LDStandardViewController.h"
#import "LDProtocolViewController.h"

@interface LDHelpCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation LDHelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"帮助中心";
    _dataArray = @[@"使用帮助",@"用户条款",@"图文规范",@"用户隐私协议",@"联系我们"];
    [self createTableView];
}

-(void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStylePlain];
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
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.imageView.image = [UIImage imageNamed:_dataArray[indexPath.row]];
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.textColor = TextCOLOR;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *lineView = [UIView new];
    [cell.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.textLabel.mas_left);
        make.right.equalTo(cell.contentView);
        make.bottom.equalTo(cell.contentView);
        make.height.mas_offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5" alpha:1];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0){
        LDHelpViewController *hvc = [[LDHelpViewController alloc] init];
        [self.navigationController pushViewController:hvc animated:YES];
        
    }else if (indexPath.row == 1){
        
        LDProtocolViewController *pvc = [[LDProtocolViewController alloc] init];
        
        [self.navigationController pushViewController:pvc animated:YES];
        
    }else if (indexPath.row == 2){
        
        LDStandardViewController *svc = [[LDStandardViewController alloc] init];
        
        svc.navigationItem.title = @"图文规范";
        
        svc.state = @"图文规范";
        
        [self.navigationController pushViewController:svc animated:YES];

        
    }else if (indexPath.row == 3){
      
        LDStandardViewController *svc = [[LDStandardViewController alloc] init];
        
        svc.navigationItem.title = @"用户隐私协议";
        
        svc.state = @"隐私协议";
        
        [self.navigationController pushViewController:svc animated:YES];

        
    }else if (indexPath.row == 4){
        
        LDConnectUsViewController *uvc = [[LDConnectUsViewController alloc] init];
        
        [self.navigationController pushViewController:uvc animated:YES];
 
        
    }
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
