//
//  LDSharepageVC.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/30.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
//        vc.content = self.inmodel.nickname;
//        vc.did = self.inmodel.uid;
//        vc.typeStr = @"1";
//        vc.pic = self.inmodel.head_pic;
@interface LDSharepageVC : LDBaseViewController
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *did;
@property (nonatomic,copy) NSString *pic;
@property (nonatomic,copy) NSString *typeStr;
@property (nonatomic,copy) NSString *userid;
@end

NS_ASSUME_NONNULL_END
