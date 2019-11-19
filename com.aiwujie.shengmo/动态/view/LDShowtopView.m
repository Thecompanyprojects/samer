//
//  LDShowtopVoew.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/9.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDShowtopView.h"
#import "topimgView1.h"
#import "topimgView2.h"
#import <QuartzCore/QuartzCore.h>

@interface LDShowtopView()<UITextFieldDelegate>
@property (nonatomic,strong) UIView *alertView;
@property (nonatomic,strong) UIImageView *img0;
@property (nonatomic,strong) topimgView1 *img1;
@property (nonatomic,strong) topimgView2 *img2;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *numberLab;
@property (nonatomic,strong) UIButton *submitBtn;
@property (nonatomic,strong) UIButton *numbtn0;
@property (nonatomic,strong) UIButton *numbtn1;
@property (nonatomic,strong) UIButton *numbtn2;
@property (nonatomic,strong) UIButton *numbtn3;
@property (nonatomic,strong) UIButton *numbtn4;

@property (nonatomic,strong) UIButton *numbtn5;
@property (nonatomic,strong) UIButton *numbtn6;
@property (nonatomic,strong) UIButton *numbtn7;
@property (nonatomic,strong) UIButton *numbtn8;
@property (nonatomic,strong) UIButton *numbtn9;

@property (nonatomic,strong) UITextField *numText;
@property (nonatomic,strong) UILabel *leftLab;
@property (nonatomic,strong) UILabel *messageLab;
@property (nonatomic,strong) UILabel *messageLab2;
@property (nonatomic,copy)   NSString *numberStr;
@property (nonatomic,copy)   NSString *rocketsNum;
@property (nonatomic,copy)   NSString *buttonNum;
@property (nonatomic,copy)   NSString *interval;
@property (nonatomic,strong) UILabel *chooseLab;
@property (nonatomic,strong) UIImageView *chooseImg;
@property (nonatomic,assign) BOOL ischoose;
@end

