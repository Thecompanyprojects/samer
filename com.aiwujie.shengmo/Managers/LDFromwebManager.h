//
//  LDFromwebManager.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/8.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LDFromwebManager : NSObject

+(LDFromwebManager*)defaultTool;

/**
 上传实时位置
 */
-(void)createDataLat;


/**
  查询小红点
 */
-(void)createRedlab;


/**
 写入浏览记录
 */
-(void)recordComerDatawith:(NSString *)userId;


/**
 获取大喇叭红点
 */
-(void)getloudspeakersRed;

/**
 获取手机设备

 @return 手机设备名称
 */
-(NSString *)getCurrentDeviceModel;


/**
 获取当前控制器

 @return 当前VC
 */
- (UIViewController *)findCurrentViewController;
@end

NS_ASSUME_NONNULL_END
