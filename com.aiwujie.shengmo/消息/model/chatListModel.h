//
//  chatListModel.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/9.
//  Copyright © 2017年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chatListModel : NSObject

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *lastMessage;

@property (nonatomic,assign) BOOL select;

@end
