//
//  BillModel.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/12.
//  Copyright © 2017年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillModel : NSObject

@property (nonatomic,copy) NSString *week;
@property (nonatomic,copy) NSString *amount;
@property (nonatomic,copy) NSString *beans;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *fuid;

//
@property (nonatomic,copy) NSString *addtime;
@property (nonatomic,copy) NSString *addtime_format;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *num;
@property (nonatomic,copy) NSString *type;

//提现的时间,金额
@property (nonatomic,copy) NSString *money;
@property (nonatomic,copy) NSString *success_time;
@property (nonatomic,copy) NSString *success_time_format;

//充值赠送或兑换的类型
@property (nonatomic,copy) NSString *state;


//推顶使用记录
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *did;
@property (nonatomic,copy) NSString *duid;
@property (nonatomic,copy) NSString *head_pic;
@property (nonatomic,copy) NSString *is_admin;
@property (nonatomic,copy) NSString *is_hand;
@property (nonatomic,copy) NSString *pic;
@property (nonatomic,copy) NSString *use_sum;
@property (nonatomic,copy) NSString *sum;
@property (nonatomic,copy) NSString *interval;

@property (nonatomic , copy) NSString              * svip;
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , copy) NSString              * age;
@property (nonatomic , copy) NSString              * is_volunteer;
@property (nonatomic , copy) NSString              * realname;
@property (nonatomic , copy) NSString              * sex;
@property (nonatomic , copy) NSString              * svipannual;
@property (nonatomic , copy) NSString              * vip;
@property (nonatomic , copy) NSString              * vipannual;
@property (nonatomic , copy) NSString              * role;

@property (nonatomic , copy) NSString              * days;
@property (nonatomic , copy) NSString              * pay_type;
@property (nonatomic , copy) NSString              * channel;
@property (nonatomic , copy) NSString              * fnickname;


@end
