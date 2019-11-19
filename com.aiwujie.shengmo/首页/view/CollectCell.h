//
//  CollectCell.h
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/23.
//  Copyright © 2016年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectModel.h"

@interface CollectCell : UICollectionViewCell

@property (nonatomic,strong) CollectModel *model;

@property (nonatomic,assign) NSInteger integer;
@property (nonatomic,copy) NSString *typeStr;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipView;
@property (weak, nonatomic) IBOutlet UIImageView *handleView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *idImageView;
@property (weak, nonatomic) IBOutlet UIView *aSexView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIView *layerView;

@end
