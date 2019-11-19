//
//  ageView.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/2.
//  Copyright © 2019 a. All rights reserved.
//

#import "ageView.h"

@implementation ageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftImg];
        [self addSubview:self.ageLab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(2);
        make.width.mas_offset(9);
        make.height.mas_offset(9);
    }];
    [weakSelf.ageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(2);
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
    }];
}

#pragma mark - getters

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];

    }
    return _leftImg;
}

-(UILabel *)ageLab
{
    if(!_ageLab)
    {
        _ageLab = [[UILabel alloc] init];
        _ageLab.textColor = [UIColor whiteColor];
        _ageLab.font = [UIFont systemFontOfSize:10];
        _ageLab.textAlignment = NSTextAlignmentCenter;
    }
    return _ageLab;
}

@end
