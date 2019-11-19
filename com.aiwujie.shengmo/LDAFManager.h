//
//  LDAFManager.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/8/24.
//  Copyright © 2017年 a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface LDAFManager : NSObject

/**
 * 数据请求类初始化,返回json格式的数据
 */
+ (AFHTTPSessionManager *)sharedManager;

/**
 * 数据请求类初始化,返回data格式的数据
 */
+ (AFHTTPSessionManager *)sharedDataManager;

/**
 * 入参数据流(兑换vip和svip,邮票的数据请求)
 */
+ (void)postDataWithDictionary:(NSDictionary *)parameters andUrlString:(NSString *)urlString success:(void (^)(NSString *msg))success fail:(void (^)(NSString *errorMsg))fail;

@end
