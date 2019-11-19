//
//  LDBillPresenter.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/3.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDBillPresenter.h"

@implementation LDBillPresenter

+(void)requestsuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    
    NSString *urls = [NSString stringWithFormat:@"%@%@",PICHEADURL,getmywalletUrl];
    
    NSDictionary *parameter = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:urls parms:parameter finished:^(id responseObj) {
        [[NSUserDefaults standardUserDefaults] setObject:responseObj[@"data"][@"wallet"] forKey:@"walletNum"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        success(responseObj);
       
    } failed:^(NSString *errorMsg) {
        failure(errorMsg);
    }];
}

+(void)savewakketNum
{
    NSString *urls = [NSString stringWithFormat:@"%@%@",PICHEADURL,getmywalletUrl];
    NSDictionary *parameter = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:urls parms:parameter finished:^(id responseObj) {
        [[NSUserDefaults standardUserDefaults] setObject:responseObj[@"data"][@"wallet"] forKey:@"walletNum"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    } failed:^(NSString *errorMsg) {
        
    }];
}


@end
