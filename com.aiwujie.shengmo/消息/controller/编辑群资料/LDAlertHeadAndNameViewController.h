//
//  LDAlertHeadAndNameViewController.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/17.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDAlertHeadAndNameViewController : UIViewController

@property (nonatomic,copy) NSString *headUrl;

@property (nonatomic,copy) NSString *groupName;

@property (nonatomic,copy) NSString *gid;

@property (nonatomic,assign) BOOL isliaotians;

@property (nonatomic,strong) void (^myBlock)(NSDictionary *dic);

@property (nonatomic,strong) NSDictionary *infoDic;

@property (nonatomic,copy) NSString *roomId;
@end
