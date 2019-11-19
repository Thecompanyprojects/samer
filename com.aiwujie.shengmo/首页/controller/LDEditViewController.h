//
//  LDEditViewController.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/1.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义枚举类型
typedef enum {
    ENUM_FROMUSER_ActionType=0,//用户本人修改
    ENUM_FROMADMIN_ActionType//admin修改
    
} ENUM_FROM_ActionType;

@interface LDEditViewController : LDBaseViewController
@property (nonatomic,assign) NSInteger InActionType; //操作类型
@property (nonatomic,copy) NSString *userID;

@end
