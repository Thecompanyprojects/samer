//
//  UIImage+Cut.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/14.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Cut)
/*
 *  圆形图片
 */
@property (nonatomic,strong,readonly) UIImage *roundImage;



/**
 *  从给定UIView中截图：UIView转UIImage
 */
+(UIImage *)cutFromView:(UIView *)view;



/**
 *  直接截屏
 */
+(UIImage *)cutScreen;



/**
 *  从给定UIImage和指定Frame截图：
 */
-(UIImage *)cutWithFrame:(CGRect)frame;




/**
 获取圆角图片
 
 @return 圆角图片
 */
- (UIImage *)cutCircleImage;



/**
 图片模糊处理

 @param image 图片
 @param blur 模糊程度
 @return 图片模糊
 */
+(UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;


/**

 设置图片透明度
 @param image 图片
 @param alpha 图片透明度
 @return 图片
 */
+ (UIImage *)image:(UIImage*)image setAlpha:(CGFloat)alpha;



/**
 拍照图片的方向选择

 @param aImage 图片
 @return 图片
 */
+(UIImage*)fixOrientation:(UIImage*)aImage;
@end

NS_ASSUME_NONNULL_END
