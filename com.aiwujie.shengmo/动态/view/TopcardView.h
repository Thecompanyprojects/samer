//
//  TopcardView.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/19.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^sureBlock)(NSString *string);
typedef void(^buyBlock)(NSString *string);
typedef void(^alertBlock)(NSString *string);

@interface TopcardView : UIView
@property (nonatomic,copy) NSString *did;
@property(nonatomic,copy)sureBlock sureClick;
@property(nonatomic,copy)buyBlock buyClick;
@property(nonatomic,copy)alertBlock alertClick;
-(void)withSureClick:(sureBlock)block;
-(void)withBuyClick:(buyBlock)block;
-(void)withAlertClick:(alertBlock)block;
@end

NS_ASSUME_NONNULL_END
