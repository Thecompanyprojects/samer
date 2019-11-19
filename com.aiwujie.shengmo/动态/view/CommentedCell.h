//
//  CommentedCell.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/24.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentedModel.h"

@interface CommentedCell : UITableViewCell

@property (nonatomic,copy) NSString *type;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) CommentedModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *ccomentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ccomentView;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIImageView *vipView;
@property (weak, nonatomic) IBOutlet UIButton *lookDynamicButton;

@end
