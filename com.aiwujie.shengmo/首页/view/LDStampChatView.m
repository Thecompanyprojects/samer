//
//  stampChatView.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/30.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDStampChatView.h"

@interface LDStampChatView ()

@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) UILabel *currencyNumLabel;

@end

@implementation LDStampChatView

-(void)setData:(NSDictionary *)data{

    _data = data;
    
    _currencyNumLabel.text = [NSString stringWithFormat:@"拥有 %@ 张通用邮票",data[@"wallet_stamp"]?:@"0"];
    [self changeWordColorTitle:_currencyNumLabel.text andLoc:3 andLen:[[NSString stringWithFormat:@"%@",data[@"wallet_stamp"]?:@"0"] length] andLabel:_currencyNumLabel];
    
    UILabel *boyLabel = (UILabel *)[_backView viewWithTag:20];
    boyLabel.text = [NSString stringWithFormat:@"男票 %@ 张",data[@"basicstampX"]?:@"0"];
    [self changeWordColorTitle:boyLabel.text andLoc:3 andLen:[[NSString stringWithFormat:@"%@",data[@"basicstampX"]?:@"0"] length] andLabel:boyLabel];
    
    UILabel *girlLabel = (UILabel *)[_backView viewWithTag:21];
    girlLabel.text = [NSString stringWithFormat:@"女票 %@ 张",data[@"basicstampY"]?:@"0"];
    [self changeWordColorTitle:girlLabel.text andLoc:3 andLen:[[NSString stringWithFormat:@"%@",data[@"basicstampY"]?:@"0"] length] andLabel:girlLabel];
    
    UILabel *cdtsLabel = (UILabel *)[_backView viewWithTag:22];
    cdtsLabel.text = [NSString stringWithFormat:@"CDTS票 %@ 张",data[@"basicstampZ"]?:@"0"];
    [self changeWordColorTitle:cdtsLabel.text andLoc:6 andLen:[[NSString stringWithFormat:@"%@",data[@"basicstampZ"]?:@"0"] length] andLabel:cdtsLabel];
}

//更改某个字体的颜色和字号
-(void)changeWordColorTitle:(NSString *)str andLoc:(NSUInteger)loc andLen:(NSUInteger)len andLabel:(UILabel *)attributedLabel{
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:157/255.0 blue:0/255.0 alpha:1] range:NSMakeRange(loc,len)];
    if ([_currencyNumLabel isEqual:attributedLabel]) {
        
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(loc,len)];
    }
    attributedLabel.attributedText = attributedStr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self createUI:frame];
    }
    
    return self;
}

