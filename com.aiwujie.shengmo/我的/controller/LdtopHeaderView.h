//
//  LdtopHeaderView.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/11.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LdtopHeaderView : UICollectionReusableView
@property (nonatomic,strong) UILabel *contentLab;
-(void)setTextFromurl:(NSString *)number;
@end

NS_ASSUME_NONNULL_END
