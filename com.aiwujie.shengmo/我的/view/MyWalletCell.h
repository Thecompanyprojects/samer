//
//  MyWalletCell.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWalletModel.h"

@interface MyWalletCell : UICollectionViewCell

@property (nonatomic,strong) MyWalletModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UILabel *gifNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gifValue;
@property (weak, nonatomic) IBOutlet UILabel *gifNumLabel;

@end
