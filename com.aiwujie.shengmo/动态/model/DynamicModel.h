//
//  DynamicModel.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/21.
//  Copyright © 2017年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicModel : NSObject

@property (nonatomic,copy) NSString *vip;

@property (nonatomic,copy) NSString *is_hand;

@property (nonatomic,copy) NSString *is_admin;

@property (nonatomic,copy) NSString *comnum;

@property (nonatomic,copy) NSString *head_pic;

@property (nonatomic,copy) NSString *sex;

@property (nonatomic,copy) NSString *realname;

@property (nonatomic,copy) NSString *age;

@property (nonatomic,copy) NSString *addtime;

@property (nonatomic,copy) NSString *onlinestate;

@property (nonatomic,copy) NSString *readtimes;

@property (nonatomic,strong) NSArray *pic;

@property (nonatomic,strong) NSArray *sypic;

@property (nonatomic,copy) NSString *rewardnum;

@property (nonatomic,copy) NSString *laudnum;

@property (nonatomic,copy) NSString *laudstate;

@property (nonatomic,strong) NSArray *comArr;

@property (nonatomic,copy) NSString *did;

@property (nonatomic,copy) NSString *role;

@property (nonatomic,copy) NSString *nickname;

@property (nonatomic,copy) NSString *distance;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *recommend;

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,copy) NSString *topictitle;

@property (nonatomic,copy) NSString *tid;

//置顶状态
@property (nonatomic,copy) NSString *stickstate;

//动态的隐藏状态
@property (nonatomic,copy) NSString *is_hidden;

//推荐置顶显示顶图标
@property (nonatomic,copy) NSString *recommendall;

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

//热帖回复时间
@property (nonatomic,copy) NSString *commenttime;

//动态数
@property (nonatomic,copy) NSString *dynamic_num;

//推荐动态数
@property (nonatomic,copy) NSString *rdynamic_num;
//推顶数量
//@property (nonatomic,copy) NSString *topnum;

@property (nonatomic,copy) NSString *atuname;

@property (nonatomic,copy) NSString *atuid;

@property (nonatomic,copy) NSString *alltopnums;

@property (nonatomic,copy) NSString *usetopnums;

@property (nonatomic,copy) NSString *location_switch;
//贵宾版黑V
@property (nonatomic,copy) NSString *bkvip;
//蓝V
@property (nonatomic,copy) NSString *blvip;

//颜色标记
@property (nonatomic,copy) NSString *auditMark;
@end
