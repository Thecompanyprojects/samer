//
//  switchaccountCell.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/5.
//  Copyright © 2019 a. All rights reserved.
//

#import "switchaccountCell.h"

@interface switchaccountCell()
@property (nonatomic,strong) UIImageView *img;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *accountLab;
@end

@implementation switchaccountCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.img];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.accountLab];
        [self.contentView addSubview:self.changeImg];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(44);
        make.height.mas_offset(44);
        make.left.equalTo(weakSelf).with.offset(15);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.img);
        make.left.equalTo(weakSelf.img.mas_right).with.offset(10);
        make.right.equalTo(weakSelf).with.offset(-20);
    }];
    [weakSelf.accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(10);
        make.left.equalTo(weakSelf.img.mas_right).with.offset(10);
        make.right.equalTo(weakSelf).with.offset(-20);
    }];
    [weakSelf.changeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-20);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(30);
        make.height.mas_offset(30);
    }];
}

-(void)setModel:(LDswitchModel *)model
{
    [self.img sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.img.contentMode = UIViewContentModeScaleAspectFill;
    self.nameLab.text = model.nickname;
    if (model.account.length!=0) {
        self.accountLab.text = [NSString stringWithFormat:@"%@%@",@"账号:",model.account];
    }
    else
    {
        if ([model.way intValue]==1) {
            self.accountLab.text = @"QQ登录";
        }
        if ([model.way intValue]==2) {
            self.accountLab.text = @"微信登录";
        }
        if ([model.way intValue]==3) {
            self.accountLab.text = @"微博登录";
        }
    }
}

#pragma mark - getters

-(UIImageView *)img
{
    if(!_img)
    {
        _img = [[UIImageView alloc] init];
        _img.layer.masksToBounds = YES;
        _img.layer.cornerRadius = 22;
        
    }
    return _img;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = TextCOLOR;
        _nameLab.font = [UIFont systemFontOfSize:14];
    }
    return _nameLab;
}

-(UILabel *)accountLab
{
    if(!_accountLab)
    {
        _accountLab = [[UILabel alloc] init];
        _accountLab.textColor  = [UIColor colorWithHexString:@"A3A3A3" alpha:1];
        _accountLab.font = [UIFont systemFontOfSize:12];
    }
    return _accountLab;
}

-(UIImageView *)changeImg
{
    if(!_changeImg)
    {
        _changeImg = [[UIImageView alloc] init];
        _changeImg.image = [UIImage imageNamed:@"选择对勾"];
    }
    return _changeImg;
}

@end
