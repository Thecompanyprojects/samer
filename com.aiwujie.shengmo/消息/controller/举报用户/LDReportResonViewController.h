//
//  LDReportResonViewController.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/15.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)(NSString *reason);

@interface LDReportResonViewController : UIViewController

//举报传入的类型
@property (nonatomic,copy) NSString *type;

//动态id
@property (nonatomic,copy) NSString *did;

//其他举报的需要的参数
@property (nonatomic,copy) NSString *reason;

@property (nonatomic,strong) MyBlock block;

@end
