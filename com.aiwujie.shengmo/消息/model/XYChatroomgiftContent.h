//
//  XYChatroomgiftContent.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/9/19.
//  Copyright © 2019 a. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYChatroomgiftContent : RCMessageContent<NSCoding>


@property (nonatomic,copy) NSString *msgtext;
@property (nonatomic,copy) NSString *sendtype;
@property (nonatomic,copy) NSString *giftname;
+ (instancetype)messageWithDict:(NSDictionary *)dict;


@end

NS_ASSUME_NONNULL_END
