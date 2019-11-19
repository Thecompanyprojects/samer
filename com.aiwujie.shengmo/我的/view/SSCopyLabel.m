//
//  SSCopyLabel.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/14.
//  Copyright © 2019 a. All rights reserved.
//

#import "SSCopyLabel.h"

@implementation SSCopyLabel

-(void)awakeFromNib
{
    //说明文档里说必须调用父类的awakeFromNib，以防出现意外，详细说明见文档
    [super awakeFromNib];
    [self setUp];
}

#pragma mark - ---------- 两种常用初始化方法 ----------
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

// 设置label可以成为第一响应者
- (BOOL)canBecomeFirstResponder {
    return YES;
}


// 设置长按事件
- (void)setUp {
    /* 你可以在这里添加一些代码，比如字体、居中、夜间模式等 */
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress)]];
}

// 长按事件
- (void)longPress {
    
    // 设置label为第一响应者
    [self becomeFirstResponder];
    
    // 自定义 UIMenuController
    UIMenuController * menu = [UIMenuController sharedMenuController];
    UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyText:)];
    menu.menuItems = @[item1];
    [menu setTargetRect:self.bounds inView:self];
    [menu setMenuVisible:YES animated:YES];
}

// 设置label能够执行那些具体操作
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if(action == @selector(copyText:)) return YES;
    return NO;
}

// 复制方法
- (void)copyText:(UIMenuController *)menu {
    // 没有文字时结束方法
    if (!self.text) return;
    // 复制文字到剪切板
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = self.text;
    
}
@end
