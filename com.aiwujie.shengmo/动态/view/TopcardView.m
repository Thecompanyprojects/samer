//
//  TopcardView.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/19.
//  Copyright © 2019 a. All rights reserved.
//

#import "TopcardView.h"

@interface TopcardView()
@property (nonatomic,strong) UIView *alertView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIImageView *topBtn;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UIButton *buyBtn;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,copy) NSString *numberStr;
@end

@implementation TopcardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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

        self.frame = [UIScreen mainScreen].bounds;
        self.alertView = [[UIView alloc]initWithFrame:CGRectMake(80, HEIGHT/2-140, WIDTH-160, 280)];
        self.userInteractionEnabled = YES;
        self.alertView.backgroundColor = [UIColor blackColor];
        self.alertView.alpha = 0.75;

        self.alertView.layer.cornerRadius=8.0;
        self.alertView.layer.masksToBounds=YES;
        self.alertView.userInteractionEnabled=YES;
        [self addSubview:self.alertView];
        [self showAnimationwith];

        [self  addSubview:self.topBtn];
        [self  addSubview:self.bgView];
        [self  addSubview:self.contentLab];
        [self  addSubview:self.titleLab];
        [self  addSubview:self.buyBtn];
        [self setuplayout];
        [self getData];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.alertView);
        make.right.equalTo(weakSelf.alertView);
        make.top.equalTo(weakSelf.alertView).with.offset(20);
    }];
    
    [weakSelf.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.alertView);
        make.top.equalTo(weakSelf.titleLab.mas_bottom).with.offset(25);
        make.width.mas_offset(100);
        make.height.mas_offset(100);
    }];
    
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.alertView);
        make.top.equalTo(weakSelf.topBtn.mas_bottom).with.offset(25);
        
    }];
    
    [weakSelf.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(95);
        make.centerX.equalTo(weakSelf.alertView);
        make.top.equalTo(weakSelf.contentLab.mas_bottom).with.offset(23);
        make.height.mas_offset(26);
        
    }];
    [weakSelf.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(95);
        make.centerX.equalTo(weakSelf.alertView);
        make.top.equalTo(weakSelf.contentLab.mas_bottom).with.offset(23);
        make.height.mas_offset(26);
    }];
}


-(UILabel *)titleLab
{
    if(!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"推顶卡";
        _titleLab.textColor = [UIColor colorWithHexString:@"FF9D00" alpha:1];
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:18];
        _contentLab.textColor = [UIColor whiteColor];
        _contentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLab;
}

-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1];
        _bgView.layer.cornerRadius = 2;
    }
    return _bgView;
}


-(UIImageView *)topBtn
{
    if(!_topBtn)
    {
        _topBtn = [UIImageView new];
        _topBtn.image = [UIImage imageNamed:@"推顶火箭"];
        _topBtn.userInteractionEnabled = YES;
    }
    return _topBtn;
}


-(UIButton *)buyBtn
{
    if(!_buyBtn)
    {
        _buyBtn = [[UIButton alloc] init];
        [_buyBtn setTitle:@"去购买" forState:normal];
        _buyBtn.layer.cornerRadius = 2;
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:normal];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:normal];
        [_buyBtn addTarget:self action:@selector(buybtnClick) forControlEvents:UIControlEventTouchUpInside];
        _buyBtn.alpha = 1;
    }
    return _buyBtn;
}


-(void)buybtnClick
{
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    }];
    if (self.numberStr.length==0||[self.numberStr isEqualToString:@"0"]) {
        if (self.buyClick) {
            self.buyClick([NSString new]);
        }
    }
    else
    {
        [self topcardclick];
    }
}

-(void)singleTapAction
{
    if ([self.numberStr isEqualToString:@"0"]||self.numberStr.length==0) {
        if (self.alertClick) {
            self.alertClick([NSString new]);
        }
    }
    else
    {
        [self topcardclick];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    }];
}


-(void)topcardclick
{
    NSString *url = [PICHEADURL stringByAppendingString:useTopcard];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    
    NSDictionary *para = @{@"did":self.did?:@"",@"uid":uid?:@""};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            if (self.sureClick) {
                self.sureClick(self.numberStr);
            }
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

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
            [self.buyBtn setTitle:@"去购买" forState:normal];
        }
        else
        {
            [self.buyBtn setTitle:@"确定" forState:normal];
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
    self.contentLab.text = newStr;
    [self changeWordColorTitle:self.contentLab.text andLoc:3 andLen:number.length andLabel:self.contentLab];
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


-(void)withSureClick:(sureBlock)block{
    _sureClick = block;
}

-(void)withBuyClick:(buyBlock)block
{
    _buyClick = block;
}

-(void)withAlertClick:(alertBlock)block
{
    _alertClick = block;
}

#pragma mark - getteres

-(void)showAnimationwith{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch * touch = touches.anyObject;
    
    if ([touch.view isMemberOfClass:[self.alertView class]]||[touch.view isMemberOfClass:[self.titleLab class]]) {
       
        
    }
    else if ([touch.view isMemberOfClass:[self.topBtn class]]) {

        [self singleTapAction];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self removeFromSuperview];
        }];
    }
}



@end
