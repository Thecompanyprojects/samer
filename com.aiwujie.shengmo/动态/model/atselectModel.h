//
//  atselectModel.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/27.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface atselectModel : NSObject
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , copy) NSString              * vipannual;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * age;
@property (nonatomic , copy) NSString              * role;
@property (nonatomic , copy) NSString              * head_pic;
@property (nonatomic , copy) NSString              * realname;
@property (nonatomic , copy) NSString              * vip;
@property (nonatomic , copy) NSString              * sex;
//是否选中此人
@property (nonatomic,assign) BOOL select;
@end

NS_ASSUME_NONNULL_END