-(void)createUI:(CGRect)frame{
    
    self.backgroundColor = [UIColor clearColor];
    
    UIButton *singleButton = [[UIButton alloc] initWithFrame:frame];
    [singleButton addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:singleButton];
    
    UIView *back = [[UIView alloc] init];
    back.backgroundColor = [UIColor blackColor];
    back.alpha = 0.75;
    back.layer.cornerRadius = 4;
    back.clipsToBounds = YES;
    [self addSubview:back];
    
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor clearColor];
    _backView.layer.cornerRadius = 4;
    _backView.clipsToBounds = YES;
    [self addSubview:_backView];
    
    CGFloat space = 15;
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, WIDTH - 20, 15)];
    priceLabel.text = @"与Ta畅聊的4种方式";
    priceLabel.textColor = [UIColor colorWithHexString:@"#e29e4d" alpha:1];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.font = [UIFont systemFontOfSize:17];
    [_backView addSubview:priceLabel];
    
    //第一条数据显示
    UILabel *num1 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(priceLabel.frame) + space, 20, 20)];
    num1.text = @"1";
    num1.backgroundColor = [UIColor whiteColor];
    num1.textAlignment = NSTextAlignmentCenter;
    num1.layer.cornerRadius = 10;
    num1.layer.masksToBounds = YES;
    num1.font = [UIFont systemFontOfSize:14];
    num1.textColor = [UIColor blackColor];
    [_backView addSubview:num1];
    
    UILabel *warnLabel = [[UILabel alloc] init];
    warnLabel.text = @"互为好友即可免费发信息";
    warnLabel.textAlignment = NSTextAlignmentRight;
    warnLabel.textColor = [UIColor whiteColor];
    warnLabel.font = [UIFont systemFontOfSize:14];
    [warnLabel sizeToFit];
    warnLabel.frame = CGRectMake(CGRectGetMaxX(num1.frame) + 15,  CGRectGetMaxY(priceLabel.frame) + space, warnLabel.frame.size.width, 20);
    [_backView addSubview:warnLabel];
    
    UIButton *attentButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 100 ,CGRectGetMaxY(priceLabel.frame) + space - 3, 70, 25)];
    attentButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [attentButton setTitle:@"加好友" forState:UIControlStateNormal];
    [attentButton addTarget:self action:@selector(attentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    attentButton.layer.cornerRadius = 2;
    attentButton.clipsToBounds = YES;
    [attentButton setBackgroundColor:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1]];
    [_backView addSubview:attentButton];

    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , CGRectGetMaxY(warnLabel.frame) + space, WIDTH - 20, 10)];
    lineView.image = [UIImage imageNamed:@"分割图片"];
    [_backView addSubview:lineView];
    
    //第二条数据显示
    UILabel *num2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame) + space, 20, 20)];
    num2.text = @"2";
    num2.backgroundColor = [UIColor whiteColor];
    num2.textAlignment = NSTextAlignmentCenter;
    num2.layer.cornerRadius = 10;
    num2.layer.masksToBounds = YES;
    num2.font = [UIFont systemFontOfSize:14];
    num2.textColor = [UIColor blackColor];
    [_backView addSubview:num2];
    
    UILabel *warnLabel1 = [[UILabel alloc] init];
    warnLabel1.text = @"开通SVIP即可无限畅聊";
    warnLabel1.textAlignment = NSTextAlignmentRight;
    warnLabel1.textColor = [UIColor whiteColor];
    warnLabel1.font = [UIFont systemFontOfSize:14];
    [warnLabel1 sizeToFit];
    warnLabel1.frame = CGRectMake(CGRectGetMaxX(num2.frame) + 15,  CGRectGetMaxY(lineView.frame) + space, warnLabel1.frame.size.width, 20);
    [_backView addSubview:warnLabel1];
    
    UIButton *openSvipButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 100 ,CGRectGetMaxY(lineView.frame) + space - 3, 70, 25)];
    openSvipButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [openSvipButton setTitle:@"去开通" forState:UIControlStateNormal];
    [openSvipButton addTarget:self action:@selector(openSvipButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    openSvipButton.layer.cornerRadius = 2;
    openSvipButton.clipsToBounds = YES;
    [openSvipButton setBackgroundColor:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1]];
    [_backView addSubview:openSvipButton];
    
    UIImageView *lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0 , CGRectGetMaxY(warnLabel1.frame) + space, WIDTH - 20, 10)];
    lineView1.image = [UIImage imageNamed:@"分割图片"];
    [_backView addSubview:lineView1];
    
    //第三条数据内容
    
    UILabel *num3 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView1.frame) + space, 20, 20)];
    num3.text = @"3";
    num3.backgroundColor = [UIColor whiteColor];
    num3.textAlignment = NSTextAlignmentCenter;
    num3.layer.cornerRadius = 10;
    num3.layer.masksToBounds = YES;
    num3.font = [UIFont systemFontOfSize:14];
    num3.textColor = [UIColor blackColor];
    [_backView addSubview:num3];
    
    UILabel *warnLabel2 = [[UILabel alloc] init];
    warnLabel2.text = @"点击邮票 发送消息";
    warnLabel2.textAlignment = NSTextAlignmentRight;
    warnLabel2.textColor = [UIColor whiteColor];
    warnLabel2.font = [UIFont systemFontOfSize:14];
    [warnLabel2 sizeToFit];
    warnLabel2.frame = CGRectMake(CGRectGetMaxX(num3.frame) + 15,  CGRectGetMaxY(lineView1.frame) + space, warnLabel2.frame.size.width, 20);
    [_backView addSubview:warnLabel2];
    
    CGFloat currencyFloat = (WIDTH - 20)/2 - 75;
    
    UIButton *currencyButton = [[UIButton alloc] initWithFrame:CGRectMake(20 , CGRectGetMaxY(warnLabel2.frame) + space, 1.27 * currencyFloat, currencyFloat)];
    [currencyButton setBackgroundImage:[UIImage imageNamed:@"通用邮票"] forState:UIControlStateNormal];
    [currencyButton addTarget:self action:@selector(currencyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:currencyButton];
    
    _currencyNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 + 1.27 * currencyFloat , CGRectGetMaxY(warnLabel2.frame) + space + currencyFloat/6, WIDTH - 50 - 1.27 * currencyFloat, 15)];
    _currencyNumLabel.textColor = [UIColor whiteColor];
    [_backView addSubview:_currencyNumLabel];
    
    UIButton *goBuyButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 100, CGRectGetMaxY(warnLabel2.frame) + space + currencyFloat/6 * 4 - 3, 70, 25)];
    goBuyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [goBuyButton setTitle:@"去购票" forState:UIControlStateNormal];
    [goBuyButton addTarget:self action:@selector(goButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    goBuyButton.layer.cornerRadius = 2;
    goBuyButton.clipsToBounds = YES;
    [goBuyButton setBackgroundColor:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1]];
    [_backView addSubview:goBuyButton];
    
    UIImageView *lineView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0 , CGRectGetMaxY(currencyButton.frame) + space, WIDTH - 20, 10)];
    lineView3.image = [UIImage imageNamed:@"分割图片"];
    [_backView addSubview:lineView3];
    
    //第四条数据显示的内容
    UILabel *num4 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView3.frame) + space, 20, 20)];
    num4.text = @"4";
    num4.backgroundColor = [UIColor whiteColor];
    num4.textAlignment = NSTextAlignmentCenter;
    num4.layer.cornerRadius = 10;
    num4.layer.masksToBounds = YES;
    num4.font = [UIFont systemFontOfSize:14];
    num4.textColor = [UIColor blackColor];
    [_backView addSubview:num4];
    
    UILabel *warnLabel3 = [[UILabel alloc] init];
    warnLabel3.text = @"做任务免费领邮票";
    warnLabel3.textAlignment = NSTextAlignmentRight;
    warnLabel3.textColor = [UIColor whiteColor];
    warnLabel3.font = [UIFont systemFontOfSize:14];
    [warnLabel3 sizeToFit];
    warnLabel3.frame = CGRectMake(CGRectGetMaxX(num4.frame) + 15,  CGRectGetMaxY(lineView3.frame) + space, warnLabel3.frame.size.width, 20);
    [_backView addSubview:warnLabel3];
    
    UIButton *goButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 100, CGRectGetMaxY(lineView3.frame) + space - 3, 70, 25)];
    goButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [goButton setTitle:@"做任务" forState:UIControlStateNormal];
    [goButton addTarget:self action:@selector(goButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    goButton.layer.cornerRadius = 2;
    goButton.clipsToBounds = YES;
    [goButton setBackgroundColor:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1]];
    [_backView addSubview:goButton];
    
    NSArray *array = @[@"斯慕男票",@"斯慕女票",@"斯慕CDTS票"];
    NSArray *titleArray = @[@"男票3张",@"女票3张",@"CDTS票3张"];
    CGFloat systemFloat = (WIDTH - 90)/3;
    
    for (int i = 0; i < 3; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20 + i * systemFloat + i * 15, CGRectGetMaxY(warnLabel3.frame) + space, systemFloat, systemFloat/1.27)];
        button.tag = 10 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        [_backView addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20 + i * systemFloat + i * 15, CGRectGetMaxY(button.frame) + 5, systemFloat, 15)];
        label.text = titleArray[i];
        label.tag = 20 + i;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        [_backView addSubview:label];
        
        if (i == 2) {
            
            back.frame = CGRectMake(10 ,(HEIGHT - CGRectGetMaxY(label.frame) + 20 - 64)/2 + 32, WIDTH - 20, CGRectGetMaxY(label.frame) + 20);
            
            _backView.frame = CGRectMake(10 ,(HEIGHT - CGRectGetMaxY(label.frame) + 20 - 64)/2 + 32, WIDTH - 20, CGRectGetMaxY(label.frame) + 20);
        }
    }

}

