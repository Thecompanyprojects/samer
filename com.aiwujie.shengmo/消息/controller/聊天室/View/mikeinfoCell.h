//
//  mikeinfoCell.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/9/15.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chatmikeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface mikeinfoCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) chatmikeModel *model;
@property (nonatomic,strong) NSMutableArray *talkArray;
@end

NS_ASSUME_NONNULL_END
