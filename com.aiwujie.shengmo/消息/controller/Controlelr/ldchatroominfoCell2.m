//
//  ldchatroominfoCell2.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/9/17.
//  Copyright © 2019 a. All rights reserved.
//

#import "ldchatroominfoCell2.h"

@interface ldchatroominfoCell2()

@end

@implementation ldchatroominfoCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftBtn];
        [self.contentView addSubview:self.rightBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setdata
{
    if ([self.mictype intValue]==1) {
        [self.leftBtn setImage:[UIImage imageNamed:@"照片认证实圈"] forState:normal];
        [self.rightBtn setImage:[UIImage imageNamed:@"照片认证空圈"] forState:normal];
    }
    else
    {
        [self.leftBtn setImage:[UIImage imageNamed:@"照片认证空圈"] forState:normal];
        [self.rightBtn setImage:[UIImage imageNamed:@"照片认证实圈"] forState:normal];
    }
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.width.mas_offset(WIDTH/2);
    }];
    [weakSelf.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.width.mas_offset(WIDTH/2);
    }];
}

#pragma mark- getters

-(UIButton *)leftBtn
{
    if(!_leftBtn)
    {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setTitle:@"自由麦序" forState:normal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_leftBtn setTitleColor:TextCOLOR forState:normal];
        [_leftBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        
    }
    return _leftBtn;
}

-(UIButton *)rightBtn
{
    if(!_rightBtn)
    {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitle:@"指定麦序" forState:normal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBtn setTitleColor:TextCOLOR forState:normal];
        [_rightBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    }
    return _rightBtn;
}




@end
