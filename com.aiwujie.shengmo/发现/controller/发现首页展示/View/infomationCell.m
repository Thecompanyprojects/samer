//
//  infomationCell.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/18.
//  Copyright © 2019 a. All rights reserved.
//

#import "infomationCell.h"

@interface infomationCell()
@property (nonatomic,strong) UILabel *pointView;
@property (nonatomic,strong) UILabel *messageLab;
@end

@implementation infomationCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.pointView];
        [self.contentView addSubview:self.messageLab];
        [self setuplayout];
    }
    return self;
}

-(void)setModel:(announcementModel *)model
{
    self.messageLab.text = model.title?:@"";
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(15);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(8);
        make.height.mas_offset(8);
    }];
    [weakSelf.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.pointView.mas_right).with.offset(3);
        make.right.equalTo(weakSelf).with.offset(-15);
        make.centerY.equalTo(weakSelf);
        
    }];
}

#pragma mark - getters

-(UILabel *)pointView
{
    if(!_pointView)
    {
        _pointView = [[UILabel alloc] init];
        _pointView.textColor = MainColor;
        _pointView.text = @"●";
        _pointView.font = [UIFont systemFontOfSize:8];
    }
    return _pointView;
}

-(UILabel *)messageLab
{
    if(!_messageLab)
    {
        _messageLab = [[UILabel alloc] init];
        _messageLab.numberOfLines = 0;
        _messageLab.font = [UIFont systemFontOfSize:15];
        _messageLab.textColor = TextCOLOR;
    }
    return _messageLab;
}




@end
