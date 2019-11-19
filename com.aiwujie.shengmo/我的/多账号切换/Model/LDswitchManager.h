//
//  LDswitchManager.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/5.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDswitchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LDswitchManager : NSObject

@property (nonatomic,strong) NSMutableArray *dataSource;

+ (instancetype)sharedClient;

/**
 建表
 */

-(void)firstchoose;

/**
 读取数据
 
 @return 读取表中数据
 */
-(NSMutableArray *)loaddata;

/**
 插入数据
 
 @param model 数据模型
 */
-(void)insertInfowith:(LDswitchModel *)model;


/**
 删除指定的数据

 @param uid 用户uid
 */
-(void)deletefromuid:(NSString *)uid;

/**
 判断是否插入数据
 
 @return 是否插入数据
 */
-(BOOL)iscaninsert;



/**
 更新数据 更新密码

 @param uid uid
 @param password 密码
 */
- (void)updateDataWithuserId:(NSString *)uid andpassword:(NSString *)password;


/**
 更新数据 更新头像

 @param uid uid
 @param imageUrl 头像
 */
- (void)updateDataWithuserId:(NSString *)uid andimageUrl:(NSString *)imageUrl;


/**
 更新数据 更新名字

 @param uid uid
 @param nickname 名字
 */
- (void)updateDataWithuserId:(NSString *)uid andnickname:(NSString *)nickname;

-(void)getVipStatusData;
@end

NS_ASSUME_NONNULL_END
