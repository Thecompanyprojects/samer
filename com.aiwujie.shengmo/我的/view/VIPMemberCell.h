//
//  VIPMemberCell.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/11/21.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPMemberModel.h"

@interface VIPMemberCell : UITableViewCell

@property (nonatomic,strong) VIPMemberModel *model;

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldProceLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end
