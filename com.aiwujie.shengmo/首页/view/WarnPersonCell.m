//
//  WarnPersonCell.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/11/17.
//  Copyright © 2017年 a. All rights reserved.
//

#import "WarnPersonCell.h"

@implementation WarnPersonCell

-(void)setModel:(TableModel *)model{
    
    _model = model;
    
    [self createUI];
    
}

-(void)createUI{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_model.head_pic] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    if ([_model.onlinestate intValue] == 0) {
        
        self.onlineLabel.hidden = YES;
        
    }else{
        
        self.onlineLabel.hidden = NO;
    }
    
    self.nameLabel.text = _model.nickname;
    
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.nameLabel sizeToFit];
    
    self.nameW.constant = self.nameLabel.frame.size.width;
    
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
        
        self.idViewW.constant = 0;
        
    }else{
        
        self.idImageView.hidden = NO;
        
        self.idViewW.constant = 16;
    }

    if ([_model.role isEqualToString:@"S"]) {
        
        self.sexualLabel.text = @"斯";
        
        self.sexualLabel.backgroundColor = BOYCOLOR;
        
    }else if ([_model.role isEqualToString:@"M"]){
        
        self.sexualLabel.text = @"慕";
        
        self.sexualLabel.backgroundColor = GIRLECOLOR;
        
    }else if([_model.role isEqualToString:@"SM"]){
        
        self.sexualLabel.text = @"双";
        
        self.sexualLabel.backgroundColor = DOUBLECOLOR;
        
    }else{
        
        self.sexualLabel.text = @"~";
        self.sexualLabel.backgroundColor = GREENCOLORS;
    }
    
    if ([_model.sex intValue] == 1) {
        
        self.sexLabel.image = [UIImage imageNamed:@"男"];
        
        self.aSexView.backgroundColor = BOYCOLOR;
        
    }else if ([_model.sex intValue] == 2){
        
        self.sexLabel.image = [UIImage imageNamed:@"女"];
        
        self.aSexView.backgroundColor = GIRLECOLOR;
        
    }else{
        
        self.sexLabel.image = [UIImage imageNamed:@"双性"];
        
        self.aSexView.backgroundColor = DOUBLECOLOR;
    }
    
    self.ageLabel.text = [NSString stringWithFormat:@"%@",_model.age];
    
    if (![_model.city isEqual:[NSNull null]] && ![_model.province isEqual:[NSNull null]]) {
        
        if(_model.city.length != 0){
            
            if ([_model.city isEqualToString:_model.province]) {
                
                self.introduceLabel.text = _model.city;
                
            }else{
                
                if (_model.province.length != 0) {
                    
                    self.introduceLabel.text = [NSString stringWithFormat:@"%@ %@",_model.province,_model.city];
                    
                }else{
                    
                    self.introduceLabel.text = [NSString stringWithFormat:@"%@",_model.city];
                }
            }
            
        }else{
            
            self.introduceLabel.text = @"隐身";
            
        }
    }else{
        
        self.introduceLabel.text = @"隐身";
    }
    
    if ([self.content intValue] == 0) {
        
        if ([_model.dynamicstatus intValue] == 0 && [_model.infostatus intValue] == 0 && [_model.chatstatus intValue] == 0) {
        
            self.oneView.hidden = NO;
            self.twoView.hidden = NO;
            self.threeView.hidden = NO;
            
            self.oneLabel.text = @"ⓧ已禁动态";
            self.twoLabel.text = @"ⓧ已禁资料";
            self.threeLabel.text = @"ⓧ已禁聊天";
        
        }else if([_model.dynamicstatus intValue] == 1 && [_model.infostatus intValue] == 0 && [_model.chatstatus intValue] == 0){
            
            self.oneView.hidden = NO;
            self.twoView.hidden = NO;
            self.threeView.hidden = YES;
            
            self.oneLabel.text = @"ⓧ已禁资料";
            self.twoLabel.text = @"ⓧ已禁聊天";

        }else if ([_model.dynamicstatus intValue] == 0 && [_model.infostatus intValue] == 1 && [_model.chatstatus intValue] == 0){
            
            self.oneView.hidden = NO;
            self.twoView.hidden = NO;
            self.threeView.hidden = YES;
            
            self.oneLabel.text = @"ⓧ已禁动态";
            self.twoLabel.text = @"ⓧ已禁聊天";
            
        }else if ([_model.dynamicstatus intValue] == 0 && [_model.infostatus intValue] == 0 && [_model.chatstatus intValue] == 1){
            
            self.oneView.hidden = NO;
            self.twoView.hidden = NO;
            self.threeView.hidden = YES;
            
            self.oneLabel.text = @"ⓧ已禁动态";
            self.twoLabel.text = @"ⓧ已禁资料";
            
        }else{
            
            self.oneView.hidden = YES;
            self.twoView.hidden = NO;
            self.threeView.hidden = YES;
            
            if ([_model.dynamicstatus intValue] == 0) {
                
                self.twoLabel.text = @"ⓧ已禁动态";
                
            }else if ([_model.infostatus intValue] == 0){
                
                self.twoLabel.text = @"ⓧ已禁资料";
                
            }else if([_model.chatstatus intValue] == 0){
                
                self.twoLabel.text = @"ⓧ已禁聊天";
            }
        }
    }else if([self.content intValue] == 2){
        
        if ([_model.devicestatus intValue] == 0 && [_model.status intValue] == 0) {
            
            self.oneView.hidden = NO;
            self.twoView.hidden = NO;
            self.threeView.hidden = YES;
            
            self.oneLabel.text = @"ⓧ已禁设备";
            self.twoLabel.text = @"ⓧ已禁账号";
            
        }else{
            
            if ([_model.devicestatus intValue] == 0) {
                
                self.oneView.hidden = YES;
                self.twoView.hidden = NO;
                self.threeView.hidden = YES;
                
                self.twoLabel.text = @"ⓧ已禁设备";
                
            }else if([_model.status intValue] == 0){
                
                self.oneView.hidden = YES;
                self.twoView.hidden = NO;
                self.threeView.hidden = YES;
                
                self.twoLabel.text = @"ⓧ已禁账号";
            }
        }
    }
    
    [self getWealthAndCharmState:_wealthLabel andView:_wealthView andText:_model.wealth_val andNSLayoutConstraint:_wealthW andType:@"财富"];
    
    [self getWealthAndCharmState:_charmLabel andView:_charmView andText:_model.charm_val andNSLayoutConstraint:_charmW andType:@"魅力"];
    
    
}

