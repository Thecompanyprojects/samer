//
//  LDShowtopVoew.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/9.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//typedef void(^sureBlock)(NSString *num);
//typedef void(^buyBlock)(NSString *string);
//typedef void(^alertBlock)(NSString *string);

@interface LDShowtopView : UIView
@property (nonatomic,copy) NSString *did;


@property (nonatomic, copy) void(^alert)(NSString *str);
@property (nonatomic, copy) void(^buyclick)(NSString *str);
@property (nonatomic, copy) void(^sureclick)(NSString *num, NSString *rocket);
@property (nonatomic, copy) void(^alertshow)(void);
@property (nonatomic, copy) void(^alertshowchoose)(void);
//@property(nonatomic,copy) sureBlock sureClick;
//@property(nonatomic,copy) buyBlock buyClick;
//@property(nonatomic,copy) alertBlock alertClick;
//
//-(void)withSureClick:(sureBlock)block;
//-(void)withBuyClick:(buyBlock)block;
//-(void)withAlertClick:(alertBlock)block;
@end

NS_ASSUME_NONNULL_END
