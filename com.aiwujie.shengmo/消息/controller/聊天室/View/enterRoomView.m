//
//  enterRoomView.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/1.
//  Copyright © 2019 a. All rights reserved.
//

#import "enterRoomView.h"

@interface enterRoomView()

@end

@implementation enterRoomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.iconimg];
        [self addSubview:self.nameLab];
        [self setuplayout];
        
        UIColor *colorOne = [UIColor colorWithHexString:@"#A994F4" alpha:1];
        UIColor *colorTwo = [UIColor colorWithHexString:@"#8ADAEB" alpha:1];
        NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        //设置开始和结束位置(设置渐变的方向)
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(1, 0);
        gradient.colors = colors;
        gradient.frame = CGRectMake(0, 0, 180, 34);
        [self.layer insertSublayer:gradient atIndex:0];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 17;
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.iconimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.width.mas_offset(34);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconimg.mas_right).with.offset(10);
        make.height.mas_offset(14);
        make.right.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
    }];
}

#pragma mark - getters

-(UIImageView *)iconimg
{
    if(!_iconimg)
    {
        _iconimg = [[UIImageView alloc] init];
        _iconimg.layer.masksToBounds = YES;
        _iconimg.layer.cornerRadius = 17;
    }
    return _iconimg;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = [UIColor whiteColor];
        _nameLab.font = [UIFont systemFontOfSize:14];
    }
    return _nameLab;
}



@end
