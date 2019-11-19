//
//  LDSetgroupVC.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/9/2.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LDSetgroupVC : LDBaseViewController
@property (nonatomic,copy) NSString *fuid;
@property (nonatomic, copy) void(^Returnback)(NSDictionary *dict);
@end

NS_ASSUME_NONNULL_END
