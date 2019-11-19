//
//  GroupSqureCell.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/15.
//  Copyright © 2017年 a. All rights reserved.
//

#import "GroupSqureCell.h"

@implementation GroupSqureCell

-(void)setModel:(GroupSqureModel *)model{

    _model = model;
    [self.groupImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.group_pic]] placeholderImage:[UIImage imageNamed:@"群默认头像"]];
    self.groupVipView.contentMode = UIViewContentModeScaleAspectFill;
    self.groupNameLabel.text = model.groupname;
    self.groupMemberLabel.text = [NSString stringWithFormat:@"%@人",model.member];
    if ([self.integer intValue] == 2001){
        self.groupDistanceLabel.hidden = YES;
        self.distanceImageView.hidden = YES;
    } else{
        self.groupDistanceLabel.text = [NSString stringWithFormat:@"%@km",model.distance];
    }
    self.groupIntroduceLabel.text = model.introduce;
    if (model.group_num.length <= 5) {
        self.groupVipView.hidden = NO;
    }else{
        self.groupVipView.hidden = YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.groupImageView.layer.cornerRadius = 25;
    self.groupImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
