//
//  GroupSqureCell.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/15.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupSqureModel.h"

@interface GroupSqureCell : UITableViewCell

@property (nonatomic,strong) GroupSqureModel *model;
@property (nonatomic,copy) NSString *integer;

@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupMemberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *distanceImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupIntroduceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *groupVipView;

@end
