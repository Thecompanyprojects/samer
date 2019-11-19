//
//  chatmikelistView.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/9/17.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol mikelistDelegate <NSObject>

-(void)mikelistinfovc:(NSString *)userId;

-(void)refreshmikeView;

@end

@interface chatmikelistView : UIView
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,weak) id <mikelistDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
