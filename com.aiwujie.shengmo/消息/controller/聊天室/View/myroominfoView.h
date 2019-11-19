//
//  myroominfoView.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/20.
//  Copyright © 2019 a. All rights reserved.
//

#import "roominfoView.h"
#import "infoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface myroominfoView : UIView

@property (nonatomic,copy) NSString *userId;
-(void)getuserinfofromWeb;

@property (nonatomic,strong) UIButton *mikeBtn;

@property (nonatomic,assign) BOOL  isfocus;
@property (nonatomic,strong) infoModel *model;
@property (nonatomic,assign) BOOL isshang;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIButton *infoBtn;
@end

NS_ASSUME_NONNULL_END
