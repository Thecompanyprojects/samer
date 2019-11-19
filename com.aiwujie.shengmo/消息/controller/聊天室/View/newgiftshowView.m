//
//  newgiftshowView.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/9/19.
//  Copyright © 2019 a. All rights reserved.
//

#import "newgiftshowView.h"

@implementation newgiftshowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.giftImg];
        [self addSubview:self.messageLab];
        [self setuplayout];
        UIColor *colorTwo = [UIColor colorWithHexString:@"#A994F4" alpha:1];
        UIColor *colorOne = [UIColor colorWithHexString:@"#FF0000" alpha:1];
        NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        //设置开始和结束位置(设置渐变的方向)
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(1, 0);
        gradient.colors = colors;
        gradient.frame = CGRectMake(0, 0, 320, 46);
        [self.layer insertSublayer:gradient atIndex:0];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 23;
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(8);
        make.width.mas_offset(23);
        make.height.mas_offset(23);
    }];
    
    [weakSelf.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.giftImg.mas_right).with.offset(5);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-5);
    }];
}

#pragma mark - getters

-(UILabel *)messageLab
{
    if(!_messageLab)
    {
        _messageLab = [[UILabel alloc] init];
        _messageLab.textColor = [UIColor whiteColor];
        _messageLab.font = [UIFont systemFontOfSize:14];
    }
    return _messageLab;
}

-(UIImageView *)giftImg
{
    if(!_giftImg)
    {
        _giftImg = [[UIImageView alloc] init];
        
    }
    return _giftImg;
}


@end
