//
//  toreceiveCell.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/10.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "toreceiveModel.h"
#import "redgroupModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol toreceiveDelegate
-(void)touchup:(UITableViewCell *)cell;
@end

@interface toreceiveCell : UITableViewCell
@property (nonatomic,weak) id <toreceiveDelegate> delegate;
@property (nonatomic,strong) toreceiveModel *model;
-(void)create:(redgroupModel *)model;
@end

NS_ASSUME_NONNULL_END
