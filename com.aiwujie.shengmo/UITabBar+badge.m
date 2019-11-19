//
//  UITabBar+badge.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/3/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import "UITabBar+badge.h"
#define TabbarItemNums 5.0

@implementation UITabBar (badge)

- (void)showBadgeOnItemIndex:(int)index{
        
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        //新建小红点
        UIView *badgeView = [[UIView alloc]init];
        badgeView.tag = 888 + index;
        badgeView.layer.cornerRadius = 5;
        badgeView.backgroundColor = [UIColor redColor];
        CGRect tabFrame = self.frame;
        
        //确定小红点的位置
        float percentX = (index + 0.56) / TabbarItemNums;
        CGFloat x = ceilf(percentX * tabFrame.size.width);
        CGFloat y = ceilf(0.1 * tabFrame.size.height);
        
        if (ISIPHONEX) {
            
            badgeView.frame = CGRectMake(x, y - 3, 10, 10);
            
        }else{
            
            badgeView.frame = CGRectMake(x, y, 10, 10);
        }
        
        [self addSubview:badgeView];

    });

}

- (void)hideBadgeOnItemIndex:(int)index{
        
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
}

- (void)removeBadgeOnItemIndex:(int)index{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //按照tag值进行移除
        for (UIView *subView in self.subviews) {
            
            if (subView.tag == 888 + index) {
                    
                [subView removeFromSuperview];
                
            }
        }

    });

}

@end
