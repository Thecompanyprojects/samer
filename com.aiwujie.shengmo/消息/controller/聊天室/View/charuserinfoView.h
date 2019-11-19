//
//  charuserinfoView.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/31.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol roomDelegate <NSObject>

-(void)touserinfovc:(NSString *)userId;
@end

@interface charuserinfoView : UIView
@property (nonatomic,weak) id <roomDelegate> delegate;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

NS_ASSUME_NONNULL_END
