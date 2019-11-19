//
//  RewardRankingModel.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/11.
//  Copyright © 2017年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardRankingModel : NSObject

@property (nonatomic,copy) NSString *allamount;
@property (nonatomic,copy) NSString *head_pic;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,strong) NSDictionary *rewardeduserinfo;
@property (nonatomic,strong) NSDictionary *rewarduserinfo;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *fuid;
@property (nonatomic,copy) NSString *role;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *vip;
@property (nonatomic,copy) NSString *age;
@property (nonatomic,copy) NSString *is_admin;
@property (nonatomic,copy) NSString *realname;
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

@end
