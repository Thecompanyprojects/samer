//
//  mikeinfoView.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/9/15.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol mkinfoDelegate <NSObject>
-(void)mikeinfovc:(NSString *)userId;
@end

@interface mikeinfoView : UIView
@property (nonatomic,weak) id <mkinfoDelegate> delegate;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,copy) NSString *micnum;
@property (nonatomic,strong) NSMutableArray *talkArray;
@end

NS_ASSUME_NONNULL_END
