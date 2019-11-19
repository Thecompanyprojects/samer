//
//  XYgiftMessageContent.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/28.
//  Copyright © 2019 a. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

NS_ASSUME_NONNULL_BEGIN
/**
 群聊部分 发送礼物 自定义消息model方法
 */
@interface XYgiftMessageContent : RCMessageContent
@property (copy) NSString *imageName;
@property (copy) NSString *number;
@property (nonatomic,copy) NSString *orderid;
+ (instancetype)messageWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
