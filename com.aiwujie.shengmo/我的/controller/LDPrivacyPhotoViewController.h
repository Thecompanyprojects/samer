//
//  LDPrivacyPhotoViewController.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/4.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)(NSString *string);

@interface LDPrivacyPhotoViewController : UIViewController

@property (nonatomic,strong) MyBlock block;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *privacyString;

@property (nonatomic,copy) NSString *attentString;

@property (nonatomic,copy) NSString *groupString;

@end
