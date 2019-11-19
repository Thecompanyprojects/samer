//
//  LDMyReceiveGifViewController.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnValueBlock) (NSString* numStr);

@interface LDMyReceiveGifViewController : UIViewController
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;
@end
