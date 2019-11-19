//
//  LDAlertNameandIntroduceViewController.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/7.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)(NSString *content);

@interface LDAlertNameandIntroduceViewController : UIViewController
@property (nonatomic,strong) MyBlock block;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *type;
@end
