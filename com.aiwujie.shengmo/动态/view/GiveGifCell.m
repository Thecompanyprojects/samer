//
//  GiveGifCell.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import "GiveGifCell.h"

@implementation GiveGifCell

-(void)setModel:(GiveGifModel *)model{

    _model = model;
    
    if (self.isTopcard) {

        // XXX 推顶了 xxx 的动态
        NSString *str0 = model.nickname;
        NSString *str1 = @"推顶了";
        NSString *str2 = model.fnickname;
        NSString *str3 = @"的动态";
        NSString *newStr = [NSString stringWithFormat:@"%@%@%@%@",str0,str1,str2,str3];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:newStr];
        [str addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0,str0.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:157/255.0 blue:0/255.0 alpha:1] range:NSMakeRange(str0.length,str1.length)];
        [str addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(str0.length+str1.length,str2.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(str0.length+str1.length+str2.length,1)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(str0.length+str1.length+str2.length+1,2)];
        self.showLabel.attributedText = str;
        
        self.connectImageView.image = [UIImage imageNamed:@"连接图"];
        self.showImageView.image = [UIImage imageNamed:@"推顶火箭"];
        [self.giveImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.head_pic]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        [self.givenImageView  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.fhead_pic]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        self.giveImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.givenImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.timeLabel.text = _model.addtime;
        
    }
    else
    {
        NSArray *colorArray = @[@"握手紫",@"黄瓜紫",@"玫瑰紫",@"送吻紫",@"红酒紫",@"对戒紫",@"蛋糕紫",@"跑车紫",@"游轮紫" ,@"棒棒糖",@"狗粮",@"雪糕",@"黄瓜",@"心心相印",@"香蕉",@"口红",@"亲一个",@"玫瑰花",@"眼罩",@"心灵束缚",@"黄金",@"拍之印",@"鞭之痕",@"老司机",@"一生一世",@"水晶高跟",@"恒之光",@"666",@"红酒",@"蛋糕",@"钻戒",@"皇冠",@"跑车",@"直升机",@"游轮",@"城堡",@"幸运草",@"糖果",@"玩具狗",@"内内",@"TT"];
        
        NSArray *giftArray = @[@"握手",@"黄瓜",@"玫瑰",@"送吻",@"红酒",@"对戒",@"蛋糕",@"跑车",@"游轮",@"棒棒糖",@"狗粮",@"雪糕",@"黄瓜",@"心心相印",@"香蕉",@"口红",@"亲一个",@"玫瑰花",@"眼罩",@"心灵束缚",@"黄金",@"拍之印",@"鞭之痕",@"老司机",@"一生一世",@"水晶高跟",@"恒之光",@"666",@"红酒",@"蛋糕",@"钻戒",@"皇冠",@"跑车",@"直升机",@"游轮",@"城堡",@"幸运草",@"糖果",@"玩具狗",@"内内",@"TT"];
        
        self.showLabel.textColor = MainColor;
        
        if ([_model.state intValue] == 1) {
            
            if (giftArray.count >= [_model.type intValue]) {
                
                self.showLabel.text = [NSString stringWithFormat:@"%@给%@赠送了%@×%@",_model.nickname,_model.fnickname,giftArray[[_model.type intValue] - 1],_model.num];
                
                self.showImageView.image = [UIImage imageNamed:colorArray[[_model.type intValue] - 1]];
                
            }else{
                
                self.showLabel.text = [NSString stringWithFormat:@"%@给%@赠送了%@×%@",_model.nickname,_model.fnickname,@"新版礼物",_model.num];
                
                self.showImageView.image = [UIImage imageNamed:@"未知礼物"];
            }
            
            self.connectImageView.image = [UIImage imageNamed:@"连接图"];
            
        }else if ([_model.state intValue] == 2){
            
            NSString *vip;
            
            if ([_model.type intValue] == 1) {
                
                vip = @"1个月VIP";
                
                self.showImageView.image = [UIImage imageNamed:@"高级紫"];
                
            }else if ([_model.type intValue] == 2){
                
                vip = @"3个月VIP";
                
                self.showImageView.image = [UIImage imageNamed:@"高级紫"];
                
            }else if ([_model.type intValue] == 3){
                
                vip = @"6个月VIP";
                
                self.showImageView.image = [UIImage imageNamed:@"高级紫"];
                
            }else if ([_model.type intValue] == 4){
                
                vip = @"12个月VIP";
                
                self.showImageView.image = [UIImage imageNamed:@"年费会员"];
                
            }else{
                
                vip = @"VIP";
                
                self.showImageView.image = [UIImage imageNamed:@"高级紫"];
            }
            
            self.showLabel.text = [NSString stringWithFormat:@"%@给%@赠送了%@",_model.nickname,_model.fnickname,vip];
            
            self.connectImageView.image = [UIImage imageNamed:@"连接图"];
            
        }else if ([_model.state intValue] == 3){
            
            NSString *vip;
            
            if ([_model.type intValue] == 1) {
                
                vip = @"1个月SVIP";
                
                self.showImageView.image = [UIImage imageNamed:@"svip标识"];
                
            }else if ([_model.type intValue] == 2){
                
                vip = @"3个月SVIP";
                
                self.showImageView.image = [UIImage imageNamed:@"svip标识"];
                
            }else if ([_model.type intValue] == 3){
                
                vip = @"8个月SVIP";
                
                self.showImageView.image = [UIImage imageNamed:@"svip标识"];
                
            }else if ([_model.type intValue] == 4){
                
                vip = @"12个月SVIP";
                
                self.showImageView.image = [UIImage imageNamed:@"年svip标识"];
                
            }else{
                
                vip = @"SVIP";
                
                self.showImageView.image = [UIImage imageNamed:@"svip标识"];
            }
            
            self.showLabel.text = [NSString stringWithFormat:@"%@给%@赠送了%@",_model.nickname,_model.fnickname,vip];
            
            self.connectImageView.image = [UIImage imageNamed:@"svip连接图"];
        }
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.showLabel.text];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange([_model.nickname length],1)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange([_model.nickname length] + 1 + [_model.fnickname length],3)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:157/255.0 blue:0/255.0 alpha:1] range:NSMakeRange([_model.nickname length] + 4 + [_model.fnickname length],[str length] - ([_model.nickname length] + 4 + [_model.fnickname length]))];
        
        self.showLabel.attributedText = str;
        
        [self.giveImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.head_pic]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
        [self.givenImageView  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.fhead_pic]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
        self.giveImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.givenImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.timeLabel.text = _model.addtime;
        
        if ([_model.state intValue] == 1) {
            
        }else if ([_model.state intValue] == 2){
            
            
            
        }
    }
    
   
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.giveImageView.layer.cornerRadius = 23;
    self.giveImageView.clipsToBounds = YES;
    
    self.givenImageView.layer.cornerRadius = 23;
    self.givenImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
