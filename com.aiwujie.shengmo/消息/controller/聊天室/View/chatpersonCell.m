//
//  chatpersonCell.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/31.
//  Copyright © 2019 a. All rights reserved.
//

#import "chatpersonCell.h"

@interface chatpersonCell()
@property (nonatomic,strong) UIImageView *ruleImg;
@end

@implementation chatpersonCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.ruleImg];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView);
    }];
    
    [weakSelf.ruleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.iconImg);
        make.right.equalTo(weakSelf.contentView).with.offset(3);
        make.width.mas_offset(weakSelf.frame.size.width/3);
        make.height.mas_offset(weakSelf.frame.size.width/3);
    }];
    
}

- (void)setModel:(chatpersonModel *)model
{
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.head_pic] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    if ([model.rule intValue]==1) {
        self.ruleImg.hidden = NO;
    }
    else
    {
        self.ruleImg.hidden = YES;
    }
}

#pragma mark - getters

-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 20;
    }
    return _iconImg;
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
