//
//  ldchatroominfoCell2.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/9/17.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ldchatroominfoCell2 : UITableViewCell
@property (nonatomic,copy) NSString *mictype;
-(void)setdata;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@end

NS_ASSUME_NONNULL_END
