//
//  XYredMessageContent.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/28.
//  Copyright © 2019 a. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYredMessageContent : RCMessageContent<NSCoding>

@property(nonatomic, copy) NSString *isopen;
@property (copy) NSString *message;
@property (nonatomic,copy) NSString *orderid;
+ (instancetype)messageWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
