//
//  ldchatroominfoCell1.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/3.
//  Copyright © 2019 a. All rights reserved.
//

#import "ldchatroominfoCell1.h"

@interface ldchatroominfoCell1()
@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UIView *line;
@end

@implementation ldchatroominfoCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.messageLab];
        [self.contentView addSubview:self.rightImg];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(20);
        make.top.equalTo(weakSelf).with.offset(14);
        make.right.equalTo(weakSelf).with.offset(-15);
        make.height.mas_offset(18);
    }];
    [weakSelf.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-14);
        make.width.mas_offset(8);
        make.height.mas_offset(13);
        make.top.equalTo(weakSelf.titleLab);
    }];
    [weakSelf.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab);
        make.right.equalTo(weakSelf.titleLab);
        make.top.equalTo(weakSelf.titleLab.mas_bottom).with.offset(13+6);
    }];
    
}

#pragma mark - getters

-(UILabel *)titleLab
{
    if(!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = TextCOLOR;
        _titleLab.text = @"聊吧介绍";
    }
    return _titleLab;
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


-(UILabel *)messageLab
{
    if(!_messageLab)
    {
        _messageLab = [[UILabel alloc] init];
        _messageLab.numberOfLines = 0;
        _messageLab.font = [UIFont systemFontOfSize:13];
        _messageLab.textColor = [UIColor lightGrayColor];
        _messageLab.text = @"";
    }
    return _messageLab;
}

@end
