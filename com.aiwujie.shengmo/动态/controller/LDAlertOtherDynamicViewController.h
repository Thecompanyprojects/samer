//
//  LDAlertOtherDynamicViewController.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/8/1.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MyBlock)(NSString *content);
@interface LDAlertOtherDynamicViewController : UIViewController

//动态的id
@property (nonatomic,copy) NSString *did;
@property (nonatomic,copy) MyBlock block;
@end
