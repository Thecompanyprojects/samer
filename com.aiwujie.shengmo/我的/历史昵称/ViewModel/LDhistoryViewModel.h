//
//  LDhistoryViewModel.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/24.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDhistoryViewModel.h"
#import "LDhistorynameModel.h"
//
//@protocol historydelegate <NSObject>
//
////@optional
//-(void)setDatafromModel:(NSMutableArray *)dataArray;
//
//@end

NS_ASSUME_NONNULL_BEGIN

@interface LDhistoryViewModel : NSObject
@property (nonatomic,copy) NSString *uid;
@property (nonatomic, strong) LDhistorynameModel *nameModel;
@property (nonatomic,copy) NSString *NewId;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *addtime;

@property (nonatomic, copy) __block void (^newsListBlock)(NSArray *array);
- (instancetype)initWithGoods:(LDhistorynameModel *)nameModel;
- (void)getNewsList;
@end

NS_ASSUME_NONNULL_END
