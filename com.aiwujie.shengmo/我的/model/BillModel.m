//
//  BillModel.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/12.
//  Copyright © 2017年 a. All rights reserved.
//

#import "BillModel.h"

@implementation BillModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{@"Newlong" : @"long"};
}


@end
