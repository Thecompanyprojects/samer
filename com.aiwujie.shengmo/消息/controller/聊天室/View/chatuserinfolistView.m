//
//  chatuserinfolistView.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/3.
//  Copyright © 2019 a. All rights reserved.
//

#import "chatuserinfolistView.h"
#import "userinfoCell.h"
#import "UIButton+MSExtendTouchArea.h"

@interface chatuserinfolistView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIView *headView;
@end

static NSString *userinfoidentfity = @"userinfoidentfity";

@implementation chatuserinfolistView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.table];
        [self setuplayout];
        self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self refresh];
        }];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
}

-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc] init];
        _table.dataSource = self;
        _table.delegate = self;
        _table.tableHeaderView = self.headView;
        _table.tableFooterView = [UIView new];
    }
    return _table;
}

-(UIView *)headView
{
    if(!_headView)
    {
        _headView = [[UIView alloc] init];
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.frame = CGRectMake(0, 0, WIDTH, 40);
        [_headView addSubview:self.titleLab];
        [_headView addSubview:self.backBtn];
    }
    return _headView;
}

-(UILabel *)titleLab
{
    if(!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        _titleLab.frame = CGRectMake(0, 12, WIDTH, 20);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = TextCOLOR;
        _titleLab.text = @"在线用户";
    }
    return _titleLab;
}

-(UIButton *)backBtn
{
    if(!_backBtn)
    {
        _backBtn = [[UIButton alloc] init];
        _backBtn.frame = CGRectMake(WIDTH-70, 12, 13, 13);
        [_backBtn setImage:[UIImage imageNamed:@"聊天室-关闭"] forState:normal];
        [_backBtn extendTouchArea:UIEdgeInsetsMake(18, 10, 18, 10)];
    }
    return _backBtn;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    userinfoCell *cell = [tableView dequeueReusableCellWithIdentifier:userinfoidentfity];
    cell = [[userinfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userinfoidentfity];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSource.count!=0) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    chatpersonModel *model = self.dataSource[indexPath.row];
    if (self.delegate) {
        [self.delegate userlistinfovc:model.uid];
    }
}

-(void)refresh
{
    if (self.delegate) {
        [self.delegate refreshView];
    }
}
@end
