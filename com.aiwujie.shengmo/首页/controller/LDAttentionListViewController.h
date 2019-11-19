//
//  LDAttentionListViewController.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/1.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDAttentionListViewController : LDBaseViewController
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,assign) BOOL isquietly;
@property (nonatomic,copy) NSString *fgid;
@property (nonatomic,copy) void(^quiteNumblock)(NSString *nums);
@property (nonatomic,assign) BOOL isfromGuanzhu;
@end
