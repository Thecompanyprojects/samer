//
//  LDAboutShengMoViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/13.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDAboutShengMoViewController.h"
#import "LDShengMoViewController.h"

@interface LDAboutShengMoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation LDAboutShengMoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"关于Samer";
    
    _dataArray = @[@"圣魔文化节",@"活动★俱乐部",@"创始人"];
    
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
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    cell.imageView.image = [UIImage imageNamed:_dataArray[indexPath.row]];
    
    cell.textLabel.text = _dataArray[indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
 
        LDShengMoViewController *mvc = [[LDShengMoViewController alloc] init];
        
        mvc.name = _dataArray[indexPath.row];
        
        mvc.state = @"3";
        
        [self.navigationController pushViewController:mvc animated:YES];
        
    }else if (indexPath.row == 1){
        
        LDShengMoViewController *mvc = [[LDShengMoViewController alloc] init];
        
        mvc.name = _dataArray[indexPath.row];
        
        mvc.state = @"1";
        
        [self.navigationController pushViewController:mvc animated:YES];
        
    }else if (indexPath.row == 2){
        
        LDShengMoViewController *mvc = [[LDShengMoViewController alloc] init];
        
        mvc.name = _dataArray[indexPath.row];
        
        mvc.state = @"4";
        
        [self.navigationController pushViewController:mvc animated:YES];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
