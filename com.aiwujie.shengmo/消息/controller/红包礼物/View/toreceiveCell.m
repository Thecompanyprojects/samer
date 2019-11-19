//
//  toreceiveCell.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/10.
//  Copyright © 2019 a. All rights reserved.
//

#import "toreceiveCell.h"

//红包领取详情
@interface toreceiveCell()
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *moneyLab;
@end

@implementation toreceiveCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.moneyLab];
        [self setuplayout];
    }
    return self;
}

-(void)create:(redgroupModel *)model
{
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.fhead_pic] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.nameLab.text = model.fnickname;
    self.moneyLab.text = [NSString stringWithFormat:@"%@%@",model.num,@"金魔豆"];
    if (model.gettime.length<2) {
        self.timeLab.text = @"";
        NSString *times = [[TimeManager defaultTool] getNowTimeTimestamp];
        self.timeLab.text = [[TimeManager defaultTool] getDateFormatStrFromTimeStampWithMin:times];
        
    }
    else
    {
        
        self.timeLab.text = [[TimeManager defaultTool] getDateFormatStrFromTimeStampWithMin:model.gettime];
    }
}

- (void)setModel:(toreceiveModel *)model
{
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.f_head_pic] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.nameLab.text = model.f_nickname;
    self.moneyLab.text = [NSString stringWithFormat:@"%@%@",model.beans,@"金魔豆"];
    if (model.gettime.length<2) {
        self.timeLab.text = @"";
        NSString *times = [[TimeManager defaultTool] getNowTimeTimestamp];
        self.timeLab.text = [[TimeManager defaultTool] getDateFormatStrFromTimeStampWithMin:times];
        
    }
    else
    {
       
        self.timeLab.text = [[TimeManager defaultTool] getDateFormatStrFromTimeStampWithMin:model.gettime];
    }
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
    [weakSelf.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-20);
        make.centerY.equalTo(weakSelf);
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
        _iconImg.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
        [_iconImg addGestureRecognizer:tapGesture];
        _iconImg.userInteractionEnabled = YES;
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

-(UILabel *)moneyLab
{
    if(!_moneyLab)
    {
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.textAlignment = NSTextAlignmentRight;
        _moneyLab.textColor = [UIColor blackColor];
        _moneyLab.font = [UIFont systemFontOfSize:14];
    }
    return _moneyLab;
}

-(void)clickImage
{
    if (self.delegate) {
        [self.delegate touchup:self];
    }
}

@end
