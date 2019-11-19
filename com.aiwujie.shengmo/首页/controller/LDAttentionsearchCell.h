//
//  LDAttentionsearchCell.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/8.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDAttentionsearchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LDAttentionsearchCell : UITableViewCell
@property (nonatomic,strong) LDAttentionsearchModel *model;
@property (nonatomic,copy) NSString *searchStr;
@end

NS_ASSUME_NONNULL_END
