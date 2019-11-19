//
//  AlertTool.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/11/4.
//  Copyright © 2017年 a. All rights reserved.
//

#import "AlertTool.h"

static NSString *_stampNum;

@implementation AlertTool

/**
 * 一般的正面弹框提示
 */
+(void)alertWithViewController:(UIViewController *)controller andTitle:(NSString *)title andMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message    preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:nil];
    [alert addAction:action];
    [controller presentViewController:alert animated:YES completion:nil];
}



/**
 账号下线的提示

 @param controller 当前控制器
 @param title title
 @param message message
 */
+(void)alertqute:(UIViewController *)controller andTitle:(NSString *)title andMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message    preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault  handler:nil];
    [alert addAction:action];
    [controller presentViewController:alert animated:YES completion:nil];
}

/**
 * 兑换会员的弹框提示
 */
+(void)alertWithViewController:(UIViewController *)controller type:(NSString *)type num:(NSString *)numStr andAlertDidSelectItem:(void(^)(int index, NSString *viptype))selectBlock;{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
    
    //礼物魔豆兑换充值魔豆
    UIAlertAction *ChangeAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@%@",type,@"兑换金魔豆"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (selectBlock) {
            selectBlock(1, @"CHANGEMODOU");
        }
    }];
    
    UIAlertAction *SVIPAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@%@",type,@"兑换SVIP"] style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray *SVIPArray = @[@"1个月/1280金魔豆", @"3个月/3480金魔豆(优惠9%)", @"8个月/8980金魔豆(优惠13%)", @"12个月/12980金魔豆(优惠16%)"];
        NSMutableArray *arrs = [NSMutableArray new];
        NSString *newStr = @"";
        if (numStr.length==0) {
            newStr = @"0";
        }
        else
        {
            newStr = numStr;
        }
        [arrs addObject:[NSString stringWithFormat:@"%@%@%@",@"(剩余",newStr,@"金魔豆)"]];
        [arrs addObjectsFromArray:SVIPArray];
        
        UIAlertController *SVIPAlert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (int i = 0; i < arrs.count; i++) {
            UIAlertAction *month = [UIAlertAction actionWithTitle:arrs[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (selectBlock) {
                    selectBlock(i, @"SVIP");
                }
            }];
            
            [SVIPAlert addAction:month];
            if (PHONEVERSION.doubleValue >= 8.3&&i!=0) {
                [month setValue:MainColor forKey:@"_titleTextColor"];
            }
            if (PHONEVERSION.doubleValue >= 8.3&&i==0) {
                [month setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
            }
        }
        [self cancelActionWithAlert:SVIPAlert];
        [controller presentViewController:SVIPAlert animated:YES completion:nil];
    }];
    
    UIAlertAction * VIPAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@%@",type,@"兑换VIP"] style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        NSString *newStr = @"";
        if (numStr.length==0) {
            newStr = @"0";
        }
        else
        {
            newStr = numStr;
        }
        NSArray *VIPArray = @[[NSString stringWithFormat:@"%@%@%@",@"(剩余",newStr,@"金魔豆)"],@"1个月/300金魔豆", @"3个月/880金魔豆(优惠3%)", @"6个月/1680金魔豆(优惠7%)", @"12个月/2980金魔豆(优惠18%)"];
        
        UIAlertController *VIPAlert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (int i = 0; i < VIPArray.count; i++) {
            
            UIAlertAction *month = [UIAlertAction actionWithTitle:VIPArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (selectBlock) {
                    
                    selectBlock(i, @"VIP");
                }
                
            }];
            
            [VIPAlert addAction:month];
            
            if (PHONEVERSION.doubleValue >= 8.3&&i!=0) {
                [month setValue:MainColor forKey:@"_titleTextColor"];
            }
            if (PHONEVERSION.doubleValue >= 8.3&&i==0) {
                [month setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
            }
        }
        
        [self cancelActionWithAlert:VIPAlert];
        
        [controller presentViewController:VIPAlert animated:YES completion:nil];
    }];
    
    UIAlertAction *topcareAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@%@",type,@"兑换推顶卡"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *newStr = @"";
        if (numStr.length==0) {
            newStr = @"0";
        }
        else
        {
            newStr = numStr;
        }
        NSArray *TopcardArray = @[[NSString stringWithFormat:@"%@%@%@",@"(剩余",newStr,@"金魔豆)"],@"1张/300金魔豆", @"3张/860金魔豆(9.5折)", @"10张/2700金魔豆(9.1折)", @"30张/7650金魔豆(8.6折)", @"90张/21600金魔豆(8折)", @"270张/60750金魔豆(7.5折)"];
        
        UIAlertController *VIPAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (int i = 0; i < TopcardArray.count; i++) {
            UIAlertAction *month = [UIAlertAction actionWithTitle:TopcardArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (selectBlock) {
                    selectBlock(i, @"TOPCARD");
                }
            }];
            [VIPAlert addAction:month];
            
            if (PHONEVERSION.doubleValue >= 8.3&&i!=0) {
                [month setValue:MainColor forKey:@"_titleTextColor"];
            }
            if (PHONEVERSION.doubleValue >= 8.3&&i==0) {
                [month setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
            }

        }
        [self cancelActionWithAlert:VIPAlert];
        [controller presentViewController:VIPAlert animated:YES completion:nil];
    }];
    

    UIAlertAction *chargeAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@%@",type,@"兑换邮票"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *newStr = @"";
        if (numStr.length==0) {
            newStr = @"0";
        }
        else
        {
            newStr = numStr;
        }
        NSArray *TopcardArray = @[[NSString stringWithFormat:@"%@%@%@",@"(剩余",newStr,@"金魔豆)"],@"3张/60金魔豆", @"10张/200金魔豆", @"30张/600金魔豆", @"50张/1000金魔豆", @"100张/2000金魔豆", @"300张/6000金魔豆"];
        
        UIAlertController *VIPAlert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (int i = 0; i < TopcardArray.count; i++) {
            UIAlertAction *month = [UIAlertAction actionWithTitle:TopcardArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (selectBlock) {
                    selectBlock(i, @"YOUPIAO");
                }
            }];
            [VIPAlert addAction:month];
            
            if (PHONEVERSION.doubleValue >= 8.3&&i!=0) {
                [month setValue:MainColor forKey:@"_titleTextColor"];
            }
            if (PHONEVERSION.doubleValue >= 8.3&&i==0) {
                [month setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
            }
        }
        
        [self cancelActionWithAlert:VIPAlert];
        [controller presentViewController:VIPAlert animated:YES completion:nil];
    }];
    
    if ([type isEqualToString:@"银魔豆"]) {
        [alert addAction:ChangeAction];
    }
    
    [alert addAction:VIPAction];
    [alert addAction:SVIPAction];
    [alert addAction:chargeAction];
    [alert addAction:topcareAction];
    [self cancelActionWithAlert:alert];
    if (PHONEVERSION.doubleValue >= 8.3) {
        [ChangeAction setValue:MainColor forKey:@"_titleTextColor"];
        [SVIPAction setValue:MainColor forKey:@"_titleTextColor"];
        [VIPAction setValue:MainColor forKey:@"_titleTextColor"];
        [chargeAction setValue:MainColor forKey:@"_titleTextColor"];
        [topcareAction setValue:MainColor forKey:@"_titleTextColor"];
    }
    [controller presentViewController:alert animated:YES completion:nil];
}

