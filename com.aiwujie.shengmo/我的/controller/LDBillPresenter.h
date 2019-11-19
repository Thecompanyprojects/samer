//
//  LDBillPresenter.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/3.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LDBillPresenter : NSObject

/**
 获取我的魔豆信息

 @param success 成功
 @param failure 失败
 */
+(void)requestsuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure;

/**
    存储剩余魔豆数量
 */
+(void)savewakketNum;
@end

NS_ASSUME_NONNULL_END