@implementation LDShowtopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /*下面代码的作用让视图没关闭之前只创建一次*/
        BOOL isHas = NO;
        for (UIView * view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[TopcardView class]]) {
                isHas = YES;
                break;
            }
        }
        if (isHas) {
            return nil;
        }

        self.ischoose = YES;
        self.buttonNum = @"0";
        self.interval = @"0";
        self.frame = [UIScreen mainScreen].bounds;
        self.alertView = [[UIView alloc]initWithFrame:CGRectMake(30, HEIGHT/2-280, WIDTH-60, 480)];
        self.userInteractionEnabled = YES;
        self.alertView.backgroundColor = [UIColor blackColor];
        self.alertView.alpha = 0.75;
        
        self.alertView.layer.cornerRadius=8.0;
        self.alertView.layer.masksToBounds=YES;
        self.alertView.userInteractionEnabled=YES;
        [self addSubview:self.alertView];
        [self addSubview:self.titleLab];
        [self addSubview:self.img0];
        [self addSubview:self.img1];
        [self addSubview:self.img2];
        [self addSubview:self.numbtn0];
        [self addSubview:self.numbtn1];
        [self addSubview:self.numbtn2];
        [self addSubview:self.numbtn3];
        [self addSubview:self.numbtn4];
        
        [self addSubview:self.numbtn5];
        [self addSubview:self.numbtn6];
        [self addSubview:self.numbtn7];
        [self addSubview:self.numbtn8];
        [self addSubview:self.numbtn9];
        
        [self addSubview:self.numberLab];
        [self addSubview:self.leftLab];
        [self addSubview:self.numText];
        [self addSubview:self.messageLab2];
        [self addSubview:self.messageLab];
        [self addSubview:self.submitBtn];
        [self addSubview:self.chooseLab];
        [self addSubview:self.chooseImg];
        [self showAnimationwith];
        [self setuplayout];
        [self getData];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.alertView).with.offset(20);
        make.left.equalTo(weakSelf.alertView);
        make.right.equalTo(weakSelf.alertView);
    }];
    [weakSelf.img0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLab.mas_bottom).with.offset(20);
        make.width.mas_offset(113);
        make.height.mas_offset(113);
        make.centerX.equalTo(weakSelf.alertView);
    }];
    [weakSelf.img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLab.mas_bottom).with.offset(14);
        make.width.mas_offset(166);
        make.height.mas_offset(88);
        make.centerX.equalTo(weakSelf.alertView);
    }];
    [weakSelf.img2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLab.mas_bottom).with.offset(14);
        make.width.mas_offset(76);
        make.height.mas_offset(100);
        make.centerX.equalTo(weakSelf.alertView);
    }];
    
    [weakSelf.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.img1.mas_bottom).with.offset(45);
        make.left.equalTo(weakSelf.alertView);
        make.right.equalTo(weakSelf.alertView);
    }];
    
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.numberLab.mas_bottom).with.offset(20);
        make.left.equalTo(weakSelf.alertView).with.offset(100*W_SCREEN);
        make.width.mas_offset(70);
    }];
    [weakSelf.numText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftLab).with.offset(-4);
        make.left.equalTo(weakSelf.leftLab.mas_right).with.offset(3);
        make.width.mas_offset(60);
        make.height.mas_offset(24);
    }];
    
    [weakSelf.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.alertView);
        make.right.equalTo(weakSelf.alertView);
        make.top.equalTo(weakSelf.leftLab.mas_bottom).with.offset(8);
        
    }];

    [weakSelf.messageLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.alertView);
        make.right.equalTo(weakSelf.alertView);
        make.top.equalTo(weakSelf.messageLab.mas_bottom).with.offset(20);
    }];
    
    NSArray *viewArray1 = @[weakSelf.numbtn5, weakSelf.numbtn6, weakSelf.numbtn7,weakSelf.numbtn8,weakSelf.numbtn9];
    [viewArray1 mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:60 leadSpacing:45 tailSpacing:45];
    
    [viewArray1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(24);
        make.top.equalTo(weakSelf.messageLab2.mas_bottom).with.offset(8);
    }];
    
    
    NSArray *viewArray = @[weakSelf.numbtn0, weakSelf.numbtn1, weakSelf.numbtn2,weakSelf.numbtn3,weakSelf.numbtn4];
    [viewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:60 leadSpacing:45 tailSpacing:45];
    
    [viewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(24);
        make.top.equalTo(weakSelf.numbtn5.mas_bottom).with.offset(8);
    }];
    
    [weakSelf.chooseLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.alertView);
        make.top.equalTo(weakSelf.numbtn0.mas_bottom).with.offset(20);
        make.left.equalTo(weakSelf.alertView);
    }];
    if (ISIPHONEPLUS) {
        [weakSelf.chooseImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.alertView).with.offset(90);
            make.top.equalTo(weakSelf.chooseLab);
            make.width.mas_offset(15);
            make.height.mas_offset(15);
        }];
    }
    else
    {
        [weakSelf.chooseImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.alertView).with.offset(70);
            make.top.equalTo(weakSelf.chooseLab);
            make.width.mas_offset(15);
            make.height.mas_offset(15);
        }];
    }
  
    
    [weakSelf.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(80);
        make.height.mas_offset(35);
        make.top.equalTo(weakSelf.chooseLab.mas_bottom).with.offset(8);
        make.centerX.equalTo(weakSelf);
    }];
    
}

#pragma mark - getters

-(UILabel *)titleLab
{
    if(!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"推顶卡";
        _titleLab.textColor = MYORANGE;
    }
    return _titleLab;
}

-(UIImageView *)img0
{
    if(!_img0)
    {
        _img0 = [[UIImageView alloc] init];
        _img0.image = [UIImage imageNamed:@"推顶火箭"];
        
    }
    return _img0;
}

-(topimgView1 *)img1
{
    if(!_img1)
    {
        _img1 = [[topimgView1 alloc] init];
        [_img1 setHidden:YES];
    }
    return _img1;
}

