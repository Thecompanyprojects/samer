//
//  GiveGifCell.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiveGifModel.h"

@interface GiveGifCell : UITableViewCell
@property (nonatomic,assign) BOOL isTopcard;

@property (nonatomic,strong) GiveGifModel *model;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIImageView *giveImageView;
@property (weak, nonatomic) IBOutlet UIImageView *givenImageView;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UIImageView *connectImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *giveButton;
@property (weak, nonatomic) IBOutlet UIButton *givenButton;

@end
