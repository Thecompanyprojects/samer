//
//  ApplyGroupCell.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/18.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyGroupModel.h"

@interface ApplyGroupCell : UITableViewCell

+(instancetype)cellWithApplyCell:(UITableView *)tableView;

@property (nonatomic,strong) ApplyGroupModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (nonatomic,strong) UILabel *chooseLab;
@end
