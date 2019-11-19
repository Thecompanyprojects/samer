//
//  LDAttentionpageVC.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/8.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LDAttentionpageVC : LDBaseViewController
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,assign) BOOL isguanzhu;
@property (nonatomic,assign) BOOL isMine;
@property (nonatomic,assign) BOOL isfromGuanzhu;
@end

NS_ASSUME_NONNULL_END
