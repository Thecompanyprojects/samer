//
//  YSActionSheetView.h
//  ShareAlertDemo
//
//  Created by dev on 2018/5/23.
//  Copyright © 2018年 nys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSActionSheetButton.h"

@protocol PlatformButtonClickDelegate <NSObject>

- (void) customActionSheetButtonClick:(YSActionSheetButton *) btn;

@end

@interface YSActionSheetView : UIView

-(instancetype)initNYSView;
@property (nonatomic, copy) NSString *shareId;
@property (nonatomic, weak) id<PlatformButtonClickDelegate> delegate;
@property (nonatomic, copy) NSString *comeFrom;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, assign) BOOL isTwo;
@end
