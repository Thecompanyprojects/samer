//
//  LDAttentionpersonVC.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/9/2.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDBaseViewController.h"
#import "LDAttentiongroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LDAttentionpersonVC : LDBaseViewController
@property (nonatomic,strong) LDAttentiongroupModel *groupModel;
@property (nonatomic, copy) void(^Complate)(void);


@end

NS_ASSUME_NONNULL_END
