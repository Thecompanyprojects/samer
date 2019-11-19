//
//  LdtopHeaderView.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/11.
//  Copyright © 2019 a. All rights reserved.
//

#import "LdtopHeaderView.h"

@interface LdtopHeaderView()
@property (nonatomic,strong) UIImageView *topImg;

@end

@implementation LdtopHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topImg];
        [self addSubview:self.contentLab];
        [self setuplayout];
    }
    return self;
}

-(void)setTextFromurl:(NSString *)number
{
    NSString *str0 = @"共剩余 ";
    NSString *str1 = @" 张推顶卡";
    NSString *newStr = [NSString stringWithFormat:@"%@%@%@",str0,number,str1];
    self.contentLab.text = newStr;
    [self changeWordColorTitle:self.contentLab.text andLoc:4 andLen:number.length andLabel:self.contentLab];
}


/**
 更改字体颜色

 @param str 传入字符串
 @param loc 开始
 @param len 长度
 @param attributedLabel 显示label
 */
-(void)changeWordColorTitle:(NSString *)str andLoc:(NSUInteger)loc andLen:(NSUInteger)len andLabel:(UILabel *)attributedLabel{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:157/255.0 blue:0/255.0 alpha:1] range:NSMakeRange(loc,len)];
    attributedLabel.attributedText = attributedStr;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(24);
        make.width.mas_offset(93);
        make.height.mas_offset(93);
        make.centerX.equalTo(weakSelf);
    }];
    
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf.topImg.mas_bottom).with.offset(20);
    }];
    
}

#pragma mark - getters

-(UIImageView *)topImg
{
    if(!_topImg)
    {
        _topImg = [[UIImageView alloc] init];
        _topImg.image = [UIImage imageNamed:@"推顶大火箭"];
    }
    return _topImg;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.font = [UIFont systemFontOfSize:16];
        _contentLab.textColor = [UIColor blackColor];
    }
    return _contentLab;
}

@end
