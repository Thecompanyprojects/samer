//
//  commentModel.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface commentModel : NSObject

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *nickname;

@property (nonatomic,copy) NSString *head_pic;

@property (nonatomic,copy) NSString *otheruid;

@property (nonatomic,copy) NSString *othernickname;

@property (nonatomic,copy) NSString *cmid;

@property (nonatomic,copy) NSString *sendtime;

@property (nonatomic,copy) NSString *is_hand;

@property (nonatomic,copy) NSString *is_admin;

@property (nonatomic,copy) NSString *vip;

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

@property (nonatomic,copy) NSString *atuname;
@property (nonatomic,copy) NSString *atuid;
@end
