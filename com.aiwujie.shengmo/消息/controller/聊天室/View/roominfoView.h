//
//  roominfoView.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/1.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "infoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface roominfoView : UIView

@property (nonatomic,copy) NSString *userId;
-(void)getuserinfofromWeb;
@property (nonatomic,strong) UIButton *giftBtn;
@property (nonatomic,strong) UIButton *focusBtn;
@property (nonatomic,strong) UIButton *noticeBtn;
@property (nonatomic,strong) UIButton *mikeBtn;
@property (nonatomic,strong) UIButton *bannedBtn;
@property (nonatomic,strong) UIButton *kickedBtn;
@property (nonatomic,assign) BOOL  isfocus;
@property (nonatomic,strong) infoModel *model;
@property (nonatomic,assign) BOOL isshang;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UIButton *infoBtn;
@property (nonatomic,strong) UIView *bgView;
@end

NS_ASSUME_NONNULL_END
