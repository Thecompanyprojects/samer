//
//  VIPMemberModel.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/11/22.
//  Copyright © 2017年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VIPMemberModel : NSObject

//时间和价格展示
@property (nonatomic,copy) NSString *month;

//价钱
@property (nonatomic,copy) NSString *price;

//优惠的文字
@property (nonatomic,copy) NSString *introduce;

//原价
@property (nonatomic,copy) NSString *oldprice;

//是否有提示语句
@property (nonatomic,copy) NSString *warnstate;

//是否被选中
@property (nonatomic,copy) NSString *selectstate;


@end
