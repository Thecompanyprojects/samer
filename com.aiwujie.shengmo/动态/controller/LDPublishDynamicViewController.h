//
//  LDPublishDynamicViewController.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/21.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDPublishDynamicViewController : LDBaseViewController
//存储选择参与的话题字符串,点击了哪个话题
@property (copy, nonatomic)  NSString *topicString;
@property (copy, nonatomic)  NSString *topicTid;
@property (nonatomic,assign) NSInteger index;
@end
