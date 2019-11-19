//
//  GroupAtPersonCell.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/11.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupMemberListModel.h"

@interface GroupAtPersonCell : UITableViewCell

@property (nonatomic,strong) GroupMemberListModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@end
