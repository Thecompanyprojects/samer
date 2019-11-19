
//
//  topimgView2.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/9.
//  Copyright © 2019 a. All rights reserved.
//

#import "topimgView2.h"

@interface topimgView2()
@property (nonatomic,strong) UIImageView *img0;
@property (nonatomic,strong) UIImageView *img1;
@property (nonatomic,strong) UIImageView *img2;
@end

@implementation topimgView2

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.img0];
        [self addSubview:self.img1];
        [self addSubview:self.img2];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;

    [weakSelf.img0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.width.mas_offset(66);
        make.height.mas_offset(66);
    }];
    [weakSelf.img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.img0.mas_bottom).with.offset(-15);
        make.width.mas_offset(66);
        make.height.mas_offset(66);
        make.right.equalTo(weakSelf.img0.mas_left).with.offset(20);
    }];
    [weakSelf.img2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.img0.mas_bottom).with.offset(-15);
        make.width.mas_offset(66);
        make.height.mas_offset(66);
        make.left.equalTo(weakSelf.img0.mas_right).with.offset(-20);
    }];
}

#pragma mark - getters

-(UIImageView *)img0
{
    if(!_img0)
    {
        _img0 = [[UIImageView alloc] init];
        _img0.image = [UIImage imageNamed:@"推顶火箭"];
    }
    return _img0;
}

-(UIImageView *)img1
{
    if(!_img1)
    {
        _img1 = [[UIImageView alloc] init];
        _img1.image = [UIImage imageNamed:@"推顶火箭"];
    }
    return _img1;
}

-(UIImageView *)img2
{
    if(!_img2)
    {
        _img2 = [[UIImageView alloc] init];
        _img2.image = [UIImage imageNamed:@"推顶火箭"];
    }
    return _img2;
}


@end
