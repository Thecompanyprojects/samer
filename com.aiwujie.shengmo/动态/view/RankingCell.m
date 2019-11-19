//
//  RankingCell.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/12.
//  Copyright © 2017年 a. All rights reserved.
//

#import "RankingCell.h"

@implementation RankingCell

-(void)setModel:(RankingModel *)model{
    
    _model = model;
    
    [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.head_pic]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.headView.contentMode = UIViewContentModeScaleAspectFill;
    self.nickname.text = model.nickname;
        
    self.amount.text = [NSString stringWithFormat:@"%@次",model.allnum];
    if ([_model.is_admin intValue]==1) {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageNamed:@"官方认证"];
    }
    else if ([_model.bkvip intValue]==1)
    {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageNamed:@"贵宾黑V"];
        
    }
    else if ([_model.blvip intValue]==1)
    {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageNamed:@"蓝V"];
        
    }
    else if ([_model.is_volunteer intValue]==1)
    {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageNamed:@"志愿者标识"];
    }
    else
    {
        if ([_model.svipannual intValue] == 1) {
            self.vipView.hidden = NO;
            self.vipView.image = [UIImage imageNamed:@"年svip标识"];
        }else if ([_model.svip intValue] == 1){
            self.vipView.hidden = NO;
            self.vipView.image = [UIImage imageNamed:@"svip标识"];
        }else if ([_model.vipannual intValue] == 1) {
            self.vipView.hidden = NO;
            self.vipView.image = [UIImage imageNamed:@"年费会员"];
        }else{
            if ([_model.vip intValue] == 1) {
                self.vipView.hidden = NO;
                self.vipView.image = [UIImage imageNamed:@"高级紫"];
            }else{
                self.vipView.hidden = YES;
            }
        }
    }
    /*if ([_model.is_volunteer intValue] == 1) {
        
        self.vipView.hidden = NO;
        
        self.vipView.image = [UIImage imageNamed:@"志愿者标识"];
        
    }else if ([_model.is_admin intValue] == 1) {
        
        self.vipView.hidden = NO;
        
        self.vipView.image = [UIImage imageNamed:@"官方认证"];
        
    }else{
        
        if ([_model.svipannual intValue] == 1) {
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"年svip标识"];
            
        }else if ([_model.svip intValue] == 1){
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"svip标识"];
            
        }else if ([_model.vipannual intValue] == 1) {
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"年费会员"];
            
        }else{
            
            if ([_model.vip intValue] == 1) {
                
                self.vipView.hidden = NO;
                
                self.vipView.image = [UIImage imageNamed:@"高级紫"];
                
            }else{
                
                self.vipView.hidden = YES;
            }
            
        }
        
    }*/
    
    if ([_model.realname intValue] == 0) {
        
        self.idImageView.hidden = YES;
        
    }else{
        
        self.idImageView.hidden = NO;

    }

    if ([_model.role isEqualToString:@"S"]) {
        
        self.sexualLabel.text = @"斯";
        
        self.sexualLabel.backgroundColor = BOYCOLOR;
        
    }else if ([_model.role isEqualToString:@"M"]){
        
        self.sexualLabel.text = @"慕";
        
        self.sexualLabel.backgroundColor = GIRLECOLOR;
        
    }else if ([_model.role isEqualToString:@"SM"]){
        self.sexualLabel.text = @"双";
        self.sexualLabel.backgroundColor = DOUBLECOLOR;
    }else{
        self.sexualLabel.text = @"~";
        self.sexualLabel.backgroundColor = GREENCOLORS;
    }
    if ([_model.sex intValue] == 1) {
        self.sexView.image = [UIImage imageNamed:@"男"];
        self.aSexView.backgroundColor = BOYCOLOR;
    }else if ([_model.sex intValue] == 2){
        self.sexView.image = [UIImage imageNamed:@"女"];
        self.aSexView.backgroundColor = GIRLECOLOR;
    }else{
        self.sexView.image = [UIImage imageNamed:@"双性"];
        self.aSexView.backgroundColor = DOUBLECOLOR;
    }
    self.ageLabel.text = [NSString stringWithFormat:@"%@",_model.age];
    [self getWealthAndCharmState:_wealthLabel andView:_wealthView andNSLayoutConstraint:_wealthW andType:@"财富"];
    [self getWealthAndCharmState:_charmLabel andView:_charmView andNSLayoutConstraint:_charmW andType:@"魅力"];
}

-(void)getWealthAndCharmState:(UILabel *)label andView:(UIView *)backView andNSLayoutConstraint:(NSLayoutConstraint *)constraint andType:(NSString *)type{
    
    if ([type isEqualToString:@"财富"]) {
        
        if ([_model.wealth_val intValue] == 0) {
            
            self.wealthSpace.constant = 0;
            
            backView.hidden = YES;
            
            constraint.constant = 0;
            
        }else{
            
            self.wealthSpace.constant = 5;
            
            backView.hidden = NO;
            
            label.text = [NSString stringWithFormat:@"%@",_model.wealth_val];
            label.textColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1];
            backView.layer.borderColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1].CGColor;
            
            constraint.constant = 27 + [self fitLabelWidth:label.text].width;
        }
        
    }else{
        
        if ([_model.charm_val intValue] == 0) {
            
            backView.hidden = YES;
            
        }else{
            
            backView.hidden = NO;
            
            label.text = [NSString stringWithFormat:@"%@",_model.charm_val];
            label.textColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1];
            backView.layer.borderColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1].CGColor;
            
            constraint.constant = 27 + [self fitLabelWidth:label.text].width;
        }
    }
    
    backView.layer.borderWidth = 1;
    backView.layer.cornerRadius = 2;
    backView.clipsToBounds = YES;
}

-(CGSize)fitLabelWidth:(NSString *)string{
    
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize labelSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    return labelSize;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.aSexView.layer.cornerRadius = 2;
    self.aSexView.clipsToBounds = YES;
    
    self.sexualLabel.layer.cornerRadius = 2;
    self.sexualLabel.clipsToBounds = YES;
    
    self.headView.layer.cornerRadius = 25;
    self.headView.clipsToBounds = YES;
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5" alpha:1];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickname.mas_left);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_offset(1);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
