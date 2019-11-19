//
//  ShowBadgeCell.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/3/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowBadgeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *youjiantou;

@end
