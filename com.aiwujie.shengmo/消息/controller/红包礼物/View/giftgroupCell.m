//
//  giftgroupCell.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/11.
//  Copyright © 2019 a. All rights reserved.
//

#import "giftgroupCell.h"

@interface giftgroupCell()
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *timeLab;
@end

@implementation giftgroupCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.timeLab];
        [self setuplayout];
    }
    return self;
}

-(void)setModel:(giftgroupModel *)model
{
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.fhead_pic] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.iconImg.contentMode = UIViewContentModeScaleAspectFill;
    self.nameLab.text = model.fnickname;
    self.timeLab.text = [[TimeManager defaultTool] getDateFormatStrFromTimeStampWithMin:model.gettime];
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf).with.offset(20);
        make.width.mas_offset(40);
        make.height.mas_offset(40);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImg);
        make.left.equalTo(weakSelf.iconImg.mas_right).with.offset(7);
    }];
    [weakSelf.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.iconImg);
        make.left.equalTo(weakSelf.nameLab);
    }];
}

#pragma mark - getters

-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 20;
        _iconImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [_iconImg addGestureRecognizer:singleTap];
    }
    return _iconImg;
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

-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:13];
        _timeLab.textColor = TextCOLOR;
    }
    return _timeLab;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)rez
{
    if (self.delegate) {
        [self.delegate iconTabVClick:self];
    }
}

@end
