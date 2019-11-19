//
//  mymessageContent.h
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/27.
//  Copyright © 2019 a. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import <RongIMLib/RCMessageContentView.h>
NS_ASSUME_NONNULL_BEGIN
//这个是自定义消息的标识符，和安卓端对接用的
#define RCLocalMessageTypeIdentifier @"App:SimpleMsg"
@interface mymessageContent : RCMessageContent<NSCoding,RCMessageContentView>
//下面这两个是我们发送消息对应我们需要的键
@property(nonatomic,strong) NSString *content;
@property(nonatomic, strong) NSString* extra;
+(instancetype)messageWithContent:(NSString *)content;
@end


NS_ASSUME_NONNULL_END
