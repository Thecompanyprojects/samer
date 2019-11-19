//
//  topimgView3.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/9.
//  Copyright © 2019 a. All rights reserved.
//

#import "topimgView3.h"

@interface topimgView3()
@property (nonatomic,strong) UIImageView *img0;
@property (nonatomic,strong) UIImageView *img1;
@end

@implementation topimgView3


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.img0];
        [self addSubview:self.img1];
        
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.img0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-weakSelf.frame.size.width/2);
        make.width.mas_offset(210);
        make.height.mas_offset(210);
        
    }];
    [weakSelf.img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(weakSelf.frame.size.width/2);
        make.width.mas_offset(210);
        make.height.mas_offset(210);
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


@end
