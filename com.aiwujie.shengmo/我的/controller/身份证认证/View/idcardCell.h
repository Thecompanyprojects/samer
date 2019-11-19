//
//  idcardCell.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/12.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "idcardImg.h"
NS_ASSUME_NONNULL_BEGIN

@interface idcardCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) idcardImg *idimg;
@end

NS_ASSUME_NONNULL_END
