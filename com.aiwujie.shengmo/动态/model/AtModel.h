//
//  AtModel.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/4.
//  Copyright © 2017年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AtModel : NSObject

@property (nonatomic,assign) int uid;

@property (nonatomic,assign) int addtime;

@property (nonatomic,copy) NSString *nickname;

@property (nonatomic,copy) NSString *head_pic;

@property (nonatomic,assign) int did;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *pic;

@end
