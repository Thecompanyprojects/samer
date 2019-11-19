//
//  sendredsCell0.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/28.
//  Copyright © 2019 a. All rights reserved.
//

#import "sendredsCell0.h"

@interface sendredsCell0()
@property (nonatomic,strong) UIView *bgView;
@end

@implementation sendredsCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE" alpha:1];
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.numberText];
        [self.contentView addSubview:self.rightLab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(20);
        make.top.equalTo(weakSelf).with.offset(18);
    }];
    
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView).with.offset(15);
        make.centerY.equalTo(weakSelf);
        
    }];
    [weakSelf.rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView).with.offset(-20);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(60);
    }];
    [weakSelf.numberText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf.rightLab.mas_left);
        make.left.equalTo(weakSelf.leftLab.mas_right);
    }];
 
}

#pragma mark - getters

-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [UIView new];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 8;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}


-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.textColor = TextCOLOR;
        _leftLab.font = [UIFont systemFontOfSize:14];
    }
    return _leftLab;
}

-(UITextField *)numberText
{
    if(!_numberText)
    {
        _numberText = [[UITextField alloc] init];
        _numberText.textAlignment = NSTextAlignmentRight;
        _numberText.keyboardType = UIKeyboardTypeNumberPad;
        _numberText.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _numberText;
}

-(UILabel *)rightLab
{
    if(!_rightLab)
    {
        _rightLab = [[UILabel alloc] init];
        _rightLab.textAlignment = NSTextAlignmentRight;
        _rightLab.textColor = TextCOLOR;
        _rightLab.font = [UIFont systemFontOfSize:14];
    }
    return _rightLab;
}





@end
