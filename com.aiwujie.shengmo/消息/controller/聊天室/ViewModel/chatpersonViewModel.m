//
//  chatpersonViewModel.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/1.
//  Copyright © 2019 a. All rights reserved.
//

#import "chatpersonViewModel.h"

@implementation chatpersonViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _news = [NSMutableArray array];
        
    }
    return self;
}

- (void)getNewsList{
    __weak typeof(self) weakSelf = self;
    [NetManager afPostRequest:[PICHEADURL stringByAppendingString:chatroomUserlistUrl] parms:@{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"roomid":roomidStr?:@""} finished:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
           
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[chatpersonModel class] json:responseObj[@"data"][@"users"]]];
            [weakSelf.news addObjectsFromArray:data];
            
            NSDictionary *dic = [responseObj objectForKey:@"data"];
            weakSelf.total = [dic objectForKey:@"total"]?:@"0";
            
        }
        if (weakSelf.newsListBlock) {
            weakSelf.newsListBlock();
        }
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)chooseInfo
{
    __weak typeof(self) weakSelf = self;
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *url = [PICHEADURL stringByAppendingString:chatroomUserinfoUrl];
    NSDictionary *param = @{@"uid":uid};
    [NetManager afPostRequest:url parms:param finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSDictionary *dic = [responseObj objectForKey:@"data"];
            weakSelf.rule = [dic objectForKey:@"rule"]?:@"0";
           
        }
        if (self.infoBlock) {
            self.infoBlock();
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}


-(void)getmikeinfo
{
    __weak typeof(self) weakSelf = self;
    NSString *roomid = roomidStr.copy;
    NSString *url = [PICHEADURL stringByAppendingString:getChatListMicUrl];
    [NetManager afPostRequest:url parms:@{@"roomid":roomid} finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[chatpersonModel class] json:responseObj[@"data"]]];
            [weakSelf.news addObjectsFromArray:data];
            
        }
        if (weakSelf.newsListBlock) {
            weakSelf.newsListBlock();
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

@end
