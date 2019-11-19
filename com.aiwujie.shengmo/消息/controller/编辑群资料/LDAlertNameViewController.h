//
//  LDAlertNameViewController.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/17.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)(NSString *name);

@interface LDAlertNameViewController : UIViewController

@property (nonatomic,strong) MyBlock block;

@property (nonatomic,copy) NSString *groupName;

@property (nonatomic,copy) NSString *gid;

@property (nonatomic,copy) NSString *type;
@property (nonatomic,assign) BOOL isliaotians;
@property (nonatomic,copy) NSString *roomId;
@end
