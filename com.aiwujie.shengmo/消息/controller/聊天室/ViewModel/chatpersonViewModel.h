//
//  chatpersonViewModel.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/1.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "chatpersonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface chatpersonViewModel : NSObject

@property (nonatomic, copy, readonly) __block NSMutableArray *news;
@property (nonatomic, copy) __block NSString *total;
@property (nonatomic, copy) __block void (^newsListBlock)(void);
@property (nonatomic, copy) __block NSString *rule;
@property (nonatomic, copy) __block void (^infoBlock)(void);

- (void)getNewsList;
-(void)chooseInfo;
-(void)getmikeinfo;
@end

NS_ASSUME_NONNULL_END
