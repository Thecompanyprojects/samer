//
//  wangHeader.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/11.
//  Copyright © 2019 a. All rights reserved.
//

#ifndef wangHeader_h
#define wangHeader_h

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height

//16进制转rgb颜色的宏定义
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
////软件的版本号设置
//获取设备的系统版本
#define PHONEVERSION [[UIDevice currentDevice] systemVersion]
//判断设备是否是iPhone X
#define ISIPHONEX [UIScreen mainScreen].bounds.size.height == 812 ? 1 : 0
//判断是否是iPhone p
#define ISIPHONEPLUS [UIScreen mainScreen].bounds.size.height == 736 ? 1 : 0
//iPhone X 顶部导航距离
#define IPHONEXTOPH 88
//iPhone X 底部触碰区距离
#define IPHONEXBOTTOMH 34
//融云客服的id
#define SERVICE_ID @"KEFU148492045558421"

//测试服务器
//#define PICHEADURL  @"http://cs.shengmo.org/"

//正式服务器
#define HTTPPICHEADURL  @"http://aiwujie.com.cn/"

//#define PICHEADURL  @"http://aiwujie.com.cn/"

#define PICHEADURL  @"http://47.93.194.65:888/"


//微博的key和url
#define kAppKey         @"1601897348"
#define kRedirectURI    @"https://api.weibo.com/oauth2/default.html"
//定义广告栏的比例
#define ADVERTISEMENT [UIScreen mainScreen].bounds.size.width/3.2

//定义附近和动态处上方的榜单高度
#define DYANDNERHEIGHT [UIScreen mainScreen].bounds.size.width/4.2

//宽度的比例与5相比
#define WIDTHRADIO [UIScreen mainScreen].bounds.size.width/320

//高度的比例与5相比
#define HEIGHTRADIO [UIScreen mainScreen].bounds.size.height/568

#define W_SCREEN [UIScreen mainScreen].bounds.size.width/375

//男的图标背景颜色

#define BOYCOLOR [UIColor colorWithHexString:@"#96d6ff" alpha:1]
//女的图标背景颜色

#define GIRLECOLOR [UIColor colorWithHexString:@"#ffacc0" alpha:1]

//双性图标背景颜色
#define DOUBLECOLOR [UIColor colorWithHexString:@"#e7aaee" alpha:1]

//绿色图标背景颜色
#define GREENCOLORS [UIColor colorWithHexString:@"#ade489" alpha:1]

//main 紫色

#define MainColor [UIColor colorWithHexString:@"#c450d6" alpha:1]

//textColor
#define TextCOLOR [UIColor colorWithHexString:@"303030" alpha:0.8]

//orange
#define  MYORANGE [UIColor colorWithRed:255/255.0 green:157/255.0 blue:0/255.0 alpha:1]

//=====================单例==================
// @interface
#define singleton_interface(className) \
+ (className *)shared;

// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}
//========================end==================
  
// 防止多次调用
#define kPreventRepeatClickTime(_seconds_) \
static BOOL shouldPrevent; \
if (shouldPrevent) return; \
shouldPrevent = YES; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_seconds_) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
shouldPrevent = NO; \
}); \

//#define kATRegular @"@[\\u4e00-\\u9fa5\\w\\-\\_\\.\\*\\&\\^\\%\\$\\#\\!\\=\\+\\\\?\\/\\<\\>\\,\\/]+ "
#define kATRegular @"@\\S+ "

#define GroupTesturl  @"http://47.93.194.65:888/Home/Info/news/id/31"

#define SUPVIEWNOTIFICATION @"SUPVIEWNOTIFICATION"

#endif /* wangHeader_h */

