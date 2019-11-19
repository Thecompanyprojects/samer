//
//  LDDynamicDetailViewController.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/14.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModel.h"

//赞或取消赞的block
typedef void(^MyZanBlock)(NSString *zanNum,NSString *zanState);

//评论或删除评论的block
typedef void(^MyCommentBlock)(NSString *commentNum);

//打赏的block
typedef void(^MyRewordBlock)(NSString *rewordNum);

//删除动态的block
typedef void(^MyDeleteBlock)(void);

@interface LDDynamicDetailViewController : UIViewController

@property (nonatomic,strong) MyZanBlock block;

@property (nonatomic,strong) MyCommentBlock commentBlock;

@property (nonatomic,strong) MyRewordBlock rewordBlock;

@property (nonatomic,strong) MyDeleteBlock deleteBlock;

//动态的id
@property (nonatomic,copy) NSString *did;

//发布本条动态的人的uid
@property(nonatomic,copy) NSString *ownUid;

@property (nonatomic,copy) NSString *clickState;

@property (nonatomic,copy) void(^returnblock)(NSString *tag);
@end
