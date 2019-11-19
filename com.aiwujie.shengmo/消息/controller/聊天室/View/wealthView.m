//
//  wealthView.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/2.
//  Copyright © 2019 a. All rights reserved.
//

#import "wealthView.h"

@implementation wealthView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftImg];
        [self addSubview:self.numberLab];
        [self setuplayout];
    }
    return self;
}
-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(0);
        make.width.mas_offset(15);
        make.height.mas_offset(15);
    }];
    [weakSelf.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
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
        _leftImg.image = [UIImage imageNamed:@"财"];
    }
    return _leftImg;
}

-(UILabel *)numberLab
{
    if(!_numberLab)
    {
        _numberLab = [[UILabel alloc] init];
        _numberLab.textAlignment = NSTextAlignmentCenter;
        _numberLab.textColor = [UIColor whiteColor];
    }
    return _numberLab;
}


@end
