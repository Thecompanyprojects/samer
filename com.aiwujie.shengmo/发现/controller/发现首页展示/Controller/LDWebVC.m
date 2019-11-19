//
//  LDWebVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/9/8.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDWebVC.h"

@interface LDWebVC ()

@end

@implementation LDWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backItemImgName = @"back";
    [self updateNavigationItems];
    self.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
}

@end
