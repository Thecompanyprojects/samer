//
//  stampChatView.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/30.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StampChatDelete <NSObject>

/**
 选择了哪种邮票,传递过去值
 */
-(void)didSelectStamp:(NSString *)stamptype;

/**
 选择了其余的按钮邮票
 */
-(void)didSelectOtherButton;

/**
 选择了关注好友的按钮
 */
-(void)didSelectAttentButton:(UIView *)backView andButton:(UIButton *)button;

/**
 选择了去开通SVIP的按钮
 */
-(void)stampOpenSvipButtonClick;

@end

@interface LDStampChatView : UIView

@property (nonatomic,weak) id<StampChatDelete> delegate;

/**
 获取请求的数据
 */
@property (nonatomic,strong) NSDictionary *data;

/**
 传入对应的控制器
 */
@property (nonatomic,strong) UIViewController *viewController;

/**
 显示送礼物
 */
-(instancetype)initWithFrame:(CGRect)frame;

/**
 移除送邮票聊天页面
 */
-(void)removeView;

@end

