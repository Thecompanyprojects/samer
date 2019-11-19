//
//  UILabel+HeightForAttributedString.h
//  ShengmoApp
//
//  Created by 爱无界 on 2018/1/26.
//  Copyright © 2018年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (HeightForAttributedString)

/**
   需设置行间距,如果不必须是富文本文字的话,单行时可清空富文本文字,直接给label赋值
 */
- (CGFloat)heightForAttributedString:(NSString *)string andFont:(UIFont *)wordfont andLabel:(UILabel *)label andLabelWidth:(CGFloat)width andLinespace:(CGFloat)space;

@end
