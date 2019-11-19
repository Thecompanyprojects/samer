//
//  SendredsmeViewController.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/10.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SendredsmeViewController : LDBaseViewController
@property (nonatomic,strong) void (^myBlock)(NSDictionary *dic);
@end

NS_ASSUME_NONNULL_END
