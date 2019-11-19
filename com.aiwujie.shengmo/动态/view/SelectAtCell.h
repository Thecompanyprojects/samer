//
//  SelectAtCell.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/3.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableModel.h"
#import "atselectModel.h"

@interface SelectAtCell : UITableViewCell

@property (nonatomic,strong) TableModel *model;
@property (nonatomic,strong) UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameW;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *idImageView;
@property (weak, nonatomic) IBOutlet UILabel *sexualLabel;
@property (weak, nonatomic) IBOutlet UIView *aSexView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idViewW;

@property (weak, nonatomic) IBOutlet UIImageView *selectView;

@end
