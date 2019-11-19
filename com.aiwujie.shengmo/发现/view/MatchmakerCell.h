//
//  MatchmakerCell.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/8/16.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchmakerModel.h"

@interface MatchmakerCell : UICollectionViewCell

@property (nonatomic,strong) MatchmakerModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *idImageView;
@property (weak, nonatomic) IBOutlet UIView *ageSexView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexualLabel;
@property (weak, nonatomic) IBOutlet UIView *cityView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityW;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end
