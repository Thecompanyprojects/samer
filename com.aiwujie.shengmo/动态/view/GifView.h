//
//  GifView.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/20.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GifView : UIView

@property (nonatomic,strong) void (^MyBlock)(void);
@property (nonatomic,strong) void (^successBlock)(void);
@property (nonatomic,strong) void (^sendmessageBlock)(NSDictionary *dic);

@property (nonatomic,assign) BOOL isfromGroup;

@property (nonatomic,assign) BOOL isfromchatroom;

@property (nonatomic,copy) NSString *is_home;//1：个人主页   2：私聊
@property (nonatomic,copy) NSString *groupid;

//获取界面传过来的动态id.位置,及从哪个界面传过来的标记
-(void)getDynamicDid:(NSString *)did andIndexPath:(NSIndexPath *)indexPath andSign:(NSString *)sign andUIViewController:(UIViewController *)controller;

//获取界面传过来的赠送给人的UID及标记
-(void)getPersonUid:(NSString *)userId andSign:(NSString *)sign andUIViewController:(UIViewController *)controller;

//显示送礼物
-(instancetype)initWithFrame:(CGRect)frame andisMine:(BOOL )ismine :(void (^)(void))block;

//移除送礼物页面
-(void)removeView;

@end
