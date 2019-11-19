//
//  LHRichMessageContent.h
//  RongIMDemo
//
//  Created by Bryan Yuan on 12/13/16.
//  Copyright © 2016 Bryan Yuan. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

/**
 单聊部分 发送礼物 自定义消息model方法
 */
@interface XYRichMessageContent : RCMessageContent

@property (copy) NSString *imageName;
@property (copy) NSString *number;

+ (instancetype)messageWithDict:(NSDictionary *)dict;

@end
