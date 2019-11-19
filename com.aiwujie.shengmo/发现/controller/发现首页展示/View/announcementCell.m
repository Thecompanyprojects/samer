//
//  announcementCell.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/18.
//  Copyright © 2019 a. All rights reserved.
//

#import "announcementCell.h"

@interface announcementCell()
@property (nonatomic,strong) UILabel *pointView;
@property (nonatomic,strong) UILabel *messageLab;
@property (nonatomic,strong) UIImageView *infoImg;
@end

@implementation announcementCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.pointView];
        [self.contentView addSubview:self.messageLab];
        [self.contentView addSubview:self.infoImg];
        [self setuplayout];
    }
    return self;
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
    
    [weakSelf.infoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-15);
        make.width.mas_offset(120);
        make.height.mas_offset(80);
        make.centerY.equalTo(weakSelf);
    }];
    
    [weakSelf.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.top.equalTo(weakSelf.infoImg).with.offset(5);
        make.left.equalTo(weakSelf.pointView.mas_right).with.offset(3);
        make.right.equalTo(weakSelf.infoImg.mas_left).with.offset(-15);
    }];
    
}

- (void)setModel:(announcementModel *)model
{
    self.messageLab.text = model.title?:@"";
    [self.infoImg sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
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

-(UIImageView *)infoImg
{
    if(!_infoImg)
    {
        _infoImg = [[UIImageView alloc] init];
        
    }
    return _infoImg;
}




@end
