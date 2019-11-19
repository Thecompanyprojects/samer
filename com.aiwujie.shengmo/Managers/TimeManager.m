//
//  TimeManager.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/15.
//  Copyright © 2019 a. All rights reserved.
//

#import "TimeManager.h"

@implementation TimeManager

//单例类的静态实例对象，因对象需要唯一性，故只能是static类型

static TimeManager *defaultTool = nil;

//单例模式对外的唯一接口，用到的dispatch_once函数在一个应用程序内只会执行一次，且dispatch_once能确保线程安全

+(TimeManager*)defaultTool{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (defaultTool == nil) {
            
            defaultTool = [[self alloc] init];
        }
    });
    
    return defaultTool;
}

//覆盖该方法主要确保当用户通过[[Singleton alloc] init]创建对象时对象的唯一性，alloc方法会调用该方法，只不过zone参数默认为nil，因该类覆盖了allocWithZone方法，所以只能通过其父类分配内存，即[super allocWithZone:zone]

+(id)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (defaultTool == nil) {
            defaultTool = [super allocWithZone:zone];
        }
    });
    
    return defaultTool;
}

//自定义初始化方法
-(instancetype)init{
    
    if (self = [super init]) {
        
    }
    return self;
}

//覆盖该方法主要确保当用户通过copy方法产生对象时对象的唯一性
-(id)copy{
    
    return self;
}

//覆盖该方法主要确保当用户通过mutableCopy方法产生对象时对象的唯一性
-(id)mutableCopy{
    return self;
}

#pragma mark --通过时间戳得到日期字符串
-(NSString*)getDateFormatStrFromTimeStamp:(NSString*)timeStamp{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

- (NSString*)getDateFormatStrFromTimeStampWithSeconds:(NSString*)timeStamp {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

- (NSString*)getDateFormatStrFromTimeStampWithMin:(NSString*)timeStamp {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

- (NSString*)newgetDateFormatStrFromTimeStampWithMin:(NSString*)timeStamp {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"MM月dd日HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

-(NSString *)getNowTimeTimestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

@end
