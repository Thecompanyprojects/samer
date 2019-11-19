
//
//  sendredsCell1.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/28.
//  Copyright © 2019 a. All rights reserved.
//

#import "sendredsCell1.h"

@interface sendredsCell1()
@property (nonatomic,strong) UIView *bgView;

@end

@implementation sendredsCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE" alpha:1];
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.messageText];
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
    [weakSelf.messageText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView).with.offset(20);
        make.top.equalTo(weakSelf.bgView).with.offset(20);
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
    }];
}

#pragma mark - getters

-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 8;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

-(UITextField *)messageText
{
    if(!_messageText)
    {
        _messageText = [[UITextField alloc] init];
        _messageText.textAlignment = NSTextAlignmentLeft;
        _messageText.placeholder = @"恭喜发财，大吉大利";
        _messageText.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _messageText;
}






@end

