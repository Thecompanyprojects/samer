//
//  LDFromwebManager.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/8.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDFromwebManager.h"
#import <sys/utsname.h>
#import "LDMainTabViewController.h"
#import <UIKit/UIKit.h>

@implementation LDFromwebManager

//单例类的静态实例对象，因对象需要唯一性，故只能是static类型

static LDFromwebManager *defaultTool = nil;

//单例模式对外的唯一接口，用到的dispatch_once函数在一个应用程序内只会执行一次，且dispatch_once能确保线程安全

+(LDFromwebManager*)defaultTool{
    
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

//上传实时位置
-(void)createDataLat
{
    NSString *lat = [[NSUserDefaults standardUserDefaults] objectForKey:latitude];
    NSString *lng = [[NSUserDefaults standardUserDefaults] objectForKey:longitude];
    
    CGFloat flatlat = [lat floatValue];
    CGFloat flatlnt = [lng floatValue];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,setLogintimeAndLocationUrl];
    
    NSDictionary *parameters;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"province"] length] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"province"];
            
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"city"] length] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"city"];
            
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"addr"] length] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"addr"];
            
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:latitude] length] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:latitude];
            
            lat = 0;
            
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:longitude] length] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:longitude];
            
            lng = 0;
            
        }
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[NSString stringWithFormat:@"%lf",flatlat],@"lng":[NSString stringWithFormat:@"%lf",flatlnt],@"city":[[NSUserDefaults standardUserDefaults] objectForKey:@"city"],@"addr":[[NSUserDefaults standardUserDefaults] objectForKey:@"addr"],@"province":[[NSUserDefaults standardUserDefaults] objectForKey:@"province"]};
        
    }else{
        
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@"",@"city":@"",@"addr":@"",@"province":@""};
    }
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        
    } failed:^(NSString *errorMsg) {
        
    }];
    
}


/**
 写入浏览记录
 */
-(void)recordComerDatawith:(NSString *)userId;
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"writeVisitRecord"] length] != 0){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval interval = - [[formatter dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"writeVisitRecord"]] timeIntervalSinceNow];
        if (interval >= 5) {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"writeVisitRecord"];
        }

    }else{
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,writeVisitRecordUrl];
        NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":userId};
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
            if (integer == 2000) {
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                [[NSUserDefaults standardUserDefaults] setObject:[formatter stringFromDate:date] forKey:@"writeVisitRecord"];
            }
        } failed:^(NSString *errorMsg) {

        }];
    }
}

/**
 各种红点获取数据
 */
-(void)createRedlab
{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getRedDutNumUrl];
    NSDictionary *parameters;
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]?:@""};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (integer == 2000){
            //动态索引
            if ([responseObj[@"data"][@"allNum"] integerValue]>0) {
                NSString *allNum = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"allNum"]];
                [[NSUserDefaults standardUserDefaults] setObject:allNum forKey:@"disallnum"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    LDMainTabViewController *mt=(LDMainTabViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
//                    UITabBarItem * item=[mt.tabBar.items objectAtIndex:1];
//                    NSInteger badge = [allNum integerValue];
//                    if (badge <= 0) {
//                        item.badgeValue = 0;
//                    }else{
//                        item.badgeValue = [NSString stringWithFormat:@"%ld",(long)badge];
//                    }
                    [mt.tabBar showBadgeOnItemIndex:1];
                });
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"disallnum"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    LDMainTabViewController *mt=(LDMainTabViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
//                    UITabBarItem * item=[mt.tabBar.items objectAtIndex:1];;
//                    item.badgeValue = 0;
                    [mt.tabBar hideBadgeOnItemIndex:1];
                });
            }
            
            //推顶
            if ([responseObj[@"data"][@"dyTopNum"] integerValue]>0) {
                
                NSString *dynum = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"dyTopNum"]];
                [[NSUserDefaults standardUserDefaults] setObject:dynum forKey:@"dyTopNum"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dyTopNum" object:nil];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"dyTopNum"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dyTopNum" object:nil];
            }
            
            if ([responseObj[@"data"][@"dynamic"] integerValue] > 0) {
                
                [[NSUserDefaults standardUserDefaults] setObject:responseObj[@"data"][@"dynamic"] forKey:@"dynamicBadge"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dynamicBadge" object:nil];
                
            }else{
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"dynamicBadge"];
            }
            
            if ([responseObj[@"data"][@"groupNum"] integerValue] > 0) {
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"groupNum"]] forKey:@"groupBadge"];
                //有新建群
                [[NSNotificationCenter defaultCenter] postNotificationName:@"groupBadge" object:nil];
            }else{
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"groupBadge"];
                //没有新建群
                [[NSNotificationCenter defaultCenter] postNotificationName:@"groupBadge1" object:nil];
            }
            
            if ([responseObj[@"data"][@"newRegerNum"] integerValue] > 0) {
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"newRegerNum"]] forKey:@"newestBadge"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newestBadge" object:nil userInfo:nil];
                
            }else{
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"newestBadge"];
            }
            
            if ([responseObj[@"data"][@"followDyNum"] integerValue] > 0) {
                
                [[NSUserDefaults standardUserDefaults] setObject:responseObj[@"data"][@"followDyNum"] forKey:@"followBadge"];
                
            }else{
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"followBadge"];
                
            }
            //推荐
            if ([responseObj[@"data"][@"dyRecommendNum"] integerValue] > 0) {
                
                NSString *dynum = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"dyRecommendNum"]];
                [[NSUserDefaults standardUserDefaults] setObject:dynum forKey:@"dyRecommendNum"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dynamicBadge" object:nil];
                
            }else{
                
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"dyRecommendNum"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dynamicBadge" object:nil];
            }
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}


/**
 大喇叭红点获取
 */
-(void)getloudspeakersRed
{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getBigPresentNumUrl];
    NSDictionary *parameters;
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};

    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];

        if (integer == 3001){
            NSDictionary *dict = [responseObj objectForKey:@"data"];

            NSString *giftnum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"giftnum"]];
            NSString *topcardnum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"topcardnum"]];
            NSString *vipnum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"vipnum"]];
            NSString *allnum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"allnum"]];

            [[NSUserDefaults standardUserDefaults] setObject:giftnum forKey:@"redgiftnum"];
            [[NSUserDefaults standardUserDefaults] setObject:topcardnum forKey:@"redtopcardnum"];
            [[NSUserDefaults standardUserDefaults] setObject:vipnum forKey:@"redvipnum"];
            [[NSUserDefaults standardUserDefaults] setObject:allnum forKey:@"redallnum"];

        }else if (integer == 3002){
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"redgiftnum"];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"redtopcardnum"];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"redvipnum"];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"redallnum"];
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loudspeakers" object:nil];

    } failed:^(NSString *errorMsg) {

    }];
}

-(NSString *)getCurrentDeviceModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceModel;
}

- (UIViewController *)findCurrentViewController
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}


@end
