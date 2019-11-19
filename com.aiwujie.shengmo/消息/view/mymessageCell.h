//
//  mymessageCell.h
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/27.
//  Copyright © 2019 a. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface mymessageCell : RCMessageCell
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;
@property(nonatomic, strong) UIImageView *contentImageView;

@property(nonatomic, strong) UILabel *titleNameLabel;

@property(nonatomic, strong) UILabel *priceLabel;
- (void)setDataModel:(RCMessageModel *)model;
- (void)initialize;
@end

NS_ASSUME_NONNULL_END