/**
 * 兑换邮票的弹框提示
 */
+ (void)alertWithViewController:(UIViewController *)controller type:(NSString *)type andAlertInputStampsNumber:(void (^)(NSString *stampNumbers, NSString *channel))stampNumBlock{
   
    UIAlertController *numberAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@",type,@"兑换邮票"] message:@"(请输入兑换张数)"  preferredStyle:UIAlertControllerStyleAlert];
    
    [numberAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"兑换" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        NSScanner *scan = [NSScanner scannerWithString:_stampNum];
        int val;
        if (_stampNum.length > 0 && [_stampNum intValue] > 0 && ![_stampNum hasPrefix:@"0"] && ([scan scanInt:&val] && [scan isAtEnd])) {
            
            if (stampNumBlock) {
                
                if ([type isEqualToString:@"充值魔豆"]) {
                    
                    stampNumBlock(_stampNum, @"0");
                    
                }else{
                    
                    stampNumBlock(_stampNum, @"1");
                }
            }
        }else{
            [self alertWithViewController:controller andTitle:@"提示" andMessage:@"输入兑换数量有误,请重新输入~"];
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
    
    [numberAlert addAction:sureAction];
    [self cancelActionWithAlert:numberAlert];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        
        [sureAction setValue:MainColor forKey:@"_titleTextColor"];
        
    }
    [controller presentViewController:numberAlert animated:YES completion:nil];
}

+ (void)handleTextFieldTextDidChangeNotification:(NSNotification *)noti{
    
    UITextField *textield = noti.object;
    
    _stampNum = textield.text;
}

//创建取消的按钮
+ (void)cancelActionWithAlert:(UIAlertController *)alert{
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
    
    [alert addAction:cancelAction];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        
        [cancelAction setValue:MainColor forKey:@"_titleTextColor"];
    }
}


@end

