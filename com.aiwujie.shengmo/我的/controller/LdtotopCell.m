//
//  LdtotopCell.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/11.
//  Copyright © 2019 a. All rights reserved.
//

#import "LdtotopCell.h"

@interface LdtotopCell()
@property (nonatomic,strong) UILabel *numberLab;
@property (nonatomic,strong) UILabel *priceLab;
@property (nonatomic,strong) UILabel *messageLab;
@property (nonatomic,strong) UILabel *contentLab;
@end

//屏幕宽度比
#define WIDTH_SCALE [UIScreen mainScreen].bounds.size.width / 375
//屏幕高度比
#define HEIGHT_SCALE [UIScreen mainScreen].bounds.size.height / 667

@implementation LdtotopCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.numberLab];
        [self.contentView addSubview:self.priceLab];
        [self.contentView addSubview:self.messageLab];
        [self.contentView addSubview:self.contentLab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(10*WIDTH_SCALE);
    }];
    [weakSelf.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.numberLab.mas_bottom).with.offset(8*WIDTH_SCALE);
    }];
    [weakSelf.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.priceLab.mas_bottom).with.offset(8*WIDTH_SCALE);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.messageLab.mas_bottom).with.offset(8*WIDTH_SCALE);
    }];
}

#pragma mark - getters

-(UILabel *)numberLab
{
    if(!_numberLab)
    {
        _numberLab = [[UILabel alloc] init];
        _numberLab.textAlignment = NSTextAlignmentCenter;
        _numberLab.font = [UIFont systemFontOfSize:14];
     
    }
    return _numberLab;
}

-(UILabel *)priceLab
{
    if(!_priceLab)
    {
        _priceLab = [[UILabel alloc] init];
        _priceLab.textAlignment = NSTextAlignmentCenter;
        _priceLab.font = [UIFont systemFontOfSize:14];
       
    }
    return _priceLab;
}

-(UILabel *)messageLab
{
    if(!_messageLab)
    {
        _messageLab = [[UILabel alloc] init];
        _messageLab.textAlignment = NSTextAlignmentCenter;
        _messageLab.font = [UIFont systemFontOfSize:11];
        _messageLab.textColor = TextCOLOR;
      
    }
    return _messageLab;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.font = [UIFont systemFontOfSize:11];
        _contentLab.textColor = [UIColor lightGrayColor];
    }
    return _contentLab;
}


-(void)setDatafromIndex:(NSInteger )indexrow
{
    switch (indexrow) {
        case 0:
        {
            self.numberLab.text = @"1张";
            NSMutableAttributedString *attstr1 = [[NSMutableAttributedString alloc] initWithString:@"￥40"];
            [attstr1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(1,2)];
            self.priceLab.attributedText = attstr1;
            [self.messageLab setHidden:YES];
            [self.contentLab setHidden:YES];
        }
          
            break;
        case 1:
        {
            
            NSString *str0 = @"3张(9.5折)";
            NSMutableAttributedString *attstr0 = [[NSMutableAttributedString alloc] initWithString:str0];
            [attstr0 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,3)];
            self.numberLab.attributedText = attstr0;
            
            self.priceLab.text = @"￥113";
            
            NSString *str3 = @"(仅￥37.6/张)";
            NSMutableAttributedString *attstr1 = [[NSMutableAttributedString alloc] initWithString:str3];
            [attstr1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,4)];
            self.messageLab.attributedText = attstr1;
            
            
            
            self.contentLab.text = @"原￥120";
            //中划线
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"原￥120" attributes:attribtDic];
            self.contentLab.attributedText = attribtStr;
            
            [self.messageLab setHidden:NO];
            [self.contentLab setHidden:NO];
            
        }
           
            
            break;
        case 2:
        {
            NSString *str0 = @"9张(9.1折)";
            NSMutableAttributedString *attstr0 = [[NSMutableAttributedString alloc] initWithString:str0];
            [attstr0 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,3)];
            self.numberLab.attributedText = attstr0;
            
            self.priceLab.text = @"￥328";
            
            NSString *str3 = @"(仅￥36.4/张)";
            NSMutableAttributedString *attstr1 = [[NSMutableAttributedString alloc] initWithString:str3];
            [attstr1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,4)];
            self.messageLab.attributedText = attstr1;
            
            
            
            self.contentLab.text = @"原￥360";
            //中划线
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"原￥360" attributes:attribtDic];
            self.contentLab.attributedText = attribtStr;
            
            [self.messageLab setHidden:NO];
            [self.contentLab setHidden:NO];
        }
            
            break;
        case 3:
        {
            NSString *str0 = @"29张(8.6折)";
            NSMutableAttributedString *attstr0 = [[NSMutableAttributedString alloc] initWithString:str0];
            [attstr0 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4,3)];
            self.numberLab.attributedText = attstr0;
            
            self.priceLab.text = @"￥998";
            
            NSString *str3 = @"(仅￥34.4/张)";
            NSMutableAttributedString *attstr1 = [[NSMutableAttributedString alloc] initWithString:str3];
            [attstr1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,4)];
            self.messageLab.attributedText = attstr1;
            
            
            
            self.contentLab.text = @"原￥1160";
            //中划线
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"原￥1160" attributes:attribtDic];
            self.contentLab.attributedText = attribtStr;
            
            [self.messageLab setHidden:NO];
            [self.contentLab setHidden:NO];
        }
            
            break;
        case 4:
        {
            NSString *str0 = @"81张(8折)";
            NSMutableAttributedString *attstr0 = [[NSMutableAttributedString alloc] initWithString:str0];
            [attstr0 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4,1)];
            self.numberLab.attributedText = attstr0;
            
            self.priceLab.text = @"￥2598";
            
            NSString *str3 = @"(仅￥32/张)";
            NSMutableAttributedString *attstr1 = [[NSMutableAttributedString alloc] initWithString:str3];
            [attstr1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,2)];
            self.messageLab.attributedText = attstr1;
            
            
            
            self.contentLab.text = @"原￥3240";
            //中划线
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"原￥3240" attributes:attribtDic];
            self.contentLab.attributedText = attribtStr;
            
            [self.messageLab setHidden:NO];
            [self.contentLab setHidden:NO];
        }
            
            break;
        case 5:
        {
            NSString *str0 = @"216张(7.5折)";
            NSMutableAttributedString *attstr0 = [[NSMutableAttributedString alloc] initWithString:str0];
            [attstr0 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,3)];
            self.numberLab.attributedText = attstr0;
            
            self.priceLab.text = @"￥6498";
            
            NSString *str3 = @"(仅￥30/张)";
            NSMutableAttributedString *attstr1 = [[NSMutableAttributedString alloc] initWithString:str3];
            [attstr1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,2)];
            self.messageLab.attributedText = attstr1;

            self.contentLab.text = @"原￥8640";
            //中划线
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"原￥8640" attributes:attribtDic];
            self.contentLab.attributedText = attribtStr;
            
            [self.messageLab setHidden:NO];
            [self.contentLab setHidden:NO];
            
        }
            
            break;
        default:
            break;
    }
}

@end
