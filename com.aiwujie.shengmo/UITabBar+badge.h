//
//  UITabBar+badge.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/3/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
