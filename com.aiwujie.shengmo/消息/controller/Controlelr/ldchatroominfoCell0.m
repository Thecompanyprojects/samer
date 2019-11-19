//
//  ldchatroominfoCell0.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/3.
//  Copyright © 2019 a. All rights reserved.
//

#import "ldchatroominfoCell0.h"

@interface ldchatroominfoCell0()

@property (nonatomic,strong) UILabel *contentLab;

@property (nonatomic,strong) UIView *line;
@end

@implementation ldchatroominfoCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.rightImg];
        [self.contentView addSubview:self.line];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(55);
        make.height.mas_offset(55);
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(20);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImg);
        make.left.equalTo(weakSelf.iconImg.mas_right).with.offset(16);
        make.height.mas_offset(18);
        make.right.equalTo(weakSelf).with.offset(-15);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-15);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(20);
        make.left.equalTo(weakSelf.nameLab);
    }];
    [weakSelf.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.width.mas_offset(8);
        make.height.mas_offset(13);
    }];
    [weakSelf.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf);
        make.height.mas_offset(1);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
    }];
}

#pragma mark - getters

-(UIView *)line
{
    if(!_line)
    {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"f5f5f5" alpha:1];
    }
    return _line;
}

-(UIImageView *)rightImg
{
    if(!_rightImg)
    {
        _rightImg = [[UIImageView alloc] init];
        _rightImg.image = [UIImage imageNamed:@"又箭头灰色"];
    }
    return _rightImg;
}

-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 55/2;
    }
    return _iconImg;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:15];
        _nameLab.textColor = TextCOLOR;
    }
    return _nameLab;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = [UIColor lightGrayColor];
        _contentLab.font = [UIFont systemFontOfSize:13];
        _contentLab.text = @"";
    }
    return _contentLab;
}

@end
