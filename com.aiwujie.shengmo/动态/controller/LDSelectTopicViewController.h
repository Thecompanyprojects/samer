//
//  LDSelectTopicViewController.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/10/13.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectBlock)(NSString *title,NSString *tid);

@interface LDSelectTopicViewController : UIViewController

@property (nonatomic,copy) NSString * pid;

@property (nonatomic,strong) selectBlock block;

@end
