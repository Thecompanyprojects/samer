//
//  StampCell.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/24.
//  Copyright © 2017年 a. All rights reserved.
//

#import "StampCell.h"

@implementation StampCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.completeLabel.layer.borderWidth = 1;
    self.completeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.completeLabel.layer.cornerRadius = 2;
    self.completeLabel.clipsToBounds = YES;
    
    self.goButton.layer.borderWidth = 1;
    self.goButton.layer.borderColor = [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1].CGColor;
    self.goButton.layer.cornerRadius = 2;
    self.goButton.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