-(topimgView2 *)img2
{
    if(!_img2)
    {
        _img2 = [[topimgView2 alloc] init];
        [_img2 setHidden:YES];
    }
    return _img2;
}

-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.textColor = [UIColor whiteColor];
        _leftLab.text = @"使用数量";
        _leftLab.textAlignment = NSTextAlignmentRight;
        _leftLab.font = [UIFont systemFontOfSize:16];
    }
    return _leftLab;
}

-(UITextField *)numText
{
    if(!_numText)
    {
        _numText = [[UITextField alloc] init];
        _numText.delegate = self;
        _numText.textColor = MYORANGE;
        _numText.backgroundColor = [UIColor whiteColor];
        _numText.keyboardType = UIKeyboardTypeNumberPad;
        _numText.layer.masksToBounds = YES;
        _numText.layer.borderColor = [[UIColor whiteColor] CGColor];
        [_numText addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
        _numText.layer.borderWidth=1.0f;
        _numText.layer.cornerRadius = 5;
        _numText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _numText.leftViewMode = UITextFieldViewModeAlways;
    }
    return _numText;
}

-(UIButton *)numbtn0
{
    if(!_numbtn0)
    {
        _numbtn0 = [[UIButton alloc] init];
        _numbtn0.titleLabel.font = [UIFont systemFontOfSize:13];
        [_numbtn0 setTitle:@"1小时" forState:normal];
        [_numbtn0 setTitleColor:[UIColor whiteColor] forState:normal];
        [_numbtn0 addTarget:self action:@selector(btn0click) forControlEvents:UIControlEventTouchUpInside];
        _numbtn0.layer.masksToBounds = YES;
        _numbtn0.layer.cornerRadius = 9;
    }
    return _numbtn0;
}

-(UIButton *)numbtn1
{
    if(!_numbtn1)
    {
        _numbtn1 = [[UIButton alloc] init];
        _numbtn1.titleLabel.font = [UIFont systemFontOfSize:13];
        [_numbtn1 setTitleColor:[UIColor whiteColor] forState:normal];
        [_numbtn1 setTitle:@"3小时" forState:normal];
        [_numbtn1 addTarget:self action:@selector(btn1click) forControlEvents:UIControlEventTouchUpInside];
        _numbtn1.layer.masksToBounds = YES;
        _numbtn1.layer.cornerRadius = 9;
    }
    return _numbtn1;
}

-(UIButton *)numbtn2
{
    if(!_numbtn2)
    {
        _numbtn2 = [[UIButton alloc] init];
        _numbtn2.titleLabel.font = [UIFont systemFontOfSize:13];
        [_numbtn2 setTitleColor:[UIColor whiteColor] forState:normal];
        [_numbtn2 setTitle:@"6小时" forState:normal];
        [_numbtn2 addTarget:self action:@selector(btn2click) forControlEvents:UIControlEventTouchUpInside];
        _numbtn2.layer.masksToBounds = YES;
        _numbtn2.layer.cornerRadius = 9;
    }
    return _numbtn2;
}

-(UIButton *)numbtn3
{
    if(!_numbtn3)
    {
        _numbtn3 = [[UIButton alloc] init];
        _numbtn3.titleLabel.font = [UIFont systemFontOfSize:13];
        [_numbtn3 setTitleColor:[UIColor whiteColor] forState:normal];
        [_numbtn3 setTitle:@"12小时" forState:normal];
        [_numbtn3 addTarget:self action:@selector(btn3click) forControlEvents:UIControlEventTouchUpInside];
        _numbtn3.layer.masksToBounds = YES;
        _numbtn3.layer.cornerRadius = 9;
    }
    return _numbtn3;
}


-(UIButton *)numbtn4
{
    if(!_numbtn4)
    {
        _numbtn4 = [[UIButton alloc] init];
        _numbtn4.titleLabel.font = [UIFont systemFontOfSize:13];
        [_numbtn4 setTitleColor:[UIColor whiteColor] forState:normal];
        [_numbtn4 setTitle:@"24小时" forState:normal];
        [_numbtn4 addTarget:self action:@selector(btn4click) forControlEvents:UIControlEventTouchUpInside];
        _numbtn4.layer.masksToBounds = YES;
        _numbtn4.layer.cornerRadius = 9;
    }
    return _numbtn4;
}

-(UIButton *)numbtn5
{
    if(!_numbtn5)
    {
        _numbtn5 = [[UIButton alloc] init];
        _numbtn5.titleLabel.font = [UIFont systemFontOfSize:13];
        [_numbtn5 setTitleColor:[UIColor whiteColor] forState:normal];
        [_numbtn5 setTitle:@"5分钟" forState:normal];
        [_numbtn5 addTarget:self action:@selector(btn5click) forControlEvents:UIControlEventTouchUpInside];
        _numbtn5.layer.masksToBounds = YES;
        _numbtn5.layer.cornerRadius = 9;
    }
    return _numbtn5;
}

-(UIButton *)numbtn6
{
    if(!_numbtn6)
    {
        _numbtn6 = [[UIButton alloc] init];
        _numbtn6.titleLabel.font = [UIFont systemFontOfSize:13];
        [_numbtn6 setTitleColor:[UIColor whiteColor] forState:normal];
        [_numbtn6 setTitle:@"10分钟" forState:normal];
        [_numbtn6 addTarget:self action:@selector(btn6click) forControlEvents:UIControlEventTouchUpInside];
        _numbtn6.layer.masksToBounds = YES;
        _numbtn6.layer.cornerRadius = 9;
    }
    return _numbtn6;
}

-(UIButton *)numbtn7
{
    if(!_numbtn7)
    {
        _numbtn7 = [[UIButton alloc] init];
        _numbtn7.titleLabel.font = [UIFont systemFontOfSize:13];
        [_numbtn7 setTitleColor:[UIColor whiteColor] forState:normal];
        [_numbtn7 setTitle:@"15分钟" forState:normal];
        [_numbtn7 addTarget:self action:@selector(btn7click) forControlEvents:UIControlEventTouchUpInside];
        _numbtn7.layer.masksToBounds = YES;
        _numbtn7.layer.cornerRadius = 9;
    }
    return _numbtn7;
}

-(UIButton *)numbtn8
{
    if(!_numbtn8)
    {
        _numbtn8 = [[UIButton alloc] init];
        _numbtn8.titleLabel.font = [UIFont systemFontOfSize:13];
        [_numbtn8 setTitleColor:[UIColor whiteColor] forState:normal];
        [_numbtn8 setTitle:@"20分钟" forState:normal];
        [_numbtn8 addTarget:self action:@selector(btn8click) forControlEvents:UIControlEventTouchUpInside];
        _numbtn8.layer.masksToBounds = YES;
        _numbtn8.layer.cornerRadius = 9;
    }
    return _numbtn8;
}

-(UIButton *)numbtn9
{
    if(!_numbtn9)
    {
        _numbtn9 = [[UIButton alloc] init];
        _numbtn9.titleLabel.font = [UIFont systemFontOfSize:13];
        [_numbtn9 setTitleColor:[UIColor whiteColor] forState:normal];
        [_numbtn9 setTitle:@"30分钟" forState:normal];
        [_numbtn9 addTarget:self action:@selector(btn9click) forControlEvents:UIControlEventTouchUpInside];
        _numbtn9.layer.masksToBounds = YES;
        _numbtn9.layer.cornerRadius = 9;
    }
    return _numbtn9;
}

-(UILabel *)numberLab
{
    if(!_numberLab)
    {
        _numberLab = [[UILabel alloc] init];
        _numberLab.font = [UIFont systemFontOfSize:16];
        _numberLab.textColor = [UIColor whiteColor];
        _numberLab.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLab;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.cornerRadius = 5;
        _submitBtn.backgroundColor = MainColor;
        [_submitBtn setTitle:@"确定" forState:normal];
        [_submitBtn addTarget:self action:@selector(submitbtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

-(UILabel *)messageLab
{
    if(!_messageLab)
    {
        _messageLab = [[UILabel alloc] init];
        _messageLab.textColor = [UIColor whiteColor];
        _messageLab.textAlignment = NSTextAlignmentCenter;
        _messageLab.font = [UIFont systemFontOfSize:13];
        _messageLab.text = @"被推顶者增加 0 魅力值";
        [self changeWordColorTitle:self.messageLab.text andLoc:7 andLen:1 andLabel:self.messageLab];
    }
    return _messageLab;
}

-(UILabel *)messageLab2
{
    if(!_messageLab2)
    {
        _messageLab2 = [[UILabel alloc] init];
        _messageLab2.font = [UIFont systemFontOfSize:16];
        _messageLab2.textAlignment = NSTextAlignmentCenter;
        _messageLab2.textColor = [UIColor whiteColor];
        _messageLab2.text = @"定时自动推顶间隔时长";
    }
    return _messageLab2;
}

-(UILabel *)chooseLab
{
    if(!_chooseLab)
    {
        _chooseLab = [[UILabel alloc] init];
        _chooseLab.textAlignment = NSTextAlignmentCenter;
        _chooseLab.font = [UIFont systemFontOfSize:13];
        _chooseLab.textColor = [UIColor whiteColor];
        _chooseLab.text = @"推顶可选是否上大喇叭";
        _chooseLab.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
        [_chooseLab addGestureRecognizer:singleTap];
    }
    return _chooseLab;
}

-(UIImageView *)chooseImg
{
    if(!_chooseImg)
    {
        _chooseImg = [[UIImageView alloc] init];
        _chooseImg.image = [UIImage imageNamed:@"shiguanzhu"];
        _chooseImg.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
        [_chooseImg addGestureRecognizer:singleTap];
    }
    return _chooseImg;
}


#pragma mark - buttonClick

-(void)getData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *url = [PICHEADURL stringByAppendingString:getTopcardPageInfo];
    NSDictionary *para = @{@"uid":uid?:@""};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSDictionary *data = [responseObj objectForKey:@"data"];
            self.numberStr = [data objectForKey:@"wallet_topcard"];
        }
        if (self.numberStr.length==0||[self.numberStr isEqualToString:@"0"]) {
            [self.submitBtn setTitle:@"去购买" forState:normal];
        }
        else
        {
            [self.submitBtn setTitle:@"确定" forState:normal];
        }
        [self setTextFromurl:self.numberStr];
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)setTextFromurl:(NSString *)number
{
    NSString *str0 = @"剩余 ";
    NSString *str1 = @" 张推顶卡";
    NSString *newStr = [NSString stringWithFormat:@"%@%@%@",str0,number,str1];
    self.numberLab.text = newStr;
    [self changeWordColorTitle:self.numberLab.text andLoc:3 andLen:number.length andLabel:self.numberLab];
}

/**
 更改字体颜色
 
 @param str 传入字符串
 @param loc 开始
 @param len 长度
 @param attributedLabel 显示label
 */
-(void)changeWordColorTitle:(NSString *)str andLoc:(NSUInteger)loc andLen:(NSUInteger)len andLabel:(UILabel *)attributedLabel{
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:157/255.0 blue:0/255.0 alpha:1] range:NSMakeRange(loc,len)];
    attributedLabel.attributedText = attributedStr;
}


-(void)submitbtnClick
{
    kPreventRepeatClickTime(2);
    if ([self.numberStr isEqualToString:@"0"]||self.numberStr.length==0) {
        if (self.buyclick) {
            self.buyclick(@"");
        }
    }
    else
    {
        if (self.numText.text.length==0) {
            if (self.alertshow) {
                self.alertshow();
            }
            
        }
        else
        {
            [self topcardclick];
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    }];
}

-(void)topcardclick
{
    kPreventRepeatClickTime(2);
    NSString *url = [PICHEADURL stringByAppendingString:useTopcard];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *dalaba = [NSString new];
    if (self.ischoose) {
        dalaba = @"1";
    }
    else
    {
        dalaba = @"2";
    }
    
    NSDictionary *para = @{@"did":self.did?:@"",@"uid":uid?:@"",@"num":self.numText.text?:@"",@"interval":self.interval?:@"",@"dalaba":dalaba};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            if (self.sureclick) {
                self.sureclick(self.numText.text, self.rocketsNum);
            }
        }
        else
        {
            if (self.alert) {
                self.alert(@"");
            }
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)btn0click
{
    if ([self.numText.text intValue]<2) {
        [MBProgressHUD showMessage:@"2张以上可选"];
        return;
    }
    self.numbtn0.backgroundColor = MYORANGE;
    self.numbtn1.backgroundColor = [UIColor clearColor];
    self.numbtn2.backgroundColor = [UIColor clearColor];
    self.numbtn3.backgroundColor = [UIColor clearColor];
    self.numbtn4.backgroundColor = [UIColor clearColor];
    self.numbtn5.backgroundColor = [UIColor clearColor];
    self.numbtn6.backgroundColor = [UIColor clearColor];
    self.numbtn7.backgroundColor = [UIColor clearColor];
    self.numbtn8.backgroundColor = [UIColor clearColor];
    self.numbtn9.backgroundColor = [UIColor clearColor];
    self.buttonNum = @"1";
    self.interval = @"1";
}

-(void)btn1click
{
    if ([self.numText.text intValue]<2) {
        [MBProgressHUD showMessage:@"2张以上可选"];
        return;
    }
    self.numbtn0.backgroundColor = [UIColor clearColor];
    self.numbtn1.backgroundColor = MYORANGE;
    self.numbtn2.backgroundColor = [UIColor clearColor];
    self.numbtn3.backgroundColor = [UIColor clearColor];
    self.numbtn4.backgroundColor = [UIColor clearColor];
    self.numbtn5.backgroundColor = [UIColor clearColor];
    self.numbtn6.backgroundColor = [UIColor clearColor];
    self.numbtn7.backgroundColor = [UIColor clearColor];
    self.numbtn8.backgroundColor = [UIColor clearColor];
    self.numbtn9.backgroundColor = [UIColor clearColor];
    self.buttonNum = @"2";
    self.interval = @"3";
}

-(void)btn2click
{
    if ([self.numText.text intValue]<2) {
        [MBProgressHUD showMessage:@"2张以上可选"];
        return;
    }
    self.numbtn0.backgroundColor = [UIColor clearColor];
    self.numbtn1.backgroundColor = [UIColor clearColor];
    self.numbtn2.backgroundColor = MYORANGE;
    self.numbtn3.backgroundColor = [UIColor clearColor];
    self.numbtn4.backgroundColor = [UIColor clearColor];
    self.numbtn5.backgroundColor = [UIColor clearColor];
    self.numbtn6.backgroundColor = [UIColor clearColor];
    self.numbtn7.backgroundColor = [UIColor clearColor];
    self.numbtn8.backgroundColor = [UIColor clearColor];
    self.numbtn9.backgroundColor = [UIColor clearColor];
    self.buttonNum = @"3";
    self.interval = @"6";
}

-(void)btn3click
{
    if ([self.numText.text intValue]<2) {
        [MBProgressHUD showMessage:@"2张以上可选"];
        return;
    }
    self.numbtn0.backgroundColor = [UIColor clearColor];
    self.numbtn1.backgroundColor = [UIColor clearColor];
    self.numbtn2.backgroundColor = [UIColor clearColor];
    self.numbtn3.backgroundColor = MYORANGE;
    self.numbtn4.backgroundColor = [UIColor clearColor];
    self.numbtn5.backgroundColor = [UIColor clearColor];
    self.numbtn6.backgroundColor = [UIColor clearColor];
    self.numbtn7.backgroundColor = [UIColor clearColor];
    self.numbtn8.backgroundColor = [UIColor clearColor];
    self.numbtn9.backgroundColor = [UIColor clearColor];
    self.buttonNum = @"4";
    self.interval = @"12";
}

-(void)btn4click
{
    if ([self.numText.text intValue]<2) {
        [MBProgressHUD showMessage:@"2张以上可选"];
        return;
    }
    self.numbtn0.backgroundColor = [UIColor clearColor];
    self.numbtn1.backgroundColor = [UIColor clearColor];
    self.numbtn2.backgroundColor = [UIColor clearColor];
    self.numbtn3.backgroundColor = [UIColor clearColor];
    self.numbtn4.backgroundColor = MYORANGE;
    self.numbtn5.backgroundColor = [UIColor clearColor];
    self.numbtn6.backgroundColor = [UIColor clearColor];
    self.numbtn7.backgroundColor = [UIColor clearColor];
    self.numbtn8.backgroundColor = [UIColor clearColor];
    self.numbtn9.backgroundColor = [UIColor clearColor];
    self.buttonNum = @"5";
    self.interval = @"24";
}

-(void)btn5click
{
    if ([self.numText.text intValue]<2) {
        [MBProgressHUD showMessage:@"2张以上可选"];
        return;
    }
    self.numbtn0.backgroundColor = [UIColor clearColor];
    self.numbtn1.backgroundColor = [UIColor clearColor];
    self.numbtn2.backgroundColor = [UIColor clearColor];
    self.numbtn3.backgroundColor = [UIColor clearColor];
    self.numbtn4.backgroundColor = [UIColor clearColor];
    self.numbtn5.backgroundColor = MYORANGE;
    self.numbtn6.backgroundColor = [UIColor clearColor];
    self.numbtn7.backgroundColor = [UIColor clearColor];
    self.numbtn8.backgroundColor = [UIColor clearColor];
    self.numbtn9.backgroundColor = [UIColor clearColor];
    self.interval = @"300";
}


-(void)btn6click
{
    if ([self.numText.text intValue]<2) {
        [MBProgressHUD showMessage:@"2张以上可选"];
        return;
    }
    self.numbtn0.backgroundColor = [UIColor clearColor];
    self.numbtn1.backgroundColor = [UIColor clearColor];
    self.numbtn2.backgroundColor = [UIColor clearColor];
    self.numbtn3.backgroundColor = [UIColor clearColor];
    self.numbtn4.backgroundColor = [UIColor clearColor];
    self.numbtn5.backgroundColor = [UIColor clearColor];
    self.numbtn6.backgroundColor = MYORANGE;
    self.numbtn7.backgroundColor = [UIColor clearColor];
    self.numbtn8.backgroundColor = [UIColor clearColor];
    self.numbtn9.backgroundColor = [UIColor clearColor];
    self.interval = @"600";
}


-(void)btn7click
{
    if ([self.numText.text intValue]<2) {
        [MBProgressHUD showMessage:@"2张以上可选"];
        return;
    }
    self.numbtn0.backgroundColor = [UIColor clearColor];
    self.numbtn1.backgroundColor = [UIColor clearColor];
    self.numbtn2.backgroundColor = [UIColor clearColor];
    self.numbtn3.backgroundColor = [UIColor clearColor];
    self.numbtn4.backgroundColor = [UIColor clearColor];
    self.numbtn5.backgroundColor = [UIColor clearColor];
    self.numbtn6.backgroundColor = [UIColor clearColor];
    self.numbtn7.backgroundColor = MYORANGE;
    self.numbtn8.backgroundColor = [UIColor clearColor];
    self.numbtn9.backgroundColor = [UIColor clearColor];
    self.interval = @"900";
}


-(void)btn8click
{
    if ([self.numText.text intValue]<2) {
        [MBProgressHUD showMessage:@"2张以上可选"];
        return;
    }
    self.numbtn0.backgroundColor = [UIColor clearColor];
    self.numbtn1.backgroundColor = [UIColor clearColor];
    self.numbtn2.backgroundColor = [UIColor clearColor];
    self.numbtn3.backgroundColor = [UIColor clearColor];
    self.numbtn4.backgroundColor = [UIColor clearColor];
    self.numbtn5.backgroundColor = [UIColor clearColor];
    self.numbtn6.backgroundColor = [UIColor clearColor];
    self.numbtn7.backgroundColor = [UIColor clearColor];
    self.numbtn8.backgroundColor = MYORANGE;
    self.numbtn9.backgroundColor = [UIColor clearColor];
    self.interval = @"1200";
}


-(void)btn9click
{
    if ([self.numText.text intValue]<2) {
        [MBProgressHUD showMessage:@"2张以上可选"];
        return;
    }
    self.numbtn0.backgroundColor = [UIColor clearColor];
    self.numbtn1.backgroundColor = [UIColor clearColor];
    self.numbtn2.backgroundColor = [UIColor clearColor];
    self.numbtn3.backgroundColor = [UIColor clearColor];
    self.numbtn4.backgroundColor = [UIColor clearColor];
    self.numbtn5.backgroundColor = [UIColor clearColor];
    self.numbtn6.backgroundColor = [UIColor clearColor];
    self.numbtn7.backgroundColor = [UIColor clearColor];
    self.numbtn8.backgroundColor = [UIColor clearColor];
    self.numbtn9.backgroundColor = MYORANGE;
    self.interval = @"1800";
}

#pragma mark - Animation
-(void)showAnimationwith{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch * touch = touches.anyObject;

    if ([touch.view isMemberOfClass:[self.alertView class]]||[touch.view isMemberOfClass:[self.titleLab class]]||[touch.view isMemberOfClass:[self.numbtn1 class]]||[touch.view isMemberOfClass:[self.numbtn1 class]]||[touch.view isMemberOfClass:[self.numbtn2 class]]||[touch.view isMemberOfClass:[self.numbtn3 class]]||[touch.view isMemberOfClass:[self.numbtn4 class]]||[touch.view isMemberOfClass:[self.numberLab class]]||[touch.view isMemberOfClass:[self.messageLab class]]||[touch.view isMemberOfClass:[self.numText class]]||[touch.view isMemberOfClass:[self.leftLab class]]||[touch.view isMemberOfClass:[self.chooseImg class]]||[touch.view isMemberOfClass:[self.chooseLab class]]) {
        
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self removeFromSuperview];
        }];
    }
}

