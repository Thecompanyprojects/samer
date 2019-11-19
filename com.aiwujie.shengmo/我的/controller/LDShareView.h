//
//  LDShareView.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/14.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDShareView : UIView

/**
 创建分享视图,传递分享内容
 */
- (UIView *)createBottomView:(NSString *)come andNickName:(NSString *)name andPicture:(NSString *)pic andId:(NSString *)shareId;

/**
 控制视图的弹出与收回
 */
-(void)controlViewShowAndHide:(UIViewController *)viewController;


@end
