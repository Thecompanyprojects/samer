//
//  NTImageBrowser.h
//  NTImageBrowser
//
//  Created by Nineteen on 10/5/16.
//  Copyright © 2016 Nineteen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void (^ReturnBlock) (void);
@interface NTImageBrowser : NSObject
+ (instancetype)sharedShow;
/*
 * 将实现细节封装为一个类方法
 *
 * @param imageView : 需要进行图片放大的imageView
 */
-(void)showImageBrowserWithImageView :(NSString *)imageUrl;
@property(nonatomic, copy) ReturnBlock returnBlock;
@end
