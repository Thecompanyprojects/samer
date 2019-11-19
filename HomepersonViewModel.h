//
//  HomepersonViewModel.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/29.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "infoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomepersonViewModel : NSObject
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,strong) NSObject *infoObj;
@property (nonatomic, copy) __block void (^personInfoBlock)(void);

@property (nonatomic,strong) NSDictionary *admindic;
@property (nonatomic, copy) __block void (^adminInfoBlock)(void);

- (void)getinfodataFromweb;
/**
 admin获取相关信息
 */
-(void)getadminnumFromweb;
@end

NS_ASSUME_NONNULL_END
