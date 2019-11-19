//
//  LDSelectpersonpageVC.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/26.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^NewMyBlock)(NSMutableArray *allUid,NSMutableArray *nameArr,int personNumber);

typedef void(^returnBlock)(void);

@interface LDSelectpersonpageVC : LDBaseViewController
@property (nonatomic,copy) NewMyBlock newblock;
@property (nonatomic,copy) returnBlock returnblock;
@property (nonatomic,assign) BOOL isfromGroup;
@property (nonatomic,strong) NSMutableArray *uidArray;
@end

NS_ASSUME_NONNULL_END
