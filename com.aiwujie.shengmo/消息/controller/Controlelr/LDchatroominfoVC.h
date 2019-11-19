//
//  LDchatroominfoVC.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/3.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LDchatroominfoVC : LDBaseViewController
@property (nonatomic,copy) NSString *rule;
@property (nonatomic,strong) NSDictionary *infoDic;
@property (nonatomic,strong) void (^myBlock)(NSDictionary *dic);
@property (nonatomic,copy) NSString *roomId;
@end

NS_ASSUME_NONNULL_END