#pragma mark -给每个cell中的textfield添加事件，只要值改变就调用此函数
-(void)changedTextField:(id)textField
{
    int num = [self.numText.text intValue];
    if (num<=1) {
        [self.img0 setHidden:NO];
        [self.img1 setHidden:YES];
        [self.img2 setHidden:YES];
        self.rocketsNum = @"1";
    }
    if (num==2) {
        [self.img0 setHidden:YES];
        [self.img1 setHidden:NO];
        [self.img2 setHidden:YES];
        self.rocketsNum = @"2";
    }
    if (num>2) {
        [self.img0 setHidden:YES];
        [self.img1 setHidden:YES];
        [self.img2 setHidden:NO];
        self.rocketsNum = @"3";
    }
    
    if (num>1) {
        self.numbtn0.backgroundColor = MYORANGE;
        self.interval = @"1";
    }
    else
    {
        self.interval = @"";
        self.numbtn0.backgroundColor = [UIColor clearColor];
    }
    
    NSString *messagenum = [NSString stringWithFormat:@"%d",num*100];
    self.messageLab.text = [NSString stringWithFormat:@"%@%@%@",@"被推顶者增加 ",messagenum,@" 魅力值"];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.messageLab.text];
    [str addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(7,messagenum.length)];
    self.messageLab.attributedText = str;
}

-(void)onClickImage
{
    self.ischoose = !self.ischoose;
    if (self.ischoose) {
        self.chooseImg.image = [UIImage imageNamed:@"shiguanzhu"];
    }
    else
    {
        self.chooseImg.image = [UIImage imageNamed:@"kongguanzhu"];
    }
}

@end
