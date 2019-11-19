//
//  chatpersonCell.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/31.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chatpersonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface chatpersonCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) chatpersonModel *model;
@end

NS_ASSUME_NONNULL_END
