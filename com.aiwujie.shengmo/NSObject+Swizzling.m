//
//  NSObject+Swizzling.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/14.
//  Copyright © 2019 a. All rights reserved.
//

#import "NSObject+Swizzling.h"

@implementation NSObject (Swizzling)
/**
 类方法交换
 
 @param originalSelector    原始类方法名
 @param newSelector         新类方法名
 */
+ (void)yg_swizzlingClassMethod:(SEL)originalSelector withMethod:(SEL)newSelector {
    Class class = self;
    //原有方法
    Method originalMethod = class_getClassMethod(class, originalSelector);
    //替换原有方法的新方法
    Method swizzledMethod = class_getClassMethod(class, newSelector);
    
    Class metaClass = object_getClass(class); // 获取元类
    
    //先尝试給源SEL添加IMP，这里是为了避免源SEL没有实现IMP的情况
    BOOL didAddMethod = class_addMethod(metaClass,originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {//添加成功：说明源SEL没有实现IMP，将源SEL的IMP替换到交换SEL的IMP
        class_replaceMethod(metaClass,newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {//添加失败：说明源SEL已经有IMP，直接将两个SEL的IMP交换即可
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/**
 实例方法交换
 
 @param originalSelector    原始实例方法名
 @param newSelector         新实例方法名
 */
+ (void)yg_swizzlingInstanceMethod:(SEL)originalSelector withMethod:(SEL)newSelector {
    Class class = self;
    //原有方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    //替换原有方法的新方法
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
    //先尝试給源SEL添加IMP，这里是为了避免源SEL没有实现IMP的情况
    BOOL didAddMethod = class_addMethod(class,originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {//添加成功：说明源SEL没有实现IMP，将源SEL的IMP替换到交换SEL的IMP
        class_replaceMethod(class,newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {//添加失败：说明源SEL已经有IMP，直接将两个SEL的IMP交换即可
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
