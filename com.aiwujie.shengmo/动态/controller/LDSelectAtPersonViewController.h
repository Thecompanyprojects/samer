//
//  LDSelectAtPersonViewController.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/2.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)(NSString *allUid,int personNumber);
typedef void(^NewMyBlock)(NSMutableArray *allUid,NSMutableArray *nameArr,int personNumber);
@interface LDSelectAtPersonViewController : UIViewController

@property (nonatomic,strong) MyBlock block;
@property (nonatomic,strong) NewMyBlock newblock;
@property (nonatomic,strong) NSMutableArray *nameArray;
@property (nonatomic,strong) NSMutableArray * selectArray;
@property (nonatomic,strong) NSMutableArray *nameArray2;
@property (nonatomic,strong) NSMutableArray *selectArray2;
@property (nonatomic,strong) NSMutableArray * liaoselectArray;
@property (nonatomic,strong) NSMutableArray * liaonameArray;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) NSMutableArray *uidArray;
@property (nonatomic,assign) BOOL isfromGroup;
@end
