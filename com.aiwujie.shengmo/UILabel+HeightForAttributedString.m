//
//  UILabel+HeightForAttributedString.m
//  ShengmoApp
//
//  Created by 爱无界 on 2018/1/26.
//  Copyright © 2018年 a. All rights reserved.
//

#import "UILabel+HeightForAttributedString.h"

@implementation UILabel (HeightForAttributedString)

- (CGFloat)heightForAttributedString:(NSString *)string andFont:(UIFont *)wordfont andLabel:(UILabel *)label andLabelWidth:(CGFloat)width andLinespace:(CGFloat)space {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    [attributedString addAttribute:NSFontAttributeName value:wordfont range:NSMakeRange(0, [string length])];
    label.attributedText = attributedString;
    
    label.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行

    if (size.height < 2 * wordfont.lineHeight){
        
        if ([self containChinese:string]) { //如果包含中文
            
            label.attributedText = nil;
            label.text = string;
            return 16;
        }
    }
    
    return size.height;
}

//判断如果包含中文
- (BOOL)containChinese:(NSString *)str {
    
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            
            return YES;
        }
    }
    return NO;
}


@end
