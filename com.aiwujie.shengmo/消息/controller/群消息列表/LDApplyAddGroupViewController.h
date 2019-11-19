//
//  LDApplyAddGroupViewController.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/18.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,chatSystemType){
    
    chatSystemTypeApply = 0,
    
    chatSystemTypeFollowMessage
    
};

@interface LDApplyAddGroupViewController : UIViewController

@property (nonatomic,assign) NSInteger chatSystemType;

@end
