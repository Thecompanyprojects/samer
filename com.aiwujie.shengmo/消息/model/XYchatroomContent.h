//
//  XYchatroomContent.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/2.
//  Copyright © 2019 a. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYchatroomContent : RCMessageContent<NSCoding>
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *head_pic;
+ (instancetype)messageWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
