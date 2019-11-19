//
//  AtCell.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/4.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtModel.h"

@interface AtCell : UITableViewCell

@property (nonatomic,strong) AtModel *model;
@property (nonatomic,strong) UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ccomentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ccomentView;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIImageView *vipView;
@property (weak, nonatomic) IBOutlet UIButton *lookDynamicButton;

@end
