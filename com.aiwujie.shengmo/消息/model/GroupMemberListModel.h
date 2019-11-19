//
//  GroupMemberListModel.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/17.
//  Copyright © 2017年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupMemberListModel : NSObject

@property (nonatomic,copy) NSString *state;

@property (nonatomic,copy) NSString *vip;

@property (nonatomic,copy) NSString *is_admin;

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,copy) NSString *age;

@property (nonatomic,copy) NSString *head_pic;

@property (nonatomic,copy) NSString *sex;

@property (nonatomic,copy) NSString *realname;

@property (nonatomic,copy) NSString *nickname;

@property (nonatomic,copy) NSString *onlinestate;

@property (nonatomic,copy) NSString *lat;

@property (nonatomic,copy) NSString *role;

@property (nonatomic,copy) NSString *lng;

@property (nonatomic,copy) NSString *last_login_time;

@property (nonatomic,copy) NSString *distance;

@property (nonatomic,copy) NSString *introduce;

@property (nonatomic,copy) NSString *ugid;

@property (nonatomic,copy) NSString *gagstate;

@property (nonatomic,copy) NSString *city;

@property (nonatomic,copy) NSString *province;

//魅力值
@property (nonatomic,copy) NSString *charm_val;
//财富值
@property (nonatomic,copy) NSString *wealth_val;

//志愿者
@property (nonatomic,copy) NSString *is_volunteer;
//svip
@property (nonatomic,copy) NSString *svip;
//年svip
@property (nonatomic,copy) NSString *svipannual;
//年费会员
@property (nonatomic,copy) NSString *vipannual;

//贵宾版黑V
@property (nonatomic,copy) NSString *bkvip;
//蓝V
@property (nonatomic,copy) NSString *blvip;

@property (nonatomic,copy) NSString *markname;

//群名片
@property (nonatomic,copy) NSString *cardname;
@end
