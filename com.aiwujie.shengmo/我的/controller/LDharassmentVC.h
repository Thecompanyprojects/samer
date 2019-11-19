//
//  LDharassmentVC.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/6.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ReturnValueBlock) (BOOL isAll);
@interface LDharassmentVC : LDBaseViewController
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;
@property (nonatomic,assign) BOOL isAll; //true 所有人都可发消息 false 会员、邮票才可发消息
@end

NS_ASSUME_NONNULL_END
