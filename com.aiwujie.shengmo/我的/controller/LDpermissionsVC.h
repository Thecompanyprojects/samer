//
//  LDpermissionsVC.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/10.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//定义枚举类型
typedef enum {
    ENUM_PERMISSIONPHOTO_ActionType=0,//相册查看权限
    ENUM_PERMISSIONDYNAMIC_ActionType,//主页动态查看权限
    ENUM_PERMISSIONCOMMENTS_ActionType,//主页评论查看权限
    ENUM_PERMISSIONCOMMENTS_HistorynameType//历史昵称查看权限
} ENUM_PERMISSION_ActionType;

typedef void (^ReturnValueBlock) (BOOL isChoose);

@interface LDpermissionsVC : LDBaseViewController
@property (nonatomic,assign) NSInteger InActionType; //操作类型
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;
@property (nonatomic,assign) BOOL isChoose; //true 会员可见 false 所有人可见
@end

NS_ASSUME_NONNULL_END
