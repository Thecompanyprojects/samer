//
//  chatuserinfolistView.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/3.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol userlistDelegate <NSObject>

-(void)userlistinfovc:(NSString *)userId;

-(void)refreshView;
@end
@interface chatuserinfolistView : UIView
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,weak) id <userlistDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
