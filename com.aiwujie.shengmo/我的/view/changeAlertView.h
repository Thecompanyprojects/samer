//
//  changeAlertView.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/22.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^returnBlock)(NSDictionary *dic);

@interface changeAlertView : UIView
@property (nonatomic,copy) NSString *numStr;
@property(nonatomic,copy)returnBlock returnClick;
@property (nonatomic,strong) UILabel *messageLab;
-(void)withReturnClick:(returnBlock)block;
@end

NS_ASSUME_NONNULL_END
