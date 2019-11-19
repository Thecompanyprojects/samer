//
//  TableModel.h
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/23.
//  Copyright © 2016年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableModel : NSObject<NSCoding,NSCopying>

@property (nonatomic,copy) NSString *age;
@property (nonatomic,copy) NSString *distance;
@property (nonatomic,copy) NSString *head_pic;
@property (nonatomic,copy) NSString *last_login_time;
@property (nonatomic,copy) NSString *lat;
@property (nonatomic,copy) NSString *lng;
@property (nonatomic,copy) NSString *markname;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *onlinestate;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *role;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *introduce;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *vip;
@property (nonatomic,copy) NSString *is_hand;
@property (nonatomic,copy) NSString *is_admin;

@property (nonatomic,copy) NSString *amount;

//打赏魔豆图片id
@property (nonatomic,copy) NSString *psid;

//赠送礼物数量
@property (nonatomic,copy) NSString *num;

//来访
@property (nonatomic,copy) NSString *visit_time;
//黑名单
@property (nonatomic,copy) NSString *add_time;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *black_time;

//魅力值
@property (nonatomic,copy) NSString *charm_val;
//财富值
@property (nonatomic,copy) NSString *wealth_val;

//查看好友
@property (nonatomic,copy) NSString *state;
@property (nonatomic,strong) NSDictionary *userInfo;

//是否选中此人
@property (nonatomic,assign) BOOL select;

//点赞,打赏时间
@property (nonatomic,copy) NSString *sendtime;

//志愿者
@property (nonatomic,copy) NSString *is_volunteer;
//svip
@property (nonatomic,copy) NSString *svip;
//年svip
@property (nonatomic,copy) NSString *svipannual;
//年费会员
@property (nonatomic,copy) NSString *vipannual;

//警示榜的数据
//设备被封
@property (nonatomic,copy) NSString *devicestatus;
//账号被封
@property (nonatomic,copy) NSString *status;
//聊天被封
@property (nonatomic,copy) NSString *chatstatus;
//资料被封
@property (nonatomic,copy) NSString *infostatus;
//动态被封
@property (nonatomic,copy) NSString *dynamicstatus;

@property (nonatomic,copy) NSString *addtime;

@property (nonatomic,copy) NSString *interval;
@property (nonatomic,copy) NSString *use_sum;
@property (nonatomic,copy) NSString *sum;

//贵宾版黑V
@property (nonatomic,copy) NSString *bkvip;
//蓝V
@property (nonatomic,copy) NSString *blvip;

@property (nonatomic,copy) NSString *lmarkname;

@property (nonatomic,copy) NSString *location_switch;
@property (nonatomic,copy) NSString *login_time_switch;
@property (nonatomic,copy) NSString *location_city_switch;

@end
