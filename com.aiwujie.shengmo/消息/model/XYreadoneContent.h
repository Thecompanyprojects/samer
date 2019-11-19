//
//  XYreadoneContent.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/3.
//  Copyright © 2019 a. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

NS_ASSUME_NONNULL_BEGIN

/**
 阅后即焚功能content部分
 */
@interface XYreadoneContent : RCMessageContent<NSCoding>
@property (copy) NSString *imageUrl;
@property (copy) NSString *isopen;
+ (instancetype)messageWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
