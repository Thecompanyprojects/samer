//
//  LDProvacyCell0.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/10.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDProvacyCell0.h"

@interface LDProvacyCell0()

@end

@implementation LDProvacyCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.switchBtn];
        [self.contentView addSubview:self.messageLab];
        [self.contentView addSubview:self.lineView];
        [self setuplayout];
  
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(20);
        make.top.equalTo(weakSelf).with.offset(15);
        make.width.mas_offset(200);
    }];
    [weakSelf.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-16);
        make.top.equalTo(weakSelf).with.offset(12);
    }];
    
    [weakSelf.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftLab);
        make.right.equalTo(weakSelf.contentView).with.offset(-20);
        make.top.equalTo(weakSelf.leftLab.mas_bottom).with.offset(15);
    }];
    
    [weakSelf.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftLab.mas_left);
        make.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView);
        make.height.mas_offset(1);
    }];
}

#pragma mark - getters

-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [UILabel new];
        _leftLab.textColor = TextCOLOR;
        _leftLab.font = [UIFont systemFontOfSize:15];
    }
    return _leftLab;
}

-(UISwitch *)switchBtn
{
    if(!_switchBtn)
    {
        _switchBtn = [UISwitch new];
        
    }
    return _switchBtn;
}

-(UILabel *)messageLab
{
    if(!_messageLab)
    {
        _messageLab = [[UILabel alloc] init];
        _messageLab.hidden = YES;
        _messageLab.font = [UIFont systemFontOfSize:12];
        _messageLab.textColor = [UIColor colorWithHexString:@"A7A7A7" alpha:1];
        _messageLab.text = @"开启后，你将不出现在身边-附近、在线及地图找人列表";
    }
    return _messageLab;
}


-(UIView *)lineView
{
    if(!_lineView)
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5" alpha:1];
    }
    return _lineView;
}
@end
