//
//  topimgView4.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/9.
//  Copyright © 2019 a. All rights reserved.
//

#import "topimgView4.h"

@interface topimgView4()
@property (nonatomic,strong) UIImageView *img0;
@property (nonatomic,strong) UIImageView *img1;
@property (nonatomic,strong) UIImageView *img2;
@end


@implementation topimgView4

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
        make.width.mas_offset(188);
        make.height.mas_offset(188);
    }];
    [weakSelf.img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.img0.mas_bottom).with.offset(5);
        make.width.mas_offset(188);
        make.height.mas_offset(188);
        make.right.equalTo(weakSelf).with.offset(-6);
    }];
    [weakSelf.img2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.img0.mas_bottom).with.offset(5);
        make.width.mas_offset(188);
        make.height.mas_offset(188);
        make.left.equalTo(weakSelf).with.offset(6);
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
