//
//  bottomView.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/18.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface bottomView : UIView
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIButton *zanBtn;
@property (nonatomic,strong) UIButton *commentBtn;
@property (nonatomic,strong) UIButton *replyBtn;
@property (nonatomic,strong) UIButton *topBtn;

@property (nonatomic,assign) BOOL isfromDis;
@end

NS_ASSUME_NONNULL_END
