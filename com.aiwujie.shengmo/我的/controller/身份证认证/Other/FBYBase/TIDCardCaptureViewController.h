//
//  TIDCardCaptureViewController.h
//  FBYIDCardRecognition-iOS
//
//  Created by 范保莹 on 2018/1/5.
//  Copyright © 2018年 FBYIDCardRecognition-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDInfo.h"

@interface TIDCardCaptureViewController : UIViewController
@property (nonatomic, copy) void(^sureclick)(IDInfo *info, UIImage *idimg);
@end
