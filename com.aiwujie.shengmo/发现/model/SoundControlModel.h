//
//  SoundControlModel.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/16.
//  Copyright © 2017年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundControlModel : NSObject

@property (nonatomic,copy) NSString *age;
@property (nonatomic,copy) NSString *charm_val;
@property (nonatomic,copy) NSString *head_pic;
@property (nonatomic,copy) NSString *introduce;
@property (nonatomic,copy) NSString *is_hand;
@property (nonatomic,copy) NSString *is_admin;
@property (nonatomic,copy) NSString *last_login_time;
@property (nonatomic,copy) NSString *lat;
@property (nonatomic,copy) NSString *lng;
@property (nonatomic,copy) NSString *media;
@property (nonatomic,copy) NSString *media_change_time;
@property (nonatomic,copy) NSString *update_media_time;
@property (nonatomic,copy) NSString *mediaalong;
@property (nonatomic,copy) NSString *wealth_val;


@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *onlinestate;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *role;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *vip;

//获取城市省份
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *province;

//svip
@property (nonatomic,copy) NSString *svip;
//年svip
@property (nonatomic,copy) NSString *svipannual;
//志愿者
@property (nonatomic,copy) NSString *is_volunteer;

//年费会员
@property (nonatomic,copy) NSString *vipannual;

@end
