//
//  NSObject+Swizzling.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/14.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Swizzling)
/**
 类方法交换
 
 @param originalSelector    原始类方法名
 @param newSelector         新类方法名
 */
+ (void)yg_swizzlingClassMethod:(SEL)originalSelector withMethod:(SEL)newSelector;


/**
 实例方法交换
 
 @param originalSelector    原始实例方法名
 @param newSelector         新实例方法名
 */
+ (void)yg_swizzlingInstanceMethod:(SEL)originalSelector withMethod:(SEL)newSelector;

@end

NS_ASSUME_NONNULL_END
