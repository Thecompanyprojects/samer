//
//  LDHistorynameCell.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/9/8.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LDhistoryViewModel;
NS_ASSUME_NONNULL_BEGIN
@interface LDHistorynameCell : UITableViewCell
- (void)bindViewModel:(LDhistoryViewModel *)viewModel;
@end

NS_ASSUME_NONNULL_END
