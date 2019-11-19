//
//  LDSignView.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/7/6.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDSignView.h"
#import "AppDelegate.h"
#import "FlowFlower.h"
#import "UIImage+Extension.h"

@interface LDSignView ()

@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) UILabel *signDaysLabel;

//签到按钮
@property (nonatomic,strong) UIImageView *gifImageView;

//签到次数
@property (nonatomic,copy) NSString *signtimes;

//签到按钮
@property (nonatomic,strong) UIButton *signButton;

@end

@implementation LDSignView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self createUI:frame];
    }
    
    return self;
}

-(void)createUI:(CGRect)frame{
    
    CGFloat backW = WIDTH - 20;
    
    CGFloat backH = 0;
    
    if (HEIGHT == 480) {
        
        backH = HEIGHT - 80;
        
    }else if (HEIGHT == 667) {
        
        backH = HEIGHT - 200;
        
    }else if(HEIGHT == 568){
    
        backH = HEIGHT - 140;
        
    }else if (HEIGHT == 812){
        
        backH = HEIGHT - 350;
        
    }else{
    
        backH = HEIGHT - 240;
    }

    self.backgroundColor = [UIColor clearColor];
    
    UIButton *singleButton = [[UIButton alloc] initWithFrame:frame];
    [singleButton addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:singleButton];
    
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(10 ,(HEIGHT - backH)/2, backW, backH)];
    back.backgroundColor = [UIColor clearColor];
    [self addSubview:back];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backW, backH/5)];
    titleView.backgroundColor =  [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1];
    titleView.alpha = 0.8;
    [back addSubview:titleView];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 50, 5, 25, 25)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"礼物删除按钮"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [back addSubview:closeButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, backH/5/4, backW, backH/5/4)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"每周签到7天可抽取神秘大礼箱";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [back addSubview:titleLabel];
    
    _signDaysLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 ,backH/5/2 + 10, backW, backH/5/4)];
    _signDaysLabel.textColor = [UIColor whiteColor];
    _signDaysLabel.textAlignment = NSTextAlignmentCenter;
    _signDaysLabel.font = [UIFont systemFontOfSize:13];
    [back addSubview:_signDaysLabel];
    
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0 ,backH/5 , backW, backH - backH/5)];
    background.backgroundColor = [UIColor blackColor];
    background.alpha = 0.8;
    [back addSubview:background];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0 ,backH/5 , backW, backH - backH/5)];
    _backView.backgroundColor = [UIColor clearColor];
    [back addSubview:_backView];
    
    NSArray *daysArray = @[@"第1天",@"第2天",@"第3天",@"第4天",@"第5天",@"第6天",@"第7天"];
    
    NSArray *gifArray = @[@"幸运草",@"糖果",@"玩具狗",@"抽奖礼包",@"签到通用邮票",@"3张任务邮票",@"抽奖大礼箱"];
    
    NSArray *gifNameArray = @[@"幸运草(1魅力)",@"糖果(3魅力)",@"玩具狗(5魅力)",@"抽奖礼包",@"通用邮票",@"3张任务邮票",@"抽奖大礼箱"];
    
    for (int i = 0; i < 4; i++) {
        
        UIView *gifView = [[UIView alloc] initWithFrame:CGRectMake(10 + i * (backW - 35)/4 + 5 * i, 15, (backW - 35)/4, 30 + (backW - 35)/4)];
        gifView.layer.borderColor = [UIColor whiteColor].CGColor;
        gifView.layer.borderWidth = 1;
        gifView.layer.cornerRadius = 2;
        gifView.clipsToBounds = YES;
        [_backView addSubview:gifView];
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (backW - 35)/4, 20)];
        dayLabel.textColor = [UIColor whiteColor];
        dayLabel.font = [UIFont systemFontOfSize:13];
        dayLabel.text = daysArray[i];
        dayLabel.backgroundColor = [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        [gifView addSubview:dayLabel];

        
        UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, (backW - 35)/4, (backW - 35)/4)];
        gifImageView.image = [UIImage imageNamed:gifArray[i]];
        gifImageView.userInteractionEnabled = YES;
        [gifView addSubview:gifImageView];
        
        UILabel *gifNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + i * (backW - 35)/4 + 5 * i, 45 + (backW - 35)/4, (backW - 35)/4, 20)];
        gifNameLabel.text = gifNameArray[i];
        gifNameLabel.font = [UIFont systemFontOfSize:10];
        gifNameLabel.textColor = [UIColor whiteColor];
        gifNameLabel.textAlignment = NSTextAlignmentCenter;
        [_backView addSubview:gifNameLabel];
        
        UIImageView *cornerView = [[UIImageView alloc] initWithFrame:CGRectMake(gifView.frame.size.width - 21, gifView.frame.size.height - 17, 20, 16)];
        cornerView.tag = 20 + i;
        cornerView.hidden = YES;
        cornerView.image = [UIImage imageNamed:@"已签到"];
        [gifView addSubview:cornerView];
        
    }
    
    for (int i = 0; i < 3; i++) {
        
        UIView *gifView = [[UIView alloc] initWithFrame:CGRectMake((backW - ((backW - 35)/4 * 3 + 10))/2 + i * (backW - 35)/4 + 5 * i, 75 + (backW - 35)/4 , (backW - 35)/4, 30 + (backW - 35)/4)];
        gifView.layer.borderColor = [UIColor whiteColor].CGColor;
        gifView.layer.borderWidth = 1;
        gifView.layer.cornerRadius = 2;
        gifView.clipsToBounds = YES;
        [_backView addSubview:gifView];
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (backW - 35)/4, 20)];
        dayLabel.textColor = [UIColor whiteColor];
        dayLabel.font = [UIFont systemFontOfSize:13];
        dayLabel.text = daysArray[i + 4];
        dayLabel.backgroundColor = [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        [gifView addSubview:dayLabel];
        
        
        UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, (backW - 35)/4, (backW - 35)/4)];
        gifImageView.image = [UIImage imageNamed:gifArray[i + 4]];
        gifImageView.userInteractionEnabled = YES;
        [gifView addSubview:gifImageView];
        
        UILabel *gifNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((backW - ((backW - 35)/4 * 3 + 10))/2 + i * (backW - 35)/4 + 5 * i, 105 + (backW - 35)/2, (backW - 35)/4, 20)];
        gifNameLabel.text = gifNameArray[i + 4];
        gifNameLabel.font = [UIFont systemFontOfSize:10];
        gifNameLabel.textColor = [UIColor whiteColor];
        gifNameLabel.textAlignment = NSTextAlignmentCenter;
        [_backView addSubview:gifNameLabel];
        
        UIImageView *cornerView = [[UIImageView alloc] initWithFrame:CGRectMake(gifView.frame.size.width - 21, gifView.frame.size.height - 17, 20, 16)];
        cornerView.tag = 24 + i;
        cornerView.hidden = YES;
        cornerView.image = [UIImage imageNamed:@"已签到"];
        [gifView addSubview:cornerView];
    }
    
    _signButton = [[UIButton alloc] initWithFrame:CGRectMake((backW - ((backW - 60)/4 * 3 + 10))/2, 140 + (backW - 35)/2, backW - (backW - ((backW - 60)/4 * 3 + 10)), backH/10)];
    _signButton.layer.cornerRadius = 2;
    _signButton.clipsToBounds = YES;
    [_signButton addTarget:self action:@selector(signButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _signButton.backgroundColor = [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1];
    [_backView addSubview:_signButton];

}

-(void)signButtonClick{
    
    if ([_signButton.titleLabel.text isEqualToString:@"签到领取"]) {
        
        [_signButton setTitle:@"关闭" forState:UIControlStateNormal];
        
        [_signButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        
        NSString *url = [NSString string];
        
        if ([_signtimes intValue] <= 2) {
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Draw/signOnDay1stTo3rd"];
            
        }else if ([_signtimes intValue] == 3){
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Draw/signOnDay4th"];
            
        }else if ([_signtimes intValue] == 4){
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Draw/signOnDay5th"];
            
        }else if ([_signtimes intValue] == 5){
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Draw/signOnDay6th"];
            
        }else if ([_signtimes intValue] == 6){
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Draw/signOnDay7th"];
        }
        
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"type":_signtimes};
        
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
            
            if (integer != 2000) {
                
                [MBProgressHUD hideHUDForView:self animated:YES];
                
                if (integer == 3000) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:responseObj[@"msg"] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                }else if (integer == 2001){
                    
                    [self createHaveGetGifImage:@"TT"];
                    
                    [self getSignDays:[NSString stringWithFormat:@"%d",[_signtimes intValue] + 1] andsignState:@"已签到"];
                    
                }else if (integer == 2002){
                    
                    [self createHaveGetGifImage:@"内内"];
                    
                    [self getSignDays:[NSString stringWithFormat:@"%d",[_signtimes intValue] + 1] andsignState:@"已签到"];
                    
                }else if (integer == 2003){
                    
                    [self createHaveGetGifImage:@"无"];
                    
                    [self getSignDays:[NSString stringWithFormat:@"%d",[_signtimes intValue] + 1] andsignState:@"已签到"];
                    
                }else if (integer == 2004){
                    
                    [self createHaveGetGifImage:@"年会员"];
                    
                    [self getSignDays:[NSString stringWithFormat:@"%d",[_signtimes intValue] + 1] andsignState:@"已签到"];
                    
                }else if (integer == 2005){
                    
                    [self createHaveGetGifImage:@"会员"];
                    
                    [self getSignDays:[NSString stringWithFormat:@"%d",[_signtimes intValue] + 1] andsignState:@"已签到"];
                    
                }else if (integer == 2006){
                    
                    [self createHaveGetGifImage:@"邮票"];
                    
                    [self getSignDays:[NSString stringWithFormat:@"%d",[_signtimes intValue] + 1] andsignState:@"已签到"];
                }
                
            }else{
                
                [MBProgressHUD hideHUDForView:self animated:YES];
                
                if ([_signtimes intValue] == 0) {
                    
                    [self createHaveGetGifImage:@"幸运草"];
                    
                }else if([_signtimes intValue] == 1){
                    
                    [self createHaveGetGifImage:@"糖果"];
                    
                }else if([_signtimes intValue] == 2){
                    
                    [self createHaveGetGifImage:@"玩具狗"];
                    
                }else if ([_signtimes intValue] == 4){
                    
                    [self createHaveGetGifImage:@"通用邮票"];
                    
                }else if([_signtimes intValue] == 5){
                    
                    [self createHaveGetGifImage:@"三张邮票"];
                }
                
                [self getSignDays:[NSString stringWithFormat:@"%d",[_signtimes intValue] + 1] andsignState:@"已签到"];
                
            }
        } failed:^(NSString *errorMsg) {
            [MBProgressHUD hideHUDForView:self animated:YES];
        }];
        
    }else if ([_signButton.titleLabel.text isEqualToString:@"关闭"]){
    
        [self cancleButtonClick];
    }
}

