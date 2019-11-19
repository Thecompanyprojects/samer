//
//  addView.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/5.
//  Copyright © 2019 a. All rights reserved.
//

#import "addView.h"

@interface addView()

@end

@implementation addView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.leftLab];
        [self addSubview:self.addText];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(40);
    }];
    [weakSelf.addText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.left.equalTo(weakSelf.leftLab.mas_right);
    }];
}

#pragma mark - getters

-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.font = [UIFont systemFontOfSize:14];
        _leftLab.textColor = TextCOLOR;
    }
    return _leftLab;
}

-(UITextField *)addText
{
    if(!_addText)
    {
        _addText = [[UITextField alloc] init];
        _addText.textColor = TextCOLOR;
//        UIFont * font = [UIFont boldSystemFontOfSize:13];
//        [_addText setValue:font forKeyPath:@"_placeholderLabel.font"];
        _addText.font = [UIFont systemFontOfSize:13];
    }
    return _addText;
}



@end
