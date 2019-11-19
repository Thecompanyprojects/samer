//
//  LDCertificatePageVC.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/11.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LDCertificatePageVC : LDBaseViewController
@property (nonatomic,copy) NSString *status;//自拍认证状态
@property (nonatomic,copy) NSString *where;
@property (nonatomic,assign) BOOL isfromuserinfo;

@end

NS_ASSUME_NONNULL_END
