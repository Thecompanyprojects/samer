//
//  groupinfoModel.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/4.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Data :NSObject
@property (nonatomic , copy) NSString              * userpower;
@property (nonatomic , copy) NSString              * groupname;
@property (nonatomic , copy) NSString              * member;
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , copy) NSString              * manager;
@property (nonatomic , copy) NSString              * province;
@property (nonatomic , copy) NSString              * max_member;
@property (nonatomic , copy) NSString              * group_num;
@property (nonatomic , copy) NSString              * group_pic;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * introduce;
@property (nonatomic , copy) NSString              * managerStr;
@end


@interface groupinfoModel : NSObject
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , strong) Data              * data;
@property (nonatomic , copy) NSString              * retcode;
@end



NS_ASSUME_NONNULL_END
