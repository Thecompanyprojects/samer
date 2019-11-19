//
//  FollowMessageCell.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/9/28.
//  Copyright © 2017年 a. All rights reserved.
//

#import "FollowMessageCell.h"

@implementation FollowMessageCell

+(instancetype)cellWithFollowMessageCell:(UITableView *)tableView{

    FollowMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowMessage"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FollowMessageCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setModel:(FollowMessageModel *)model{

    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.head_pic]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.nickNameLabel.text = model.nickname;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.addtime];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headImageView.layer.cornerRadius = 25;
    self.headImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
