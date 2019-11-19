//
//  LHRichMessageCell.h
//  RongIMDemo
//
//  Created by Bryan Yuan on 12/15/16.
//  Copyright © 2016 Bryan Yuan. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>


/**
 单聊部分 发送礼物 自定义消息cell
 */
@interface XYRichMessageCell : RCMessageCell

@property UIImageView *imageView;
@property UILabel *titleLabel;
@property UILabel *detailLabel;

@end
