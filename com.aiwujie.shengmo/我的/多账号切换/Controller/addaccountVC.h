//
//  addaccountVC.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/5.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^ReturnValueBlock) (void);
@interface addaccountVC : LDBaseViewController
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;
@end

NS_ASSUME_NONNULL_END