-(void)getWealthAndCharmState:(UILabel *)label andView:(UIView *)backView andText:(NSString *)text andNSLayoutConstraint:(NSLayoutConstraint *)constraint andType:(NSString *)type{
    
    if ([type isEqualToString:@"财富"]) {
        
        if ([text intValue] == 0) {
            
            self.wealthSpace.constant = 0;
            
            backView.hidden = YES;
            
            constraint.constant = 0;
            
        }else{
            
            self.wealthSpace.constant = 5;
            
            backView.hidden = NO;
            
            label.text = [NSString stringWithFormat:@"%@",text];
            
            label.textColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1];
            backView.layer.borderColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1].CGColor;
            
            constraint.constant = 27 + [self fitLabelWidth:label.text].width;
        }
        
    }else{
        
        if ([text intValue] == 0) {
            
            backView.hidden = YES;
            
        }else{
            
            backView.hidden = NO;
            
            label.text = [NSString stringWithFormat:@"%@",text];
            
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
    
    self.oneView.layer.cornerRadius = 8;
    self.oneView.layer.masksToBounds = YES;
    
    self.twoView.layer.cornerRadius = 8;
    self.twoView.layer.masksToBounds = YES;
    
    self.threeView.layer.cornerRadius = 8;
    self.threeView.layer.masksToBounds = YES;
    
    self.headImageView.layer.cornerRadius = 29;
    self.headImageView.clipsToBounds = YES;
    
    self.aSexView.layer.cornerRadius = 2;
    self.aSexView.clipsToBounds = YES;
    
    self.sexualLabel.layer.cornerRadius = 2;
    self.sexualLabel.clipsToBounds = YES;
    
    self.onlineLabel.layer.cornerRadius = 4;
    self.onlineLabel.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
