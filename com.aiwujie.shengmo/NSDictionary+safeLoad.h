//
//  NSDictionary+safeLoad.h
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/14.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (safeLoad)
- (id)safeObj:(id)key;
-(NSString*) getNSString : (id)key;


@end

NS_ASSUME_NONNULL_END
