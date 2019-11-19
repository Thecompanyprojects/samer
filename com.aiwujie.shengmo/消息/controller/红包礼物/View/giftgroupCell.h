//
//  giftgroupCell.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/11.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "giftgroupModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol giftDelegate <NSObject>

-(void)iconTabVClick:(UITableViewCell *)cell;

@end
@interface giftgroupCell : UITableViewCell

@property (nonatomic,weak) id <giftDelegate> delegate;
@property (nonatomic,strong) giftgroupModel *model;
@end

NS_ASSUME_NONNULL_END
