//
//  FollowMessageCell.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/9/28.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowMessageModel.h"

@interface FollowMessageCell : UITableViewCell

+(instancetype)cellWithFollowMessageCell:(UITableView *)tableView;

@property (nonatomic,strong) FollowMessageModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
