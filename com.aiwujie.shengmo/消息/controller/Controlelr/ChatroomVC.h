//
//  ChatroomVC.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/24.
//  Copyright © 2019 a. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^PopStringBlock)(NSString *popString);
@interface ChatroomVC : RCConversationViewController
@property(nonatomic, copy) PopStringBlock popBlock;
//聊吧信息
@property (nonatomic,strong) NSDictionary *infoDic;

@property (nonatomic,strong) void (^myBlock)(NSDictionary *dic);

@property (nonatomic,copy) NSString *roomidStr;
@end

NS_ASSUME_NONNULL_END
