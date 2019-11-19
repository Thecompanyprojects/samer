//
//  imagebrowserVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/5.
//  Copyright © 2019 a. All rights reserved.
//

#import "imagebrowserVC.h"
#import "NTImageBrowser.h"

@interface imagebrowserVC ()

@end

@implementation imagebrowserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self takeScreennotification];
    // Do any additional setup after loading the view.
    [[NTImageBrowser sharedShow] showImageBrowserWithImageView:self.imageUrl];
    [NTImageBrowser sharedShow].returnBlock = ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(jiePing) object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    };
}

/**
 监测用户截图操作
 */
-(void)takeScreennotification
{
//    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jiePing) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

-(void)jiePing
{
    if (self.returnBlock) {
        self.returnBlock();
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(jiePing) object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

@end
