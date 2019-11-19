//
//  LDAFManager.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/8/24.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDAFManager.h"

@implementation LDAFManager

/**
 * 数据请求类初始化,返回json格式的数据
 */
+ (AFHTTPSessionManager *)sharedManager {
    
    static AFHTTPSessionManager *manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [AFHTTPSessionManager manager];
//        manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain", nil];
    });
    
    return manager;
}

/**
 * 数据请求类初始化,返回data格式的数据
 */
+ (AFHTTPSessionManager *)sharedDataManager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain", nil];
    });
    return manager;
}

/**
 * 入参数据流(兑换vip和svip,邮票的数据请求)
 */
+ (void)postDataWithDictionary:(NSDictionary *)parameters andUrlString:(NSString *)urlString success:(void (^)(NSString *msg))success fail:(void (^)(NSString *errorMsg))fail{
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
    NSData *da = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *bodyData = [[NSString alloc] initWithData:da encoding:NSUTF8StringEncoding];
    
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSDictionary *responseObject = [NSObject parseJSONStringToNSDictionary:result];
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
            
            if (integer == 5000 || integer == 3000 || integer == 3002) {
                
                if (success) {
                    
                    success(responseObject[@"msg"]);
                }
                
            }else if(integer == 2000){
                
                if (success) {
                    
                    success(@"兑换成功");
                }
                
            }else{
                
                if (fail) {
                    
                    fail(@"兑换失败");
                }
            }
        });
    }];
}


@end
