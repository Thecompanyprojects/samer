//
//  ToreceiveViewController.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/10.
//  Copyright © 2019 a. All rights reserved.
//

#import "ToreceiveViewController.h"
#import "toreceiveCell.h"

@interface ToreceiveViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *messageLab;
@property (nonatomic,strong) UILabel *numberLab;
@end

static NSString *toreceiveIdentfity = @"toreceiveIdentfity";

@implementation ToreceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    [self createTableView];
    [self creaeData];
}

-(void)creaeData
{
    self.titleLab.text = [NSString stringWithFormat:@"%@%@",self.model.u_nickname,@"的红包"];
    if (self.model.gettime.length<=2) {
        self.numberLab.text = [NSString stringWithFormat:@"%@%@%@",@"1个红包共",self.model.beans,@"金魔豆 待领取"];
    }
    else
    {
        self.numberLab.text = [NSString stringWithFormat:@"%@%@%@",@"1个红包共",self.model.beans,@"金魔豆 已领取"];
    }
    
    if (self.model.content.length==0) {
        self.messageLab.text = @"恭喜发财，大吉大利";
    }
    else
    {
        self.messageLab.text = self.model.content;
    }
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self vhl_setNavBarShadowImageHidden:NO];
    [self vhl_setNavBarBackgroundColor:[UIColor whiteColor]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self vhl_setNavBarShadowImageHidden:YES];
    [self vhl_setNavBarBackgroundColor:[UIColor colorWithHexString:@"EF5B49" alpha:1]];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 0) style:UITableViewStylePlain];
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
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE" alpha:1];
    [self.view addSubview:self.tableView];
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = self.headView;
}

-(UIView *)headView
{
    if(!_headView)
    {
        _headView = [[UIView alloc] init];
        _headView.frame = CGRectMake(0, -2, WIDTH, 170);
        [_headView addSubview:self.bgView];
        [_headView addSubview:self.headImg];
        [_headView addSubview:self.titleLab];
        [_headView addSubview:self.messageLab];
        [_headView addSubview:self.numberLab];
    }
    return _headView;
}

-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.frame = CGRectMake(0, -2, WIDTH, 75);
        _bgView.backgroundColor = [UIColor colorWithHexString:@"EF5B49" alpha:1];
    }
    return _bgView;
}


-(UIImageView *)headImg
{
    if(!_headImg)
    {
        _headImg = [[UIImageView alloc] init];
        _headImg.frame = CGRectMake(0, 70, WIDTH, 50);
        _headImg.image = [UIImage imageNamed:@"假半圆"];
    }
    return _headImg;
}

-(UILabel *)titleLab
{
    if(!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        _titleLab.frame = CGRectMake(10, 30, WIDTH-20, 20);
        _titleLab.textColor = [UIColor colorWithHexString:@"FED2AD" alpha:1];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

-(UILabel *)messageLab
{
    if(!_messageLab)
    {
        _messageLab = [[UILabel alloc] init];
        _messageLab.frame = CGRectMake(10, 69, WIDTH-20, 16);
        _messageLab.textColor = [UIColor colorWithHexString:@"FED2AD" alpha:1];
        _messageLab.font = [UIFont systemFontOfSize:13];
        _messageLab.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLab;
}

-(UILabel *)numberLab
{
    if(!_numberLab)
    {
        _numberLab = [[UILabel alloc] init];
        _numberLab.frame = CGRectMake(20, 136, WIDTH-40, 20);
        _numberLab.font = [UIFont systemFontOfSize:16];
        _numberLab.textColor = TextCOLOR;
        _numberLab.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLab;
}


#pragma mark - UITableViewDataSource&&UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.islingqu) {
        return 1;
    }
    else
    {
        if (self.model.gettime.length<2) {
            return 0;
        }
        else
        {
            return 1;
        }
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    toreceiveCell *cell = [tableView dequeueReusableCellWithIdentifier:toreceiveIdentfity];
    cell = [[toreceiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:toreceiveIdentfity];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
