//
//  LDAttentioninfoModel.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/12.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LDAttentioninfoModel : NSObject
@property (nonatomic , copy) NSString              * province;
@property (nonatomic , copy) NSString              * location_city_switch;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * sex;
@property (nonatomic , copy) NSString              * onlinestate;
@property (nonatomic , copy) NSString              * is_hand;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * realname;
@property (nonatomic , copy) NSString              * wealth_val;
@property (nonatomic , copy) NSString              * vipannual;
@property (nonatomic , copy) NSString              * head_pic;
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , copy) NSString              * is_admin;
@property (nonatomic , copy) NSString              * svip;
@property (nonatomic , copy) NSString              * role;
@property (nonatomic , copy) NSString              * age;
@property (nonatomic , copy) NSString              * is_volunteer;
@property (nonatomic , copy) NSString              * vip;
@property (nonatomic , copy) NSString              * charm_val;
@property (nonatomic , copy) NSString              * markname;
@property (nonatomic , copy) NSString              * svipannual;
//贵宾版黑V
@property (nonatomic,copy) NSString *bkvip;
//蓝V
@property (nonatomic,copy) NSString *blvip;
@property (nonatomic,copy) NSString *lmarkname;
@end

NS_ASSUME_NONNULL_END
