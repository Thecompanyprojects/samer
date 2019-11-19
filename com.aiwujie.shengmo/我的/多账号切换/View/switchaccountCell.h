//
//  switchaccountCell.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/5.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDswitchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface switchaccountCell : UITableViewCell
@property (nonatomic,strong) LDswitchModel *model;
@property (nonatomic,strong) UIImageView *changeImg;
@end

NS_ASSUME_NONNULL_END
