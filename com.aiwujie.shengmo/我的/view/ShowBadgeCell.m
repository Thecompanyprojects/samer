//
//  ShowBadgeCell.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/3/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import "ShowBadgeCell.h"

@implementation ShowBadgeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.badgeLabel.layer.cornerRadius = 10;
    self.badgeLabel.clipsToBounds = YES;
    self.headView.layer.masksToBounds = YES;
    self.headView.layer.cornerRadius = 6;
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(18);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
