//
//  CCLoadingHUD.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCLoadingHUD : UIView
+(void)show;

+(void)dismiss;

+(UIView *)CreateLoadingViewWithFrame:(CGRect)frame;
+(UIView *)CreateTarotLoadingViewWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
