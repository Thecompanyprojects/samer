//
//  TableCell.h
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/24.
//  Copyright © 2016年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableModel.h"

@interface TableCell : UITableViewCell

@property (nonatomic,copy) NSString *typeStr;

@property (nonatomic,strong) TableModel *model;
@property (nonatomic,strong) UIView *lineView;
//展示哪个数据
@property (nonatomic,copy) NSString *type;

//来自哪个页面
@property (nonatomic,copy) NSString *content;

//根据此属性来判断是否显示距离
@property (nonatomic,assign) NSInteger integer;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameW;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *idImageView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexualLabel;
@property (weak, nonatomic) IBOutlet UIView *aSexView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idViewW;

//添加财富和魅力值的显示
@property (weak, nonatomic) IBOutlet UIView *wealthView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wealthW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wealthSpace;
@property (weak, nonatomic) IBOutlet UILabel *wealthLabel;
@property (weak, nonatomic) IBOutlet UIView *charmView;
@property (weak, nonatomic) IBOutlet UILabel *charmLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *charmW;

@property (nonatomic,assign) BOOL isfromguanzhu;
@end
