//
//  LDhistoryViewModel.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/24.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDhistoryViewModel.h"

@interface LDhistoryViewModel()
@property (nonatomic, strong)  NSMutableArray *news;
@end

@implementation LDhistoryViewModel

- (instancetype)initWithGoods:(LDhistorynameModel *)nameModel
{
    self = [super init];
    if (self) {
        _news = [NSMutableArray array];
        self.nameModel = nameModel;
        self.NewId = nameModel.NewId;
        self.nickname = nameModel.nickname;
        self.addtime = nameModel.addtime;
        self.uid = nameModel.uid;
    }
    return self;
}

- (void)getNewsList{
    __weak typeof(self) weakSelf = self;
    NSDictionary *para = @{@"uid":self.uid?:@""};
    [NetManager afPostRequest:[PICHEADURL stringByAppendingString:getEditnicknameListUrl] parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[LDhistorynameModel class] json:responseObj[@"data"]]];
            [weakSelf.news addObjectsFromArray:data];
        }
        if (weakSelf.newsListBlock) {
            weakSelf.newsListBlock(weakSelf.news);
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

@end
