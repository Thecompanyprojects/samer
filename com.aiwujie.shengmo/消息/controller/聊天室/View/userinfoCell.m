//
//  userinfoCell.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/3.
//  Copyright © 2019 a. All rights reserved.
//

#import "userinfoCell.h"
#import "ageView.h"

@interface userinfoCell()
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UIImageView *cerImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) ageView *ageLab;
@property (nonatomic,strong) UILabel *sexLab;
@property (nonatomic,strong) UIImageView *ruleImg;
@end

@implementation userinfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.cerImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.ageLab];
        [self.contentView addSubview:self.sexLab];
        [self.contentView addSubview:self.ruleImg];
        [self setuplayout];
    }
    return self;
}

- (void)setModel:(chatpersonModel *)model
{
    if ([model.role isEqualToString:@"S"]) {
        self.sexLab.text = @"斯";
        self.sexLab.backgroundColor = BOYCOLOR;
        
    }else if ([model.role isEqualToString:@"M"]){
        
        self.sexLab.text = @"慕";
        self.sexLab.backgroundColor = GIRLECOLOR;
    }else if ([model.role isEqualToString:@"SM"]){
        
        self.sexLab.text = @"双";
        self.sexLab.backgroundColor = DOUBLECOLOR;
    }else{
        
        self.sexLab.text = @"~";
        self.sexLab.backgroundColor = GREENCOLORS;
    }
    if ([model.sex intValue] == 1) {
        self.ageLab.backgroundColor = BOYCOLOR;
        self.ageLab.leftImg.image = [UIImage imageNamed:@"男"];
    }else if ([model.sex intValue] == 2){
        self.ageLab.backgroundColor = GIRLECOLOR;
        self.ageLab.leftImg.image = [UIImage imageNamed:@"女"];
    }else{
        self.ageLab.backgroundColor = DOUBLECOLOR;
        self.ageLab.leftImg.image = [UIImage imageNamed:@"双"];
    }
    self.ageLab.ageLab.text = [NSString stringWithFormat:@"%@",model.age];
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.head_pic] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.nameLab.text = model.nickname;
    if ([model.realname intValue]==0)
    {
        [self.cerImg setHidden:YES];
    }
    else
    {
        [self.cerImg setHidden:NO];
    }
    if ([model.rule intValue]==1) {
        [self.ruleImg setHidden:NO];
    }
    else
    {
        [self.ruleImg setHidden:YES];
    }
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(60);
        make.height.mas_offset(60);
        make.left.equalTo(weakSelf).with.offset(20);
        make.centerY.equalTo(weakSelf);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImg.mas_right).with.offset(12);
        make.top.equalTo(weakSelf.iconImg);
        make.height.mas_offset(14);
    }];
    [weakSelf.cerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLab);
        make.left.equalTo(weakSelf.nameLab.mas_right).with.offset(6);
        make.width.mas_offset(17);
        make.height.mas_offset(12);
    }];
    [weakSelf.ageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(36);
        make.height.mas_offset(15);
        make.left.equalTo(weakSelf.nameLab);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(20);
    }];
    [weakSelf.sexLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(22);
        make.height.mas_offset(15);
        make.top.equalTo(weakSelf.ageLab);
        make.left.equalTo(weakSelf.ageLab.mas_right).with.offset(6);
    }];
    [weakSelf.ruleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.iconImg).with.offset(4);
        make.bottom.equalTo(weakSelf.iconImg);
        make.width.mas_offset(18);
        make.height.mas_offset(18);
    }];
}

#pragma mark - getters

-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 30;
    }
    return _iconImg;
}

-(UIImageView *)cerImg
{
    if(!_cerImg)
    {
        _cerImg = [[UIImageView alloc] init];
        _cerImg.image = [UIImage imageNamed:@"认证"];
    }
    return _cerImg;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:14];
        _nameLab.textColor = TextCOLOR;
    }
    return _nameLab;
}

-(ageView *)ageLab
{
    if(!_ageLab)
    {
        _ageLab = [[ageView alloc] init];
        _ageLab.layer.masksToBounds = YES;
        _ageLab.layer.cornerRadius = 2;
        
    }
    return _ageLab;
}

-(UILabel *)sexLab
{
    if(!_sexLab)
    {
        _sexLab = [[UILabel alloc] init];
        _sexLab.layer.masksToBounds = YES;
        _sexLab.layer.cornerRadius = 2;
        _sexLab.textAlignment = NSTextAlignmentCenter;
        _sexLab.textColor = [UIColor whiteColor];
        _sexLab.font = [UIFont systemFontOfSize:10];
    }
    return _sexLab;
}

-(UIImageView *)ruleImg
{
    if(!_ruleImg)
    {
        _ruleImg = [[UIImageView alloc] init];
        _ruleImg.image = [UIImage imageNamed:@"群人数"];
    }
    return _ruleImg;
}

@end
