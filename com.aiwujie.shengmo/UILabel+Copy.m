//
//  UILabel+Copy.m
//  HU
//
//  Created by mac on 17/1/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "UILabel+Copy.h"

@implementation UILabel (Copy)

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    return (action == @selector(copyText:));
}
- (void)attachTapHandler {
    
    self.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *g = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:g];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

-(void)tap:(UIGestureRecognizer *)tap{

    if ([UIMenuController sharedMenuController].isMenuVisible){
    
       [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    };

}

//  处理手势相应事件(长按手势)
- (void)handleTap:(UIGestureRecognizer *)g {
    
    [self becomeFirstResponder];
    
    if ([UIMenuController sharedMenuController].isMenuVisible)return;
    
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyText:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:item]];
   
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];

    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

//  复制时执行的方法
- (void)copyText:(id)sender {
    //  通用的粘贴板
    UIPasteboard *pBoard = [UIPasteboard generalPasteboard];
    //  有些时候只想取UILabel的text中的一部分
    if (objc_getAssociatedObject(self, @"expectedText")) {
        pBoard.string = objc_getAssociatedObject(self, @"expectedText");
    } else {
        //  因为有时候 label 中设置的是attributedText
        //  而 UIPasteboard 的string只能接受 NSString 类型
        //  所以要做相应的判断
        if (self.text) {
            
            pBoard.string = self.text;
            
        } else {
            
            pBoard.string = self.attributedText.string;
        }
    }
}

- (BOOL)canBecomeFirstResponder {
    
    return [objc_getAssociatedObject(self, @selector(isCopyable)) boolValue];
}
- (void)setIsCopyable:(BOOL)number {
    
    objc_setAssociatedObject(self, @selector(isCopyable), [NSNumber numberWithBool:number], OBJC_ASSOCIATION_ASSIGN);
    [self attachTapHandler];
    
}
- (BOOL)isCopyable {
    
    return [objc_getAssociatedObject(self, @selector(isCopyable)) boolValue];
}

@end
