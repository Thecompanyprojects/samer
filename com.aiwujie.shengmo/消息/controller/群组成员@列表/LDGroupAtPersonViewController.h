//
//  LDGroupAtPersonViewController.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/11.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)(RCUserInfo *user);

@interface LDGroupAtPersonViewController : UIViewController

@property (nonatomic,strong) MyBlock block;

@property (nonatomic,copy) NSString *groupId;

@end
