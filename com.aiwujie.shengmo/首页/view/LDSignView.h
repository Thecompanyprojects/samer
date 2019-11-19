//
//  LDSignView.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/7/6.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDSignView : UIView

/**
 显示签到界面
 */
-(instancetype)initWithFrame:(CGRect)frame;

/**
 获取签到的次数,及签到状态
 */
-(void)getSignDays:(NSString *)signtimes andsignState:(NSString *)state;

@end
