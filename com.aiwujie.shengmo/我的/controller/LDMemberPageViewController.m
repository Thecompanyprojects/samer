//
//  LDMemberPageViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/11/21.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDMemberPageViewController.h"
#import "LDProtocolViewController.h"
#import "VIPMemberCell.h"
#import "VIPMemberModel.h"
#import "LDVIPMemberView.h"

@interface LDMemberPageViewController ()<UITableViewDelegate,UITableViewDataSource,LDVIPMemberDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) LDVIPMemberView * vipMemberView;
@end

@implementation LDMemberPageViewController

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *array;
    
    if ([self.content intValue] == 0) {
        
        array = @[@{@"month":@"1个月/¥30元",@"introduce":@"31天超值特权",@"oldprice":@"",@"warnstate":@"0",@"selectstate":@"1",@"price":@"30"},@{@"month":@"3个月/¥88元",@"introduce":@"[优惠3%]93天超值特权",@"oldprice":@"90",@"warnstate":@"0",@"selectstate":@"0",@"price":@"88"},@{@"month":@"6个月/¥168元",@"introduce":@"[优惠7%]186天超值特权",@"oldprice":@"180",@"warnstate":@"0",@"selectstate":@"0",@"price":@"168"},@{@"month":@"12个月/¥298元",@"introduce":@"[优惠18%]372天超值特权",@"oldprice":@"360",@"warnstate":@"1",@"selectstate":@"0",@"price":@"298"}];
        
    }else{
        
         array = @[@{@"month":@"1个月/¥128元",@"introduce":@"31天超值特权",@"oldprice":@"",@"warnstate":@"0",@"selectstate":@"1",@"price":@"128"},@{@"month":@"3个月/¥348元",@"introduce":@"[优惠9%]93天超值特权",@"oldprice":@"384",@"warnstate":@"0",@"selectstate":@"0",@"price":@"348"},@{@"month":@"8个月/¥898元",@"introduce":@"[优惠13%]248天超值特权",@"oldprice":@"1024",@"warnstate":@"0",@"selectstate":@"0",@"price":@"898"},@{@"month":@"12个月/¥1298元",@"introduce":@"[优惠16%]372天超值特权",@"oldprice":@"1536",@"warnstate":@"1",@"selectstate":@"0",@"price":@"1298"}];
    }
    
    for (NSDictionary *dict in array) {
        
        VIPMemberModel *model = [[VIPMemberModel alloc] init];
        
        [model setValuesForKeysWithDictionary:dict];
        
        [self.dataArray addObject:model];
    }
    
    //初始默认选择第一个选项
    self.vipNum = 0;
    self.svipNum = 0;
    
    [self createTableView];
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 148 - 44);
    self.tableView.showsVerticalScrollIndicator = NO;
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
    _vipMemberView = [[LDVIPMemberView alloc] initWithVIPtype:self.content];
    _vipMemberView.delegate = self;
    self.tableView.tableFooterView = _vipMemberView;
    [self.view addSubview:self.tableView];
}

#pragma 点击协议的代理方法
- (void)vipMemberProtcolDidSelect {
    
    LDProtocolViewController *pvc = [[LDProtocolViewController alloc] init];
    
    pvc.type = @"1";
    
    [self.navigationController pushViewController:pvc animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VIPMemberCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"VIPMember"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"VIPMemberCell" owner:self options:nil].lastObject;
        
    }
    
    VIPMemberModel *model = _dataArray[indexPath.row];
    
    //cell中赋值
    cell.model = model;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    for (int i = 0; i < _dataArray.count; i++) {
        
        VIPMemberModel *model = _dataArray[i];
        
        if (i == indexPath.row) {
            
            model.selectstate = @"1";
            
        }else{
            
            model.selectstate = @"0";
        }
    }
    
    VIPMemberModel *model = _dataArray[indexPath.row];
    
    if ([self.content intValue] == 0) {
        
        self.vipNum = indexPath.row;
        
        _vipMemberView.moneyLabel.text = [NSString stringWithFormat:@"金额 %@ 元",model.price];
        
    }else{
        
        self.svipNum = indexPath.row;
        
        _vipMemberView.moneyLabel.text = [NSString stringWithFormat:@"金额 %@ 元",model.price];
    }
    
    [self changeWordColorTitle:_vipMemberView.moneyLabel.text andLoc:3 andLen:model.price.length andLabel:_vipMemberView.moneyLabel];
    
    [self.tableView reloadData];
}

//更改某个字体的颜色
-(void)changeWordColorTitle:(NSString *)str andLoc:(NSUInteger)loc andLen:(NSUInteger)len andLabel:(UILabel *)attributedLabel{
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(loc,len)];
    attributedLabel.attributedText = attributedStr;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
