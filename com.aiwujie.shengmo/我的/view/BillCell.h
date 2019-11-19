//
//  BillCell.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/12.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BillModel.h"

@interface BillCell : UITableViewCell

@property (nonatomic,strong) BillModel *model;


@property (nonatomic,copy) NSString *type;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *beanLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end