-(void)createHaveGetGifImage:(NSString *)type{

    _gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(tapClick)];
    [_gifImageView addGestureRecognizer:tap];
    
    _gifImageView.userInteractionEnabled = YES;
    
    _gifImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"签到得礼物%@",type]];
    
    [self addSubview:_gifImageView];

}

-(void)tapClick{

    [_gifImageView removeFromSuperview];
}

//获取签到天数和签到状态
-(void)getSignDays:(NSString *)signtimes andsignState:(NSString *)state{

    _signtimes = signtimes;
    
    _signDaysLabel.text = [NSString stringWithFormat:@"已签到%@天",_signtimes];
    
    if ([state isEqualToString:@"未签到"]) {
        
        [_signButton setTitle:@"签到领取" forState:UIControlStateNormal];
        
         [_signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
    
        [_signButton setTitle:@"关闭" forState:UIControlStateNormal];
        
         [_signButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    }
    
    for (int i = 0; i < 7; i++) {
        
        UIImageView *view = (UIImageView *)[_backView viewWithTag:20 + i];
        
        if ([_signtimes intValue] == 0) {
            
            view.hidden = YES;
            
        }else{
        
            if ([_signtimes intValue] >= i + 1) {
                
                view.hidden = NO;
                
            }else{
            
                view.hidden = YES;
            }
        }
    }
}

-(void)cancleButtonClick{

    [self removeFromSuperview];
}

@end
