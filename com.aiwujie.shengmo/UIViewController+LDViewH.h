//
//  UIViewController+LDViewH.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/10/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LDViewH)

//VIEWCONTROLLER的距离
-(CGFloat)getIsIphoneX:(BOOL)isIphoneX;

//NAV按钮的距离
-(CGFloat)getIsIphoneXNAV:(BOOL)isIphoneX;

//NAV按钮底部黑线的距离
-(CGFloat)getIsIphoneXNAVBottom:(BOOL)isIphoneX;
//NAV按钮右上角红点距离
-(CGFloat)getIsIphoneXNAVRightDog:(BOOL)isIphoneX;

@end
