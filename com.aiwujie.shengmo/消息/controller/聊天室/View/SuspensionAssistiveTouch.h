//
//  SuspensionAssistiveTouch.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/5.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kSuspensionViewDisNotificationName    @"SUSPENSIONVIEWDISAPPER_NOTIFICATIONNAME"
#define  kSuspensionViewShowNotificationName  @"SUSPENSIONVIEWSHOW_NOTIFICATIONNAME"

#define kNotificationCenter [NSNotificationCenter defaultCenter]

#define kWindow          [[UIApplication sharedApplication].windows firstObject]
#define kScreenBounds    [[UIScreen mainScreen] bounds]
#define kScreenWidth     kScreenBounds.size.width
#define kScreenHeight    kScreenBounds.size.height


#define kAlpha                0.5
#define kPrompt_DismisTime    0.2
#define kProportion           0.82

NS_ASSUME_NONNULL_BEGIN


@interface SuspensionAssistiveTouch : UIWindow

+(SuspensionAssistiveTouch*)defaultTool;

-(void)showView;
-(void)backbtnClick;
-(void)suspensionAssistiveTouch;
-(void)dismissView;
@property (nonatomic,strong) NSDictionary *infoDic;
@property (nonatomic,copy) NSString *str0;
@property (nonatomic,copy) NSString *str1;
@property (nonatomic,copy) NSString *roomidStr;
@end

NS_ASSUME_NONNULL_END
