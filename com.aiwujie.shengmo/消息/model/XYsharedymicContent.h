//
//  XTsharedymicContent.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/29.
//  Copyright © 2019 a. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYsharedymicContent : RCMessageContent<NSCoding>

@property (copy) NSString *Newid;
@property (copy) NSString *content;
@property (copy) NSString *icon;
@property (copy) NSString *userId;
+ (instancetype)messageWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
