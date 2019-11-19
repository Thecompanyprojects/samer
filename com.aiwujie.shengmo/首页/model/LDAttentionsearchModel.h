//
//  LDAttentionsearchModel.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/12.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDAttentioninfoModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface LDAttentionsearchModel : NSObject
@property (nonatomic , copy) NSString              * state;
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , strong) LDAttentioninfoModel              * userInfo;
@end

NS_ASSUME_NONNULL_END
