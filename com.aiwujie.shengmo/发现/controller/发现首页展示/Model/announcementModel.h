//
//  announcementModel.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/18.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface announcementModel : NSObject
@property (nonatomic , copy) NSString              * Newid;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * pic;
@property (nonatomic , copy) NSString              * url;
@property (nonatomic , copy) NSString              * url_type;// 0url，1动态id，2话题id，3主页id

@end

NS_ASSUME_NONNULL_END
