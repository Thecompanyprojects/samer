//
//  LDVIPMemberView.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/11/21.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LDVIPMemberDelegate <NSObject>// 代理传值方法
@optional
-(void)vipMemberProtcolDidSelect;
@end

@interface LDVIPMemberView : UIView
-(instancetype)initWithVIPtype:(NSString *)type;
@property (nonatomic,copy) UILabel *moneyLabel;
@property (nonatomic,weak) id <LDVIPMemberDelegate> delegate;
@end
