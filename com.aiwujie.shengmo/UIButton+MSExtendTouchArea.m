//
//  UIButton+MSExtendTouchArea.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/9/9.
//  Copyright © 2019 a. All rights reserved.
//

#import "UIButton+MSExtendTouchArea.h"
#import <objc/runtime.h>

@implementation UIButton (MSExtendTouchArea)

static char MSExtendEdgeKey;

- (void)extendTouchArea:(UIEdgeInsets)edgeArea {
    objc_setAssociatedObject(self, &MSExtendEdgeKey, [NSValue valueWithUIEdgeInsets:edgeArea], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIEdgeInsets edge = [objc_getAssociatedObject(self, &MSExtendEdgeKey) UIEdgeInsetsValue];
    
    CGRect extendArea = self.bounds;
    if (edge.left || edge.right || edge.top || edge.bottom) {
        extendArea = CGRectMake(self.bounds.origin.x - edge.left,
                                self.bounds.origin.y - edge.top,
                                self.bounds.size.width + edge.left + edge.right,
                                self.bounds.size.height + edge.top + edge.bottom);
    }
    return CGRectContainsPoint(extendArea, point);
}

@end
