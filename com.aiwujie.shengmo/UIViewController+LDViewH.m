//
//  UIViewController+LDViewH.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/10/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import "UIViewController+LDViewH.h"

@implementation UIViewController (LDViewH)

-(CGFloat)getIsIphoneX:(BOOL)isIphoneX{
    
    if (isIphoneX) {
        
        return  HEIGHT - IPHONEXTOPH - IPHONEXBOTTOMH;
    }
    
    return HEIGHT - 64;
}

-(CGFloat)getIsIphoneXNAV:(BOOL)isIphoneX{
    
    if (isIphoneX) {
        
        return  51;
    }
    
    return 27;
}

-(CGFloat)getIsIphoneXNAVBottom:(BOOL)isIphoneX{
    
    if (isIphoneX) {
        
        return  84;
    }
    
    return 60;
}

-(CGFloat)getIsIphoneXNAVRightDog:(BOOL)isIphoneX{
    
    if (isIphoneX) {
        
        return  48;
    }
    
    return 24;
}

@end
