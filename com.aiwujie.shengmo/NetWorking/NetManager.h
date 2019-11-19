//
//  NetManager.h
//  ShiXiNetwork
//
//  Created by Karl on 16/5/31.
//  Copyright © 2016年 Shixi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
typedef void (^RequestFinishedBlock)(id responseObj);
typedef void (^RequestFailedBlock)(NSString *errorMsg);

@interface NetManager : NSObject

//封装AFNetWorking的get请求逻辑
+(void)requestDataWithUrlString:(NSString *)urlString contentType:(NSString *)type finished:(RequestFinishedBlock)finishedBlock
                         failed:(RequestFailedBlock)failedBlock;

+ (void)afPostRequest:(NSString *)urlString parms:(NSDictionary *)dic finished:(RequestFinishedBlock)finishedBlock failed:(RequestFailedBlock)failedBlock;

+ (void)afGetRequest:(NSString *)urlString parms:(NSDictionary *)dic finished:(RequestFinishedBlock)finishedBlock failed:(RequestFailedBlock)failedBlock;

/**图片上传*/
+(void)uploadImages:(NSString *)url
              images:(NSArray *)images
          parameters:(id)parameters
            progress:(void(^)(NSProgress *progress))progress
             success:(void(^)(id responseObject))success
             failure:(void(^)(NSError *error))failure;


+ (void)SetCalcaultorRequest:(NSString *)urlString parms:(id )dicData finished:(RequestFinishedBlock)finishedBlock failed:(RequestFailedBlock)failedBlock;


+ (void)uploadTaskImages:(NSArray <UIImage *>*)imageList completeBlock:(void(^)(NSArray *imageNameList, BOOL succ))block;

@end
