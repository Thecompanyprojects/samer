//
//  GroupAtPersonCell.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/11.
//  Copyright © 2017年 a. All rights reserved.
//

#import "GroupAtPersonCell.h"


@implementation GroupAtPersonCell

-(void)setModel:(GroupMemberListModel *)model{
    _model = model;
    [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.head_pic]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.headView.contentMode = UIViewContentModeScaleAspectFill;
    if (model.cardname.length!=0) {
        self.nicknameLabel.text = model.cardname;
    }
    else
    {
        self.nicknameLabel.text = model.nickname;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headView.layer.cornerRadius = 18;
    self.headView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
