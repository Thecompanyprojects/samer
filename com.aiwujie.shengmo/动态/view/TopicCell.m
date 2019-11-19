//
//  TopicCell.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/7/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import "TopicCell.h"

@implementation TopicCell

-(void)setModel:(TopicModel *)model{
    _model = model;
    [self.topicImageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
    
    self.topicLabel.text = [NSString stringWithFormat:@"#%@#",model.title];
    self.topicLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    self.topicLabel.textColor = TextCOLOR;

    self.topicIntroduceLabel.text = [NSString stringWithFormat:@"%@",model.introduce];
    self.topicJoinLabel.text = [NSString stringWithFormat:@"%@参与",model.partaketimes];
    self.topicDynamicLabel.text = [NSString stringWithFormat:@"%@动态",model.dynamicnum];
    self.topicImageView.layer.masksToBounds = YES;
    self.topicImageView.layer.cornerRadius = 10;
    
}

- (IBAction)tapHeadImageView:(id)sender {
    if (self.topicBlock) {
        self.topicBlock(self.topicImageView.image);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