/**
 * 点击去开通Svip按钮
 */
-(void)openSvipButtonClick:(UIButton *)button{
    
    if (_delegate && [_delegate respondsToSelector:@selector(stampOpenSvipButtonClick)]) {
        
        [_delegate stampOpenSvipButtonClick];
        
    }
}

//点击关注聊天对象
-(void)attentButtonClick:(UIButton *)button{

    if (_delegate && [_delegate respondsToSelector:@selector(didSelectAttentButton:andButton:)]) {
        
        [_delegate didSelectAttentButton:self andButton:button];
    }
    
}

//点击其他按钮跳转到其他的界面
-(void)goButtonClick:(UIButton *)button{

    if (_delegate && [_delegate respondsToSelector:@selector(didSelectOtherButton)]) {
        
        [_delegate didSelectOtherButton];
        
    }

}

/**
 * 点击任务邮票按钮
 */
-(void)buttonClick:(UIButton *)button{
    
    if (button.tag == 10) {
        
        if ([_data[@"sex"] intValue] == 1) {
            
            if ([_data[@"basicstampX"] intValue] != 0) {
                
                if (_delegate && [_delegate respondsToSelector:@selector(didSelectStamp:)]) {
                    
                    [_delegate didSelectStamp:@"1"];
                }
                
            }else{
                
                [AlertTool alertWithViewController:_viewController andTitle:nil andMessage:@"您的邮票不足,请使用通用邮票或做任务领取!"];
            }
  
        }else{
            
            if ([_data[@"sex"] intValue] == 2) {
                
                [self alertcontroller:@"女"];
       
            }else if ([_data[@"sex"] intValue] == 3){
                
                [self alertcontroller:@"CDTS"];

            }
        }
 
    }else if (button.tag == 11){
    
        if ([_data[@"sex"] intValue] == 2) {
            
            if ([_data[@"basicstampY"] intValue] != 0){
                
                if (_delegate && [_delegate respondsToSelector:@selector(didSelectStamp:)]) {
                    
                    [_delegate didSelectStamp:@"2"];
                }
                
            }else{
                
                [AlertTool alertWithViewController:_viewController andTitle:nil andMessage:@"您的邮票不足,请使用通用邮票或做任务领取!"];
            }

        }else{
            
            if ([_data[@"sex"] intValue] == 1) {
                
                [self alertcontroller:@"男"];
                
            }else if ([_data[@"sex"] intValue] == 3){
                
                [self alertcontroller:@"CDTS"];
               
            }
        }

    }else if (button.tag == 12){
    
        if ([_data[@"sex"] intValue] == 3) {
            
            if ([_data[@"basicstampZ"] intValue] != 0){
            
                if (_delegate && [_delegate respondsToSelector:@selector(didSelectStamp:)]) {
                    
                    [_delegate didSelectStamp:@"3"];
                };
                
            }else{
                
                [AlertTool alertWithViewController:_viewController andTitle:nil andMessage:@"您的邮票不足,请使用通用邮票或做任务领取!"];
            }
            
        }else{
            
            if ([_data[@"sex"] intValue] == 2) {
                
                [self alertcontroller:@"女"];
    
            }else if ([_data[@"sex"] intValue] == 1){
            
                [self alertcontroller:@"男"];
            }
        }
    }
}

/**
 * 选择邮票错误的提示
 */
-(void)alertcontroller:(NSString *)str{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"请使用通用邮票/任务%@票发送消息",str]    preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"请使用通用邮票/任务%@票发送消息",str]];
    [messageAtt addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:157/255.0 blue:0/255.0 alpha:1] range:NSMakeRange(3, str.length + 7)];
    [alert setValue:messageAtt forKey:@"attributedMessage"];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:nil];
    
    [alert addAction:action];
    
    [_viewController presentViewController:alert animated:YES completion:nil];
}

/**
 * 点击通用邮票聊天
 */
-(void)currencyButtonClick{
    
    if ([_data[@"wallet_stamp"] intValue] != 0){
        
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectStamp:)]) {
            
            [_delegate didSelectStamp:@"4"];
        }
        
    }else{
        
        [AlertTool alertWithViewController:_viewController andTitle:nil andMessage:@"您的邮票不足,请使用通用邮票或做任务领取!"];
    }

}

//点击礼物外移除打赏礼物的view
-(void)cancleButtonClick{
    
    [self removeView];
}

//移除邮票礼物view
-(void)removeView{
    
    [self removeFromSuperview];
}

@end
