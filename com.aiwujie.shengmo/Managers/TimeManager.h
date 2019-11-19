//
//  TimeManager.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/15.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeManager : NSObject
+(TimeManager*)defaultTool;
#pragma mark --通过时间戳得到日期字符串
-(NSString*)getDateFormatStrFromTimeStamp:(NSString*)timeStamp;
-(NSString*)getDateFormatStrFromTimeStampWithSeconds:(NSString*)timeStamp;
-(NSString*)getDateFormatStrFromTimeStampWithMin:(NSString*)timeStamp;
-(NSString*)newgetDateFormatStrFromTimeStampWithMin:(NSString*)timeStamp;
/**
 获取当前时间戳

 @return 时间戳 秒
 */
-(NSString *)getNowTimeTimestamp;
@end

NS_ASSUME_NONNULL_END
