//
//  IDCardCaptureViewController.h
//  FBYIDCardRecognition-iOS
//
//  Created by 范保莹 on 2017/12/29.
//  Copyright © 2017年 FBYIDCardRecognition-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDInfo.h"

@interface IDCardCaptureViewController : UIViewController
@property (nonatomic, copy) void(^sureclick)(IDInfo *info, UIImage *idimg);
@end
