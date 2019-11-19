//
//  XYgiftgroupMessageCell.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/28.
//  Copyright © 2019 a. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 群聊部分 发送礼物 自定义消息cell
 */

@interface XYgiftgroupMessageCell : RCMessageCell
@property UIImageView *imageView;
@property UILabel *titleLabel;
@property UILabel *detailLabel;
@end

NS_ASSUME_NONNULL_END
